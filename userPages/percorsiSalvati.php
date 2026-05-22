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

if (!isset($_SESSION['idUtente'])) {
    header("Location: ../include/loginForm.php");
    exit();
}

require_once '../include/DBHandler.php';

$db = DBHandler::getPDO();

// Gestione eliminazione percorso dai preferiti
if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['remove'])) {
    $idPercorsoToRemove = (int) $_POST['idPercorso'];
    $stmt = $db->prepare("DELETE FROM preferiti WHERE idUtente = ? AND idPercorso = ?");
    $stmt->execute([$_SESSION['idUtente'], $idPercorsoToRemove]);
    header("Location: " . $_SERVER['REQUEST_URI']);
    exit();
}

include '../include/menuChoice.php';

$stmt = $db->prepare("
    SELECT percorsi.*, categorie.nomeCategoria, preferiti.dataSalvataggio
    FROM percorsi
    JOIN categorie ON percorsi.idCategoria = categorie.idCategoria
    JOIN preferiti ON preferiti.idPercorso = percorsi.idPercorso
    WHERE preferiti.idUtente = ?
    ORDER BY preferiti.dataSalvataggio DESC
");
$stmt->execute([$_SESSION['idUtente']]);
$percorsiSalvati = $stmt->fetchAll(PDO::FETCH_ASSOC);
?>

<link href="../css/style.css" rel="stylesheet">

<div class="container mt-4 mb-5">
    <h1 class="mb-4">I miei percorsi salvati</h1>

    <?php if (empty($percorsiSalvati)): ?>
       <div class="alert alert-info">
     <h5>Non hai ancora salvato nessun percorso.</h5>
        <p>Vai al Simulatore per scoprire nuovi percorsi!</p>
        <a href="home.php" class="btn btn-primary">Vai al Simulatore</a>
</div>
    <?php else: ?>
        <div class="row">
            <?php foreach ($percorsiSalvati as $percorso): ?>
                <div class="col-md-6 col-lg-4 mb-4">
                    <div class="card shadow border-0 h-100">
                        <div class="card-header bg-primary text-white">
                            <span class="badge bg-light text-dark me-2"><?= htmlspecialchars($percorso['nomeCategoria']) ?></span>
                            <span class="badge bg-dark"><?= htmlspecialchars($percorso['citta']) ?></span>
                        </div>
                        <div class="card-body d-flex flex-column">
                            <h5 class="card-title"><?= htmlspecialchars($percorso['titolo']) ?></h5>
                            <p class="card-text text-muted flex-grow-1"><?= htmlspecialchars(substr($percorso['descrizione'], 0, 100)) ?>...</p>
                            <div class="mt-2">
                                <p class="mb-1 small text-muted">Costo: 
                                    <?php if ($percorso['costoMedioMensile'] == 0): ?>
                                        <span class="text-success fw-bold">Gratuito</span>
                                    <?php else: ?>
                                        <span class="fw-bold">€<?= number_format($percorso['costoMedioMensile'], 2) ?>/mese</span>
                                    <?php endif; ?>
                                </p>
                                <p class="mb-1 small text-muted">Difficoltà: <?= str_repeat('⭐', $percorso['difficolta']) . str_repeat('☆', 5 - $percorso['difficolta']) ?></p>
                                <p class="mb-1 small text-muted">Salvato il: <?= date('d/m/Y', strtotime($percorso['dataSalvataggio'])) ?></p>
                            </div>
                            <div class="d-flex gap-2 mt-3">
                                <a href="dettagliPercorso.php?idPercorso=<?= $percorso['idPercorso'] ?>" class="btn btn-primary">Vedi dettagli</a>
                                <form method="POST" class="d-inline" onsubmit="return confirm('Sei sicuro di voler rimuovere questo percorso dai preferiti?')">
                                    <input type="hidden" name="idPercorso" value="<?= $percorso['idPercorso'] ?>">
                                    <button type="submit" name="remove" class="btn btn-danger">Rimuovi</button>
                                </form>
                            </div>
                        </div>
                    </div>
                </div>
            <?php endforeach; ?>
        </div>
    <?php endif; ?>
</div>

</body>
</html>