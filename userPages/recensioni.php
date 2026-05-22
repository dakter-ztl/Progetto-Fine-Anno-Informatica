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

$myId = $_SESSION['idUtente'];
$messaggioEsito = '';
$salvato = false;

$idRisposta = $_POST['idRisposta'] ?? $_GET['idRisposta'] ?? null;
if ($idRisposta === null || !is_numeric($idRisposta)) {
    $messaggioEsito = "Errore: ID risposta non valido o mancante.";
}

$showForm = ($idRisposta !== null && empty($salvato));

if ($_SERVER['REQUEST_METHOD'] === 'POST') {

    $idRisposta = $_POST['idRisposta'] ?? null;
    $voto       = $_POST['voto'] ?? null;
    $commento   = trim($_POST['commento'] ?? '');

    if ($voto !== null && $voto >= 1 && $voto <= 10 && !empty($commento) && !empty($idRisposta)) {
        try {
            $sql = "CALL valutaRisposta(:idUtente, :idRisposta, :voto, :commento)";
            $sth = DBHandler::getPDO()->prepare($sql);
            $sth->execute([
                ':idUtente'   => $myId,
                ':idRisposta' => $idRisposta,
                ':voto'       => $voto,
                ':commento'   => $commento,
            ]);

            $messaggioEsito = "Recensione inviata! Verrà approvata da un amministratore prima di essere valida.";
            $salvato = true;

        } catch (PDOException $e) {
            $errore = $e->getMessage();
            if (preg_match('/1644 (.+)$/', $errore, $matches)) {
                $messaggioEsito = $matches[1];
            } else {
                $messaggioEsito = "Errore durante l'invio della recensione.";
            }
        }
    }
}

include '../include/menuChoice.php';
?>
<link href="../css/style.css" rel="stylesheet">

<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <title>Valuta questo utente</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">
<div class="container mt-5 mb-5">
    <div class="card shadow p-4">

        <?php if (!empty($messaggioEsito)): ?>
            <div class="alert <?= $salvato ? 'alert-success' : 'alert-danger' ?>">
                <?= htmlspecialchars($messaggioEsito) ?>
            </div>
        <?php endif; ?>

        <?php if ($showForm && !$salvato): ?>
        <h5 class="mb-4">Lascia una recensione</h5>
        <form method="POST" action="recensioni.php">
            <input type="hidden" name="idRisposta" value="<?= htmlspecialchars($idRisposta) ?>">

            <div class="mb-3">
                <label class="form-label fw-bold">Voto (1-10)</label>
                <input type="range" name="voto" class="form-range" min="1" max="10" value="5"
                       oninput="this.nextElementSibling.value = this.value">
                <output>5</output>
            </div>

            <div class="mb-3">
                <label class="form-label fw-bold">Motivazione</label>
                <textarea name="commento" class="form-control" required></textarea>
            </div>

            <button type="submit" class="btn btn-primary w-100">Invia recensione</button>
            <a href="bacheca.php" class="btn btn-secondary w-100 mt-2">Torna</a>
        </form>
        <?php else: ?>
            <a href="bacheca.php" class="btn btn-secondary w-100 mt-2">Torna alla bacheca</a>
        <?php endif; ?>

    </div>
</div>
</body>
</html>