<?php
session_set_cookie_params([
    'path' => '/',
    'secure' => isset($_SERVER['HTTPS']),
    'httponly' => true,
    'samesite' => 'Lax'
]);

if (session_status() === PHP_SESSION_NONE) {
    session_start();
}



ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);

require_once '../include/DBHandler.php';
include '../include/menuChoice.php';

$dbConnection = DBHandler::getPDO(); 
?>

<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <title>Home - NextStep</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="../css/style.css" rel="stylesheet"> 
</head>
<body class="bg-light">

<div class="container mt-4">
    <div class="p-4 bg-white shadow-sm rounded">
        <h2 class="text-center mb-4">Trova il tuo Percorso 🔎</h2>
        <p class="text-center text-muted">
            Bentornato, <strong><?= htmlspecialchars($_SESSION['nomeUtente'] ?? 'Studente') ?></strong>! Dicci cosa ti piace studiare.
        </p>
        
        <form action="home.php" method="GET">
            <div class="mb-4">
               <label class="form-label fw-bold">Quali materie ti piacciono? (Seleziona almeno una)</label>
<div class="scroll-container-materie">
    <div class="grid-materie">
        <?php
        try {
            $stmtM = $dbConnection->query("SELECT * FROM materie ORDER BY nomeMateria ASC");
            while($materia = $stmtM->fetch()) {
                $isChecked = (isset($_GET['materie']) && in_array($materia['idMateria'], $_GET['materie'])) ? 'checked' : '';
                
                echo '<div class="form-check">
                        <input class="form-check-input" type="checkbox" name="materie[]" value="'.$materia['idMateria'].'" id="m_'.$materia['idMateria'].'" '.$isChecked.'>
                        <label class="form-check-label" for="m_'.$materia['idMateria'].'">
                            '.htmlspecialchars($materia['nomeMateria']).'
                        </label>
                      </div>';
            }
        } catch (PDOException $e) { /* ... */ }
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
        if (isset($_GET['materie']) || isset($_GET['budget']) || isset($_GET['citta']) || isset($_GET['difficolta'])) { 
            
            $sql = "SELECT DISTINCT p.*, c.nomeCategoria 
                    FROM percorsi p 
                    JOIN categorie c ON p.idCategoria = c.idCategoria ";
            
            if (isset($_GET['materie']) && count($_GET['materie']) > 0) {
                $sql .= " JOIN percorsi_materie pm ON p.idPercorso = pm.idPercorso ";
            }

            $sql .= " WHERE 1=1";
            $queryParams = [];

            if (isset($_GET['materie']) && count($_GET['materie']) > 0) {
                $inQuery = implode(',', array_fill(0, count($_GET['materie']), '?'));
                $sql .= " AND pm.idMateria IN ($inQuery)";
                $queryParams = array_merge($queryParams, $_GET['materie']);
            }

            if (isset($_GET['budget']) && $_GET['budget'] !== '') {
                $sql .= " AND p.costoMedioMensile <= ?";
                $queryParams[] = $_GET['budget'];
            }

            if (isset($_GET['citta']) && $_GET['citta'] !== '') {
                $sql .= " AND p.citta LIKE ?";
                $queryParams[] = "%" . $_GET['citta'] . "%";
            }

            if (isset($_GET['difficolta']) && $_GET['difficolta'] !== '') {
                $sql .= " AND p.difficolta = ?";
                $queryParams[] = $_GET['difficolta'];
            }

            try {
                $sth = $dbConnection->prepare($sql);
                $sth->execute($queryParams);
                $risultatiPercorsi = $sth->fetchAll();

                if (count($risultatiPercorsi) > 0) {
                    echo '<h4 class="mb-3 w-100">Ecco cosa ti consigliamo:</h4>';
                    foreach ($risultatiPercorsi as $corso) {
                        
                        $prezzoVisualizzato = ($corso['costoMedioMensile'] == 0) 
                            ? "<span class='text-success fw-bold'>GRATIS</span>" 
                            : "€" . number_format($corso['costoMedioMensile'], 2) . " /mese";

                        $stmtMat = $dbConnection->prepare("
                            SELECT m.nomeMateria FROM materie m 
                            JOIN percorsi_materie pm ON m.idMateria = pm.idMateria 
                            WHERE pm.idPercorso = ?");
                        $stmtMat->execute([$corso['idPercorso']]);
                        $materieDelCorso = $stmtMat->fetchAll(PDO::FETCH_COLUMN);
                        $stringaMaterie = implode(", ", $materieDelCorso);

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
                                        <span class="badge bg-light text-dark border">📚 Materie: ' . htmlspecialchars($stringaMaterie) . '</span>
                                    </div>

                                    <ul class="list-group list-group-flush">
                                        <li class="list-group-item px-0">💰 Costo: ' . $prezzoVisualizzato . '</li>
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
            } catch (PDOException $e) {
                echo '<div class="alert alert-danger">Errore Database: ' . $e->getMessage() . '</div>';
            }
        }
        ?>
    </div>
</div>

</body>
</html>