<?php
include '../include/menuChoice.php';

if(!isset($_GET['partner'])) {
    header("Location: bacheca.php");
    exit;
}

$partnerId = $_GET['partner'];
$myId = $_SESSION['userId'];

$stmt = DBHandler::getPDO()->prepare("SELECT nome FROM utenti WHERE idUtente = :pid");
$stmt->execute([':pid' => $partnerId]);
$partnerName = $stmt->fetchColumn();

if($_SERVER['REQUEST_METHOD'] == 'POST' && isset($_POST['messaggio'])) {
    $sql = "INSERT INTO messaggi_privati (idMittente, idDestinatario, testo) VALUES (:mitt, :dest, :testo)";
    $stmt = DBHandler::getPDO()->prepare($sql);
    $stmt->execute([
        ':mitt' => $myId,
        ':dest' => $partnerId,
        ':testo' => $_POST['messaggio']
    ]);
    header("Location: chat.php?partner=" . $partnerId);
    exit;
}
?>

<div class="container mt-4">
    <a href="bacheca.php" class="btn btn-outline-secondary mb-3">← Torna alla Bacheca</a>
    
    <div class="card shadow">
        <div class="card-header bg-primary text-white">
            Conversazione privata con <strong><?= htmlspecialchars($partnerName) ?></strong>
        </div>
        
        <div class="card-body" style="height: 400px; overflow-y: auto; background-color: #f8f9fa;">
            <?php
            $sql = "SELECT * FROM messaggi_privati 
                    WHERE (idMittente = :me AND idDestinatario = :lui) 
                       OR (idMittente = :lui AND idDestinatario = :me) 
                    ORDER BY dataInvio ASC";
            
            $stmt = DBHandler::getPDO()->prepare($sql);
            $stmt->execute([':me' => $myId, ':lui' => $partnerId]);
            $messaggi = $stmt->fetchAll();

            foreach($messaggi as $msg):
                $isMio = ($msg['idMittente'] == $myId);
                $align = $isMio ? 'text-end' : 'text-start';
                $bg = $isMio ? 'bg-success text-white' : 'bg-white border';
            ?>
                <div class="mb-2 <?= $align ?>">
                    <div class="d-inline-block p-2 rounded <?= $bg ?>" style="max-width: 70%;">
                        <?= htmlspecialchars($msg['testo']) ?>
                        <div style="font-size: 0.7em; opacity: 0.8; text-align: right;">
                            <?= date('H:i', strtotime($msg['dataInvio'])) ?>
                        </div>
                    </div>
                </div>
            <?php endforeach; ?>
        </div>
        
        <div class="card-footer">
            <form method="POST" action="chat.php?partner=<?= $partnerId ?>" class="d-flex gap-2">
                <input type="text" name="messaggio" class="form-control" placeholder="Scrivi un messaggio privato..." required autofocus>
                <button type="submit" class="btn btn-primary">Invia ✈️</button>
            </form>
        </div>
    </div>
</div>

<script>
    var chatBody = document.querySelector('.card-body');
    chatBody.scrollTop = chatBody.scrollHeight;
</script>

</body>
</html>