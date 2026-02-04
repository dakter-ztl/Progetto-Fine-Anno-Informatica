<?php
include '../include/menuChoice.php';

// Se non è specificato con chi parlare, rimanda alla bacheca
if(!isset($_GET['partner'])) {
    header("Location: bacheca.php");
    exit;
}

$partnerId = $_GET['partner'];
$myId = $_SESSION['userId'];

// Recupero nome del partner per mostrarlo in alto
$stmt = DBHandler::getPDO()->prepare("SELECT nome FROM utenti WHERE idUtente = :pid");
$stmt->execute([':pid' => $partnerId]);
$partnerName = $stmt->fetchColumn();

// --- INVIO MESSAGGIO ---
if($_SERVER['REQUEST_METHOD'] == 'POST' && isset($_POST['messaggio'])) {
    $sql = "INSERT INTO messaggi_privati (idMittente, idDestinatario, testo) VALUES (:mitt, :dest, :testo)";
    $stmt = DBHandler::getPDO()->prepare($sql);
    $stmt->execute([
        ':mitt' => $myId,
        ':dest' => $partnerId,
        ':testo' => $_POST['messaggio']
    ]);
    // Refresh per vedere il messaggio inviato
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
            // Seleziona messaggi scambiati tra ME e LUI (in entrambe le direzioni)
            $sql = "SELECT * FROM messaggi_privati 
                    WHERE (idMittente = :me AND idDestinatario = :lui) 
                       OR (idMittente = :lui AND idDestinatario = :me) 
                    ORDER BY dataInvio ASC";
            
            $stmt = DBHandler::getPDO()->prepare($sql);
            $stmt->execute([':me' => $myId, ':lui' => $partnerId]);
            $messaggi = $stmt->fetchAll();

            foreach($messaggi as $msg):
                $isMio = ($msg['idMittente'] == $myId);
                // Stile diverso se il messaggio è mio (Verde/Destra) o suo (Bianco/Sinistra)
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