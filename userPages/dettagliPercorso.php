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
include '../include/menuChoice.php';

if (!isset($_GET['idPercorso']) || !is_numeric($_GET['idPercorso'])) {
    echo "<div>
            <h5>Percorso non specificato.</h5>
            <a href='home.php' class='btn btn-dark mt-2'>Torna al Simulatore</a>
          </div></div>";
    exit();
}

$idPercorso = (int) $_GET['idPercorso'];
$db = DBHandler::getPDO();

$stmt = $db->prepare("
    SELECT p.*, c.nomeCategoria
    FROM percorsi p
    JOIN categorie c ON p.idCategoria = c.idCategoria
    WHERE p.idPercorso = ?
");
$stmt->execute([$idPercorso]);
$percorso = $stmt->fetch(PDO::FETCH_ASSOC);

if (!$percorso) {
    echo "<div class='container mt-5'><div class='alert alert-danger'>
            <h5>Percorso non trovato.</h5>
            <a href='home.php' class='btn btn-dark mt-2'>Torna al Simulatore</a>
          </div></div>";
    exit();
}


$stmtD = $db->prepare("SELECT * FROM dettagliPercorsi WHERE idPercorso = ?");
$stmtD->execute([$idPercorso]);
$dettagli = $stmtD->fetch(PDO::FETCH_ASSOC);


$stmtM = $db->prepare("
    SELECT m.nomeMateria
    FROM materie m
    JOIN percorsiMaterie pm ON m.idMateria = pm.idMateria
    WHERE pm.idPercorso = ?
");
$stmtM->execute([$idPercorso]);
$materie = $stmtM->fetchAll(PDO::FETCH_COLUMN);


$costoHtml = ($percorso['costoMedioMensile'] == 0)
    ? "<span class='text-success fw-bold fs-5'>Gratuito</span>"
    : "<span class='fw-bold fs-5'>€" . number_format($percorso['costoMedioMensile'], 2) . " / mese</span>";


$stelle = str_repeat('⭐', $percorso['difficolta']) . str_repeat('☆', 5 - $percorso['difficolta']);
?>

<div class="container mt-4 mb-5">

   
    <div class="card shadow border-0 mb-4">
        <div class="card-header bg-primary text-white d-flex justify-content-between align-items-center">
            <div>
                <span class="badge bg-light text-dark me-2"><?= htmlspecialchars($percorso['nomeCategoria']) ?></span>
                <span class="badge bg-dark"><?= htmlspecialchars($percorso['citta']) ?></span>
            </div>
            <small><?= $stelle ?></small>
        </div>
        <div class="card-body">
            <h2 class="card-title"><?= htmlspecialchars($percorso['titolo']) ?></h2>
            <p class="text-muted"><?= htmlspecialchars($percorso['descrizione']) ?></p>

            <div class="row mt-3">
                <div class="col-sm-4">
                    <p class="mb-1 text-muted small">Costo medio mensile</p>
                    <?= $costoHtml ?>
                </div>
                <div class="col-sm-4">
                    <p class="mb-1 text-muted small">Difficoltà</p>
                    <span class="fw-bold fs-5"><?= $percorso['difficolta'] ?> / 5</span>
                </div>
                <div class="col-sm-4">
                    <p class="mb-1 text-muted small">Città</p>
                    <span class="fw-bold fs-5">📍 <?= htmlspecialchars($percorso['citta']) ?></span>
                </div>
            </div>

            <?php if (!empty($materie)): ?>
                <div class="mt-3">
                    <p class="mb-1 text-muted small">Materie trattate</p>
                    <?php foreach ($materie as $m): ?>
                        <span class="badge bg-secondary me-1"><?= htmlspecialchars($m) ?></span>
                    <?php endforeach; ?>
                </div>
            <?php endif; ?>
        </div>
    </div>

   
    <?php if ($dettagli): ?>
    <div class="card shadow border-0 mb-4">
        <div class="card-header bg-dark text-white">
            <h5 class="mb-0">Informazioni pratiche</h5>
        </div>
        <div class="card-body">
            <div class="row">
                <div class="col-md-6 mb-3">
                    <p class="text-muted small mb-1">Indirizzo</p>
                    <p class="fw-bold" <?= htmlspecialchars($dettagli['indirizzo']) ?></p>
                </div>
                <div class="col-md-6 mb-3">
                    <p class="text-muted small mb-1">Orari di accoglienza</p>
                    <p class="fw-bold"><?= htmlspecialchars($dettagli['orariAccoglienza']) ?></p>
                </div>
                <div class="col-md-6 mb-3">
                    <p class="text-muted small mb-1">Telefono</p>
                    <p class="fw-bold"><?= htmlspecialchars($dettagli['nrTelefono']) ?></p>
                </div>
            </div>

            <?php if (!empty($dettagli['descrizione'])): ?>
                <hr>
                <p class="text-muted small mb-1">Descrizione dettagliata</p>
                <p><?= nl2br(htmlspecialchars($dettagli['descrizione'])) ?></p>
            <?php endif; ?>

            <?php if (!empty($dettagli['breakdownBudget'])): ?>
                <hr>
                <p class="text-muted small mb-1">Breakdown del budget</p>
                <p><?= nl2br(htmlspecialchars($dettagli['breakdownBudget'])) ?></p>
            <?php endif; ?>
        </div>
    </div>
    <?php else: ?>
    <div class="alert alert-info">
         I dettagli aggiuntivi per questo percorso non sono ancora stati inseriti.
    </div>
    <?php endif; ?>

   
    <div class="d-flex gap-2">
        <a href="home.php" class="btn btn-outline-secondary">← Torna al Simulatore</a>
        <?php if (isset($_SESSION['idUtente'])): ?>
            <a href="bacheca.php" class="btn btn-primary">Vai alla Bacheca</a>
        <?php endif; ?>
    </div>

</div>
</body>
</html>