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

if (!isset($_SESSION['idUtente']) || $_SESSION['ruoloUtente'] !== 'admin') {
    header("Location: ../include/loginForm.php");
    exit();
}

$messaggio = '';

if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['approva'])) {
    $idRecensione = $_POST['idRecensione'];
    try {
        $sql = "CALL approvaRecensione(:idRecensione)";
        $sth = DBHandler::getPDO()->prepare($sql);
        $sth->execute([':idRecensione' => $idRecensione]);
        $messaggio = "Recensione approvata con successo.";
    } catch (PDOException $e) {
        $messaggio = "Errore: " . $e->getMessage();
    }
}

if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['rifiuta'])) {
    $idRecensione = $_POST['idRecensione'];
    try {
        $sql = "DELETE FROM recensioni WHERE idRecensione = :idRecensione AND approvata = FALSE";
        $sth = DBHandler::getPDO()->prepare($sql);
        $sth->execute([':idRecensione' => $idRecensione]);
        $messaggio = "Recensione rifiutata e eliminata.";
    } catch (PDOException $e) {
        $messaggio = "Errore: " . $e->getMessage();
    }
}

include '../include/adminMenu.php';
?>
<link href="../css/style.css" rel="stylesheet">

<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <title>Gestisci Recensioni</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">
<div class="container mt-5">
    <div class="card shadow p-4">
        <h4 class="mb-4">Recensioni in Attesa di Approvazione</h4>

        <?php if (!empty($messaggio)): ?>
            <div class="alert alert-info"><?= htmlspecialchars($messaggio) ?></div>
        <?php endif; ?>

        <?php
        $sql = "SELECT r.idRecensione, r.voto, r.commento, r.dataRecensione,
                       u1.nome AS scrittore, u2.nome AS ricevente,
                       risp.testo AS testoRisposta
                FROM recensioni r
                JOIN utenti u1 ON r.idUtenteScirttore = u1.idUtente
                JOIN utenti u2 ON r.idUtenteRicevente = u2.idUtente
                JOIN risposte risp ON r.idRisposta = risp.idRisposta
                WHERE r.approvata = FALSE
                ORDER BY r.dataRecensione DESC";
        $stmt = DBHandler::getPDO()->query($sql);
        $recensioni = $stmt->fetchAll();

        if (empty($recensioni)): ?>
            <p>Nessuna recensione in attesa di approvazione.</p>
        <?php else: ?>
            <div class="row">
                <?php foreach ($recensioni as $rec): ?>
                    <div class="col-md-6 mb-4">
                        <div class="card">
                            <div class="card-body">
                                <h6 class="card-title">Da: <?= htmlspecialchars($rec['scrittore']) ?> a: <?= htmlspecialchars($rec['ricevente']) ?></h6>
                                <p class="card-text"><strong>Risposta valutata:</strong> <?= htmlspecialchars(substr($rec['testoRisposta'], 0, 100)) ?>...</p>
                                <p class="card-text"><strong>Voto:</strong> <?= $rec['voto'] ?>/10</p>
                                <p class="card-text"><strong>Commento:</strong> <?= htmlspecialchars($rec['commento']) ?></p>
                                <p class="card-text"><small class="text-muted">Data: <?= $rec['dataRecensione'] ?></small></p>
                                <div class="d-flex gap-2">
                                    <form method="POST" class="d-inline">
                                        <input type="hidden" name="idRecensione" value="<?= $rec['idRecensione'] ?>">
                                        <button type="submit" name="approva" class="btn btn-success btn-sm">Approva</button>
                                    </form>
                                    <form method="POST" class="d-inline">
                                        <input type="hidden" name="idRecensione" value="<?= $rec['idRecensione'] ?>">
                                        <button type="submit" name="rifiuta" class="btn btn-danger btn-sm" onclick="return confirm('Sei sicuro di voler rifiutare questa recensione?')">Rifiuta</button>
                                    </form>
                                </div>
                            </div>
                        </div>
                    </div>
                <?php endforeach; ?>
            </div>
        <?php endif; ?>
    </div>
       <a href="../userPages/home.php" class="btn btn-secondary w-100 mt-2">Torna alla Dashboard </a>

</div>
</body>
</html>