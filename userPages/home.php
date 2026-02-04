<?php
include '../include/menuChoice.php';
?>

<div class="container mt-4">
    <div class="p-4 bg-white shadow-sm rounded">
        <h2 class="text-center mb-4">Trova il tuo Percorso 🔎</h2>
        <p class="text-center text-muted">Dicci cosa ti piace studiare e ti diremo cosa fare!</p>
        
        <form action="home.php" method="GET">
            
            <div class="mb-4">
                <label class="form-label fw-bold">Quali materie ti piacciono? (Seleziona almeno una)</label>
                <div class="row">
                    <?php
                    // Recupera le materie dal DB per creare le checkbox
                    $stmtM = DBHandler::getPDO()->query("SELECT * FROM materie");
                    while($materia = $stmtM->fetch()) {
                        // Controlliamo se era già selezionata (per non perdere la spunta dopo la ricerca)
                        $checked = (isset($_GET['materie']) && in_array($materia['idMateria'], $_GET['materie'])) ? 'checked' : '';
                        
                        echo '<div class="col-md-4 col-6 mb-2">
                                <div class="form-check">
                                    <input class="form-check-input" type="checkbox" name="materie[]" value="'.$materia['idMateria'].'" id="m_'.$materia['idMateria'].'" '.$checked.'>
                                    <label class="form-check-label" for="m_'.$materia['idMateria'].'">
                                        '.$materia['nomeMateria'].'
                                    </label>
                                </div>
                              </div>';
                    }
                    ?>
                </div>
            </div>

            <hr>

            <div class="row g-3">
                <div class="col-md-3">
                    <label class="form-label">Budget Max (€)</label>
                    <input type="number" name="budget" class="form-control" placeholder="es. 500" value="<?= isset($_GET['budget']) ? htmlspecialchars($_GET['budget']) : '' ?>">
                </div>
                <div class="col-md-3">
                    <label class="form-label">Città</label>
                    <input type="text" name="citta" class="form-control" placeholder="es. Milano" value="<?= isset($_GET['citta']) ? htmlspecialchars($_GET['citta']) : '' ?>">
                </div>
                <div class="col-md-3">
                    <label class="form-label">Difficoltà Esatta (1-5)</label>
                    <input type="number" name="difficolta" class="form-control" max="5" min="1" placeholder="es. 5" value="<?= isset($_GET['difficolta']) ? htmlspecialchars($_GET['difficolta']) : '' ?>">
                </div>
                <div class="col-md-3 align-self-end">
                    <button type="submit" class="btn btn-primary w-100">Consigliami! 🎓</button>
                </div>
            </div>
        </form>
    </div>

    <div class="row mt-4">
        <?php
        // Avvia la ricerca solo se ho premuto il tasto (o se c'è qualcosa nell'URL)
        if(count($_GET) > 0) { 
            
            // Query Base: DISTINCT serve per non mostrare lo stesso corso 2 volte se piace sia Mate che Fisica
            $sql = "SELECT DISTINCT p.*, c.nomeCategoria 
                    FROM percorsi p 
                    JOIN categorie c ON p.idCategoria = c.idCategoria ";
            
            // SE HO SELEZIONATO MATERIE, DEVO UNIRE LA TABELLA DI COLLEGAMENTO
            if(isset($_GET['materie']) && count($_GET['materie']) > 0) {
                $sql .= " JOIN percorsi_materie pm ON p.idPercorso = pm.idPercorso ";
            }

            $sql .= " WHERE 1=1"; // Trucco per concatenare gli AND
            
            $params = [];

            // 1. FILTRO MATERIE (Cuore del consiglio)
            if(isset($_GET['materie']) && count($_GET['materie']) > 0) {
                // Crea una stringa di punti interrogativi tipo (?,?,?) in base a quante materie ho scelto
                $inQuery = implode(',', array_fill(0, count($_GET['materie']), '?'));
                
                $sql .= " AND pm.idMateria IN ($inQuery)";
                
                // Aggiungiamo i valori dei parametri all'array $params
                foreach($_GET['materie'] as $idMat) {
                    $params[] = $idMat;
                }
            }

            // 2. ALTRI FILTRI (Usiamo parametri nominati qui è un casino misto con posizionali, 
            // quindi per sicurezza usiamo bindValue posizionale per tutto o dobbiamo stare attenti.
            // SOLUZIONE PROF STYLE: Costruiamo tutto posizionale (?) per evitare conflitti.
            
            if(isset($_GET['budget']) && $_GET['budget'] !== '') {
                $sql .= " AND p.costoMedioMensile <= ?";
                $params[] = $_GET['budget'];
            }

            if(isset($_GET['citta']) && $_GET['citta'] !== '') {
                $sql .= " AND p.citta LIKE ?";
                $params[] = "%" . $_GET['citta'] . "%";
            }

            if(isset($_GET['difficolta']) && $_GET['difficolta'] !== '') {
                $sql .= " AND p.difficolta = ?";
                $params[] = $_GET['difficolta'];
            }

            try {
                $sth = DBHandler::getPDO()->prepare($sql);
                $sth->execute($params);
                $risultati = $sth->fetchAll();

                if(count($risultati) > 0) {
                    echo '<h4 class="mb-3 w-100">Ecco cosa ti consigliamo:</h4>';
                    foreach($risultati as $corso) {
                        
                        if ($corso['costoMedioMensile'] == 0) {
                            $prezzoText = "<span class='text-success fw-bold'>GRATIS</span>";
                        } else {
                            $prezzoText = "€" . $corso['costoMedioMensile'] . " /mese";
                        }

                        // Recuperiamo le materie di QUESTO singolo corso per mostrarle nella card
                        $stmtMat = DBHandler::getPDO()->prepare("
                            SELECT m.nomeMateria FROM materie m 
                            JOIN percorsi_materie pm ON m.idMateria = pm.idMateria 
                            WHERE pm.idPercorso = ?");
                        $stmtMat->execute([$corso['idPercorso']]);
                        $materieCorso = $stmtMat->fetchAll(PDO::FETCH_COLUMN);
                        $materieString = implode(", ", $materieCorso);

                        echo '
                        <div class="col-md-4 mb-4">
                            <div class="card h-100 shadow-sm border-0">
                                <div class="card-header bg-primary text-white d-flex justify-content-between">
                                    <span>' . htmlspecialchars($corso['nomeCategoria']) . '</span>
                                    <small>Dif: ' . $corso['difficolta'] . '/5</small>
                                </div>
                                <div class="card-body">
                                    <h5 class="card-title">' . htmlspecialchars($corso['titolo']) . '</h5>
                                    <p class="card-text text-muted small">' . htmlspecialchars($corso['descrizione']) . '</p>
                                    
                                    <div class="mb-3">
                                        <span class="badge bg-light text-dark border">📚 Materie: ' . $materieString . '</span>
                                    </div>

                                    <ul class="list-group list-group-flush">
                                        <li class="list-group-item px-0">💰 Costo: ' . $prezzoText . '</li>
                                        <li class="list-group-item px-0">📍 Città: ' . htmlspecialchars($corso['citta']) . '</li>
                                    </ul>
                                </div>
                                <div class="card-footer bg-white border-top-0 text-end">
                                    <button class="btn btn-outline-primary btn-sm">Dettagli</button>
                                </div>
                            </div>
                        </div>';
                    }
                } else {
                    echo '<div class="alert alert-warning mt-3 w-100 text-center">
                            <h5>Nessun percorso trovato! 😢</h5>
                            <p>Prova a selezionare meno materie o togliere i filtri di budget/città.</p>
                          </div>';
                }
            } catch(PDOException $e) {
                echo '<div class="alert alert-danger">Errore Database: ' . $e->getMessage() . '</div>';
            }
        }
        ?>
    </div>
</div>
</body>
</html>