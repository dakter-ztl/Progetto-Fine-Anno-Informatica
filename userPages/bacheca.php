<?php
include '../include/menuChoice.php';

$isAdmin = (isset($_SESSION['ruolo']) && $_SESSION['ruolo'] == 'admin');
$myId = $_SESSION['userId'];

if(isset($_POST['delete_type'])) {
    $idToDelete = $_POST['delete_id'];
    
    if($_POST['delete_type'] == 'annuncio') {
        $sql = "DELETE FROM annunci WHERE idAnnuncio = :id AND (idUtente = :me OR :admin = 1)";
    } else {
        $sql = "DELETE FROM risposte WHERE idRisposta = :id AND (idUtente = :me OR :admin = 1)";
    }
    
    $stmt = DBHandler::getPDO()->prepare($sql);
    $stmt->execute([
        ':id' => $idToDelete, 
        ':me' => $myId, 
        ':admin' => ($isAdmin ? 1 : 0)
    ]);
    
    header("Location: bacheca.php"); 
    exit;
}

if($_SERVER['REQUEST_METHOD'] == 'POST' && isset($_POST['azione']) && $_POST['azione'] == 'nuovo_annuncio') {
    $sql = "INSERT INTO annunci (titolo, testo, idUtente) VALUES (:tit, :test, :uid)";
    $stmt = DBHandler::getPDO()->prepare($sql);
    $stmt->execute([
        ':tit' => $_POST['titolo'], 
        ':test' => $_POST['testo'], 
        ':uid' => $myId
    ]);
    header("Location: bacheca.php"); 
    exit;
}

if($_SERVER['REQUEST_METHOD'] == 'POST' && isset($_POST['azione']) && $_POST['azione'] == 'risposta_pubblica') {
    $idAnnuncio = $_POST['id_annuncio'];
    $autoreAnnuncioId = $_POST['id_autore_annuncio'];
    $testoRisp = $_POST['testo_risposta'];

    $sql = "INSERT INTO risposte (testo, idAnnuncio, idUtente) VALUES (:testo, :idAnn, :uid)";
    $stmt = DBHandler::getPDO()->prepare($sql);
    $stmt->execute([
        ':testo' => $testoRisp, 
        ':idAnn' => $idAnnuncio, 
        ':uid' => $myId
    ]);

    if($autoreAnnuncioId != $myId) {
        $msgNotifica = $_SESSION['nome'] . " ha commentato il tuo post in bacheca.";
        
        $sqlN = "INSERT INTO notifiche (idUtente, testo) VALUES (:dest, :msg)";
        $stmtN = DBHandler::getPDO()->prepare($sqlN);
        $stmtN->execute([
            ':dest' => $autoreAnnuncioId, 
            ':msg' => $msgNotifica
        ]);
    }

    header("Location: bacheca.php"); 
    exit;
}
?>

