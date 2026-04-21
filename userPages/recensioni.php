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

if ($_SERVER['REQUEST_METHOD'] === 'POST') {

    $idUtenteRicevente = $_POST['idUtenteRicevente'] ?? null;
    $voto              = $_POST['voto'] ?? null;
    $commento          = $_POST['commento'] ?? null;
    $idUtenteScrittore = $myId;

    if ($voto !== null && $commento !== null && $idUtenteRicevente !== null) {
        try {
            $sql = "INSERT INTO recensioni (idUtenteScrittore, idUtenteRicevente, voto, commento, dataRecensione) 
                    VALUES (:idUtenteScrittore, :idUtenteRicevente, :voto, :commento, NOW())";
            $sth = DBHandler::getPDO()->prepare($sql);
            $sth->execute([
                ':idUtenteScrittore' => $idUtenteScrittore,
                ':idUtenteRicevente' => $idUtenteRicevente,
                ':voto'              => $voto,
                ':commento'          => $commento,
            ]);

            if ($voto > 5) {
                $sqlP = "UPDATE utenti SET punteggioAffidabilita = punteggioAffidabilita + 3 
                         WHERE idUtente = :id";
                $stmtP = DBHandler::getPDO()->prepare($sqlP);
                $stmtP->execute([':id' => $idUtenteRicevente]);

            } elseif ($voto < 5) {
                $sqlP = "UPDATE utenti 
                         SET punteggioAffidabilita = GREATEST(0, punteggioAffidabilita - 2) 
                         WHERE idUtente = :id AND punteggioAffidabilita > 2";
                $stmtP = DBHandler::getPDO()->prepare($sqlP);
                $stmtP->execute([':id' => $idUtenteRicevente]);
            }

            $messaggioEsito = "Recensione salvata!";
            $salvato = true;

        } catch (PDOException $e) {
            $messaggioEsito = "Errore: " . $e->getMessage();
        }
    }
}

include '../include/menuChoice.php';
?>

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
            <div class="alert alert-info"><?= htmlspecialchars($messaggioEsito) ?></div>
        <?php endif; ?>

        <?php if (empty($salvato)): ?>
        <h5 class="mb-4">Lascia una recensione</h5>
        <form method="POST" action="recensioni.php">
            <input type="hidden" name="idUtenteRicevente" value="<?= htmlspecialchars($idUtenteRicevente ?? '') ?>">

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