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

require_once '../include/DBHandler.php';

if (!isset($_SESSION['idUtente'])) {
    header("Location: ../include/loginForm.php");
    exit();
}

$isAdmin = (isset($_SESSION['ruoloUtente']) && $_SESSION['ruoloUtente'] == 'admin');
$myId = $_SESSION['idUtente'];
$myNome = $_SESSION['nomeUtente'] ?? 'Utente';

if (isset($_POST['delete_type'])) {
    $idToDelete = $_POST['delete_id'];
    
    if ($_POST['delete_type'] == 'annuncio') {
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

if ($_SERVER['REQUEST_METHOD'] == 'POST' && isset($_POST['azione']) && $_POST['azione'] == 'nuovo_annuncio') {
    try {
        $sql = "CALL publicaAnnuncio(:uid, :tit, :test)";
        $stmt = DBHandler::getPDO()->prepare($sql);
        $stmt->execute([
            ':tit' => $_POST['titolo'], 
            ':test' => $_POST['testo'], 
            ':uid' => $myId
        ]);
        header("Location: bacheca.php");
        exit;
    } catch (PDOException $e) {
        $errore = $e->getMessage();
        if (preg_match('/1644 (.+)$/', $errore, $matches)) {
            $erroreForm = $matches[1];
        } else {
            $erroreForm = "Errore durante la pubblicazione.";
        }
    }
}

if ($_SERVER['REQUEST_METHOD'] == 'POST' && isset($_POST['azione']) && $_POST['azione'] == 'toggle_stato' && $isAdmin) {
    $idAnnuncio = $_POST['id_annuncio'];
    $nuovoStato = $_POST['nuovo_stato'];

    $sql = "UPDATE annunci SET stato = :stato WHERE idAnnuncio = :id";
    $stmt = DBHandler::getPDO()->prepare($sql);
    $stmt->execute([':stato' => $nuovoStato, ':id' => $idAnnuncio]);
    header("Location: bacheca.php");
    exit;
}

if ($_SERVER['REQUEST_METHOD'] == 'POST' && isset($_POST['azione']) && $_POST['azione'] == 'risposta_pubblica') {
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

    if ($autoreAnnuncioId != $myId) {
        $msgNotifica = $myNome . " ha commentato il tuo post in bacheca.";
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

include '../include/menuChoice.php';
?>
<link href="../css/style.css" rel="stylesheet">

<div class="container mt-4">
    <div class="card mb-5 shadow-sm bg-light border-0">
        <div class="card-body">
            <h5 class="text-primary mb-3">Scrivi un annuncio</h5>

            <?php if (isset($erroreForm)): ?>
                <div class="alert alert-danger"><?= htmlspecialchars($erroreForm) ?></div>
            <?php endif; ?>

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

    <div class="d-flex justify-content-between align-items-center mb-4">
        <h4>Discussioni recenti</h4>
        <form method="GET" class="d-flex gap-2">
            <select name="filtro_stato" class="form-select form-select-sm" style="width: auto;" onchange="this.form.submit()">
                <option value="tutti" <?= (!isset($_GET['filtro_stato']) || $_GET['filtro_stato'] == 'tutti') ? 'selected' : '' ?>>Tutti gli annunci</option>
                <option value="aperto" <?= (isset($_GET['filtro_stato']) && $_GET['filtro_stato'] == 'aperto') ? 'selected' : '' ?>>Solo Attivi</option>
                <option value="chiuso" <?= (isset($_GET['filtro_stato']) && $_GET['filtro_stato'] == 'chiuso') ? 'selected' : '' ?>>Solo Chiusi</option>
            </select>
        </form>
    </div>
    
    <?php
    $filtroStato = $_GET['filtro_stato'] ?? 'tutti';

    $sql = "SELECT a.*, u.nome AS nomeUtente, u.ruolo AS ruoloUtente, u.idUtente as idAutore 
            FROM annunci a
            JOIN utenti u ON a.idUtente = u.idUtente WHERE 1=1";
    
    $params = [];
    if ($filtroStato !== 'tutti') {
        $sql .= " AND a.stato = :stato";
        $params[':stato'] = $filtroStato;
    }

    $sql .= " ORDER BY a.dataPubblicazione DESC";
    
    $sth = DBHandler::getPDO()->prepare($sql);
    $sth->execute($params);
    $annunci = $sth->fetchAll();

    foreach ($annunci as $annuncio): 
        $isMioPost = ($annuncio['idAutore'] == $myId);
    ?>
        <div class="card mb-4 shadow border-0">
            <div class="card-body">
                <div class="d-flex justify-content-between align-items-start">
                    <div>
                        <span class="badge rounded-pill mb-2 <?= ($annuncio['stato'] === 'aperto') ? 'bg-success' : 'bg-danger' ?>">
                            <?= ($annuncio['stato'] === 'aperto') ? 'Attivo' : 'Chiuso' ?>
                        </span>
                        <h4 class="card-title d-inline text-primary"><?= htmlspecialchars($annuncio['titolo']) ?></h4>
                        <div class="mt-1">
                            <span class="text-muted small">Pubblicato da:</span>
                            <a href="visualizzaProfilo.php?idUtente=<?= $annuncio['idAutore'] ?>" class="text-decoration-none fw-bold text-dark">
                                <?= htmlspecialchars($annuncio['nomeUtente']) ?>
                            </a>
                            <span class="badge bg-secondary ms-1"><?= ucfirst($annuncio['ruoloUtente']) ?></span>
                            <span class="text-muted small ms-2">- <?= date('d/m H:i', strtotime($annuncio['dataPubblicazione'])) ?></span>
                        </div>
                    </div>

                    <?php if ($isAdmin || $isMioPost): ?>
                        <div class="d-flex gap-1">
                            <?php if ($isAdmin): ?>
                                <form method="POST">
                                    <input type="hidden" name="azione" value="toggle_stato">
                                    <input type="hidden" name="id_annuncio" value="<?= $annuncio['idAnnuncio'] ?>">
                                    <input type="hidden" name="nuovo_stato" value="<?= ($annuncio['stato'] === 'aperto') ? 'chiuso' : 'aperto' ?>">
                                    <button type="submit" class="btn btn-outline-warning btn-sm">Cambia Stato</button>
                                </form>
                            <?php endif; ?>
                            <form method="POST" onsubmit="return confirm('Sei sicuro di voler cancellare questo post?');">
                                <input type="hidden" name="delete_type" value="annuncio">
                                <input type="hidden" name="delete_id" value="<?= $annuncio['idAnnuncio'] ?>">
                                <button class="btn btn-outline-danger btn-sm">🗑️</button>
                            </form>
                        </div>
                    <?php endif; ?>
                </div>

                <p class="card-text mt-3 fs-5"><?= nl2br(htmlspecialchars($annuncio['testo'])) ?></p>
                <hr>

                <div class="ms-4 bg-light p-3 rounded">
                    <h6 class="text-muted mb-3">Risposte:</h6>
                    <?php
                    $sqlR = "SELECT r.*, u.nome AS nomeUtente, u.idUtente as idAutoreRisp 
                             FROM risposte r 
                             JOIN utenti u ON r.idUtente = u.idUtente 
                             WHERE idAnnuncio = :idA ORDER BY dataRisposta ASC";
                    $stmtR = DBHandler::getPDO()->prepare($sqlR);
                    $stmtR->execute([':idA' => $annuncio['idAnnuncio']]);
                    $risposte = $stmtR->fetchAll();

                    foreach ($risposte as $risp): 
                        $isMiaRisp = ($risp['idAutoreRisp'] == $myId);
                    ?>
                        <div class="d-flex justify-content-between align-items-center border-bottom mb-2 pb-1">
                            <div>
                                <a href="visualizzaProfilo.php?idUtente=<?= $risp['idAutoreRisp'] ?>" class="fw-bold text-dark text-decoration-none">
                                    <?= htmlspecialchars($risp['nomeUtente']) ?>:
                                </a> 
                                <span class="ms-1"><?= htmlspecialchars($risp['testo']) ?></span>
                            </div>
                            
                            <div class="d-flex align-items-center gap-2">
                                <?php if (!$isMiaRisp): ?>
                                    <form method="POST" action="recensioni.php" class="m-0">
                                        <input type="hidden" name="idRisposta" value="<?= $risp['idRisposta'] ?>">
                                        <button type="submit" class="btn btn-secondary btn-sm">Valuta risposta</button>
                                    </form>
                                <?php endif; ?>

                                <?php if ($isMiaRisp || $isAdmin): ?>
                                    <form method="POST" class="m-0">
                                        <input type="hidden" name="delete_type" value="risposta">
                                        <input type="hidden" name="delete_id" value="<?= $risp['idRisposta'] ?>">
                                        <button class="btn btn-sm text-danger border-0 p-0 fw-bold">✕</button>
                                    </form>
                                <?php endif; ?>
                            </div>
                        </div>
                    <?php endforeach; ?>

                    <?php if ($annuncio['stato'] === 'aperto'): ?>
                        <form method="POST" class="mt-3 d-flex gap-2">
                            <input type="hidden" name="azione" value="risposta_pubblica">
                            <input type="hidden" name="id_annuncio" value="<?= $annuncio['idAnnuncio'] ?>">
                            <input type="hidden" name="id_autore_annuncio" value="<?= $annuncio['idAutore'] ?>">
                            <input type="text" name="testo_risposta" class="form-control form-control-sm" placeholder="Rispondi..." required>
                            <button type="submit" class="btn btn-secondary btn-sm">Invia</button>
                        </form>
                    <?php endif; ?>
                </div>
            </div>
        </div>
    <?php endforeach; ?>
</div>

</body>
</html>