<div class="container mt-4">
    
    <div class="card mb-5 shadow-sm bg-light border-0">
        <div class="card-body">
            <h5 class="text-primary mb-3">✍️ Scrivi in Bacheca</h5>
            <form method="POST" action="bacheca.php">
                <input type="hidden" name="azione" value="nuovo_annuncio">
                <div class="mb-2">
                    <input type="text" name="titolo" class="form-control" placeholder="Titolo discussione..." required>
                </div>
                <div class="mb-2">
                    <textarea name="testo" class="form-control" rows="2" placeholder="Di cosa vuoi parlare?" required></textarea>
                </div>
                <button type="submit" class="btn btn-primary btn-sm">Pubblica</button>
            </form>
        </div>
    </div>

    <h4 class="mb-4">📌 Discussioni Recenti</h4>
    
    <?php
    $sql = "SELECT a.*, u.nome, u.ruolo, u.idUtente as idAutore 
            FROM annunci a 
            JOIN utenti u ON a.idUtente = u.idUtente 
            ORDER BY a.dataPubblicazione DESC";
    $sth = DBHandler::getPDO()->prepare($sql);
    $sth->execute();
    $annunci = $sth->fetchAll();

    foreach($annunci as $annuncio): 
        $isMioPost = ($annuncio['idAutore'] == $myId);
    ?>
        <div class="card mb-4 shadow border-0">
            <div class="card-body">
                
                <div class="d-flex justify-content-between align-items-start">
                    <div>
                        <h4 class="card-title d-inline text-primary"><?= htmlspecialchars($annuncio['titolo']) ?></h4>
                        <div class="mt-1">
                            <span class="text-muted small">Pubblicato da:</span>
                            <a href="profilo_pubblico.php?id=<?= $annuncio['idAutore'] ?>" class="text-decoration-none fw-bold text-dark">
                                <?= htmlspecialchars($annuncio['nome']) ?>
                            </a>
                            <span class="badge bg-secondary ms-1"><?= $annuncio['ruolo'] ?></span>
                            <span class="text-muted small ms-2">- <?= $annuncio['dataPubblicazione'] ?></span>
                        </div>
                    </div>
                    
                    <?php if($isMioPost || $isAdmin): ?>
                        <form method="POST" onsubmit="return confirm('Sei sicuro di voler cancellare questo post?');">
                            <input type="hidden" name="delete_type" value="annuncio">
                            <input type="hidden" name="delete_id" value="<?= $annuncio['idAnnuncio'] ?>">
                            <button class="btn btn-outline-danger btn-sm" title="Cancella Post">🗑️</button>
                        </form>
                    <?php endif; ?>
                </div>

                <p class="card-text mt-3 fs-5"><?= nl2br(htmlspecialchars($annuncio['testo'])) ?></p>
                <hr>

                <div class="ms-4 bg-light p-3 rounded">
                    <h6 class="text-muted mb-3">Risposte:</h6>

                    <?php
                    
                    $sqlR = "SELECT r.*, u.nome, u.idUtente as idAutoreRisp FROM risposte r 
                             JOIN utenti u ON r.idUtente = u.idUtente 
                             WHERE idAnnuncio = :idA ORDER BY dataRisposta ASC";
                    $stmtR = DBHandler::getPDO()->prepare($sqlR);
                    $stmtR->execute([':idA' => $annuncio['idAnnuncio']]);
                    $risposte = $stmtR->fetchAll();

                    if(count($risposte) > 0) {
                        foreach($risposte as $risp): 
                            $isMiaRisp = ($risp['idAutoreRisp'] == $myId);
                        ?>
                            <div class="d-flex justify-content-between align-items-center border-bottom mb-2 pb-1">
                                <div>
                                    <a href="profilo_pubblico.php?id=<?= $risp['idAutoreRisp'] ?>" class="fw-bold text-dark text-decoration-none">
                                        <?= htmlspecialchars($risp['nome']) ?>:
                                    </a> 
                                    <span class="ms-1"><?= htmlspecialchars($risp['testo']) ?></span>
                                </div>
                                
                                <?php if($isMiaRisp || $isAdmin): ?>
                                    <form method="POST" style="display:inline;" onsubmit="return confirm('Cancellare questo commento?');">
                                        <input type="hidden" name="delete_type" value="risposta">
                                        <input type="hidden" name="delete_id" value="<?= $risp['idRisposta'] ?>">
                                        <button class="btn btn-sm text-danger border-0 p-0 fw-bold" title="Rimuovi">✕</button>
                                    </form>
                                <?php endif; ?>
                            </div>
                        <?php endforeach; 
                    } else {
                        echo "<p class='small text-muted'>Nessuna risposta. Sii il primo!</p>";
                    }
                    ?>

                    <form method="POST" class="mt-3 d-flex gap-2">
                        <input type="hidden" name="azione" value="risposta_pubblica">
                        <input type="hidden" name="id_annuncio" value="<?= $annuncio['idAnnuncio'] ?>">
                        <input type="hidden" name="id_autore_annuncio" value="<?= $annuncio['idAutore'] ?>">
                        
                        <input type="text" name="testo_risposta" class="form-control form-control-sm" placeholder="Scrivi una risposta pubblica..." required>
                        <button type="submit" class="btn btn-secondary btn-sm">Invia</button>
                    </form>
                </div>
            </div>
        </div>
    <?php endforeach; ?>
</div>
</body>
</html>