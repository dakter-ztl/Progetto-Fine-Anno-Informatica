<?php
session_set_cookie_params(['path' => '/']);
if (session_status() === PHP_SESSION_NONE) {
    session_start();
}

require_once '../include/DBHandler.php';
include '../include/menuChoice.php';

$idUtenteVisualizzato = 0;
if (isset($_GET['idUtente']) && is_numeric($_GET['idUtente'])) {
    $idUtenteVisualizzato = (int)$_GET['idUtente'];
} elseif (isset($_GET['id']) && is_numeric($_GET['id'])) {
    $idUtenteVisualizzato = (int)$_GET['id'];
}

if ($idUtenteVisualizzato <= 0) {
    echo "<div class='container mt-5 alert alert-danger'>";
    echo "<h4>⚠️ UTENTE NON SPECIFICATO</h4>";
    echo "<p>Il link non ha passato l'ID correttamente.</p>";
    echo "<strong>Ecco i dati ricevuti (DEBUG):</strong><pre>";
    var_dump($_GET); 
    echo "</pre>";
    echo "<a href='messaggi.php' class='btn btn-dark'>Torna Indietro</a>";
    echo "</div>";
    exit();
}

$dbConnection = DBHandler::getPDO();

$sql = "SELECT nome AS nomeUtente, ruolo AS ruoloUtente, tipoDiploma, punteggioAffidabilita 
        FROM utenti WHERE idUtente = ?";
$stmt = $dbConnection->prepare($sql);
$stmt->execute([$idUtenteVisualizzato]);
$datiUtente = $stmt->fetch(PDO::FETCH_ASSOC);

if (!$datiUtente) {
    echo "<div class='container mt-5 alert alert-danger'>Utente ID $idUtenteVisualizzato non trovato nel DB.</div>";
    exit();
}

$nomeUtente = htmlspecialchars($datiUtente['nomeUtente']);
$ruoloUtente = htmlspecialchars($datiUtente['ruoloUtente']);
$punteggio = (int)$datiUtente['punteggioAffidabilita'];
$tipoDiploma = htmlspecialchars($datiUtente['tipoDiploma'] ?? 'Non specificato');
?>

<div class="container mt-5">
    <div class="card shadow" style="max-width: 600px; margin: 0 auto;">
        <div class="card-header bg-primary text-white text-center">
            <h3 class="mb-0"><?= $nomeUtente ?></h3>
            <span class="badge bg-light text-dark mt-2"><?= ucfirst($ruoloUtente) ?></span>
        </div>
        <div class="card-body text-center">
            
            <div class="mb-4">
                <h5 class="text-muted">Affidabilità</h5>
                <div class="display-4 text-primary fw-bold"><?= $punteggio ?>/100</div>
            </div>

            <ul class="list-group list-group-flush mb-4 text-start">
                <li class="list-group-item"><strong>Diploma:</strong> <?= $tipoDiploma ?></li>
                <li class="list-group-item"><strong>Ruolo:</strong> <?= ucfirst($ruoloUtente) ?></li>
            </ul>

            <div class="d-grid gap-2">
                <a href="chat.php?idDestinatario=<?= $idUtenteVisualizzato ?>" class="btn btn-success btn-lg">
                    💬 Scrivi Messaggio
                </a>
                <a href="messaggi.php" class="btn btn-outline-secondary">
                    Indietro
                </a>
            </div>
        </div>
    </div>
</div>
</body>
</html>