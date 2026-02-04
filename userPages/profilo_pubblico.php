<?php
include '../include/menuChoice.php';

if(!isset($_GET['id'])) {
    echo "Utente non specificato.";
    exit;
}

$userId = $_GET['id'];

// Recupera info utente
$sql = "SELECT nome, ruolo, tipoDiploma, punteggioAffidabilita FROM utenti WHERE idUtente = :id";
$stmt = DBHandler::getPDO()->prepare($sql);
$stmt->execute([':id' => $userId]);
$user = $stmt->fetch();

if(!$user) {
    echo "Utente non trovato.";
    exit;
}

// Colore diverso in base all'affidabilità
$score = $user['punteggioAffidabilita'];
$color = ($score > 50) ? 'text-success' : (($score > 20) ? 'text-warning' : 'text-danger');
?>

<div class="container mt-5">
    <div class="card shadow mx-auto" style="max-width: 600px;">
        <div class="card-body text-center">
            <h1 class="display-4">👤</h1>
            <h2 class="card-title"><?= htmlspecialchars($user['nome']) ?></h2>
            
            <span class="badge bg-dark fs-6 mb-3"><?= strtoupper($user['ruolo']) ?></span>
            
            <hr>
            
            <div class="row text-start mt-4">
                <div class="col-6">
                    <p><strong>🎓 Diploma:</strong><br> <?= htmlspecialchars($user['tipoDiploma']) ?></p>
                </div>
                <div class="col-6">
                    <p><strong>⭐ Affidabilità:</strong><br> 
                    <span class="fs-4 fw-bold <?= $color ?>"><?= $score ?>/100</span></p>
                </div>
            </div>

            <div class="mt-4">
                <?php if($userId != $_SESSION['userId']): ?>
                    <a href="chat.php?partner=<?= $userId ?>" class="btn btn-primary w-100">💬 Invia Messaggio Privato</a>
                <?php endif; ?>
                <a href="bacheca.php" class="btn btn-outline-secondary w-100 mt-2">Torna alla Bacheca</a>
            </div>
        </div>
    </div>
</div>
</body>
</html>