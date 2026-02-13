<?php
session_set_cookie_params(['path' => '/']);
if (session_status() === PHP_SESSION_NONE) {
    session_start();
}

if (!isset($_SESSION['idUtente'])) {
    header("Location: ../include/loginForm.php");
    exit();
}

require_once '../include/DBHandler.php';
include '../include/menuChoice.php';

$idUtenteMio = $_SESSION['idUtente'];
$dbConnection = DBHandler::getPDO();

$idDestinatario = isset($_GET['idDestinatario']) ? (int)$_GET['idDestinatario'] : 0;

if ($idDestinatario === 0) {
    echo "<div class='container mt-5 alert alert-danger'>
            <h4>Errore Chat</h4>
            <p>Destinatario non valido.</p>
            <a href='messaggi.php' class='btn btn-secondary'>Torna indietro</a>
          </div>";
    exit();
}

$sqlUtente = "SELECT nome AS nomeUtente, ruolo AS ruoloUtente FROM utenti WHERE idUtente = ?";
$stmt = $dbConnection->prepare($sqlUtente);
$stmt->execute([$idDestinatario]);
$infoRaw = $stmt->fetch(PDO::FETCH_ASSOC);

if (!$infoRaw) {
    die("<div class='container mt-5 alert alert-danger'>L'utente richiesto non esiste.</div>");
}

$infoDestinatario = array_change_key_case($infoRaw, CASE_LOWER);
$nomeUtenteDestinatario = htmlspecialchars($infoDestinatario['nomeutente']); // chiave minuscola per sicurezza
$ruoloUtenteDestinatario = htmlspecialchars($infoDestinatario['ruoloutente'] ?? 'utente');
?>

<div class="container mt-4">
    <div class="card shadow">
        <div class="card-header bg-primary text-white d-flex justify-content-between align-items-center">
            <div>
                <h4 class="mb-0">💬 <?= $nomeUtenteDestinatario ?></h4>
                <small class="text-white-50"><?= ucfirst($ruoloUtenteDestinatario) ?></small>
            </div>
            <div class="btn-group">
                <a href="visualizzaProfilo.php?idUtente=<?= $idDestinatario ?>" class="btn btn-sm btn-outline-light">Vedi Profilo</a>
                <a href="messaggi.php" class="btn btn-sm btn-light text-primary">Indietro</a>
            </div>
        </div>

        <div class="card-body bg-light" style="height: 450px; overflow-y: auto; display: flex; flex-direction: column;">
            <?php
            $sqlMsg = "SELECT * FROM messaggi_privati 
                       WHERE (idMittente = :me1 AND idDestinatario = :dest1) 
                       OR (idMittente = :dest2 AND idDestinatario = :me2) 
                       ORDER BY dataInvio ASC";
            
            $stmtMsg = $dbConnection->prepare($sqlMsg);
            
            $stmtMsg->execute([
                ':me1'   => $idUtenteMio,
                ':dest1' => $idDestinatario,
                ':dest2' => $idDestinatario,
                ':me2'   => $idUtenteMio
            ]);
            
            $messaggi = $stmtMsg->fetchAll(PDO::FETCH_ASSOC);

            if (count($messaggi) > 0) {
                foreach ($messaggi as $msg) {
                    $msg = array_change_key_case($msg, CASE_LOWER);
                    
                    $isMio = ($msg['idmittente'] == $idUtenteMio);
                    
                    $alignClass = $isMio ? 'align-self-end text-end' : 'align-self-start text-start';
                    $bgClass = $isMio ? 'bg-primary text-white' : 'bg-white text-dark border';
                    $dataOra = isset($msg['datainvio']) ? date('d/m H:i', strtotime($msg['datainvio'])) : '';

                    echo "<div class='d-flex flex-column mb-3 $alignClass' style='max-width: 75%;'>";
                    echo "<div class='p-3 rounded-3 shadow-sm $bgClass'>";
                    echo nl2br(htmlspecialchars($msg['testo']));
                    echo "</div>";
                    echo "<small class='text-muted mt-1' style='font-size: 0.70rem;'>$dataOra</small>";
                    echo "</div>";
                }
            } else {
                echo "<div class='text-center text-muted mt-5'>";
                echo "<h5>Nessun messaggio 🦗</h5>";
                echo "<p>Scrivi il primo messaggio a $nomeUtenteDestinatario!</p>";
                echo "</div>";
            }
            ?>
        </div>

        <div class="card-footer bg-white">
            <form action="inviaMessaggio.php" method="POST" class="d-flex gap-2">
                <input type="hidden" name="idDestinatario" value="<?= $idDestinatario ?>">
                <input type="text" name="testo" class="form-control" placeholder="Scrivi un messaggio..." required autocomplete="off">
                <button type="submit" class="btn btn-primary px-4">Invia ➤</button>
            </form>
        </div>
    </div>
</div>

<script>
    window.onload = function() {
        var chatBox = document.querySelector('.card-body');
        chatBox.scrollTop = chatBox.scrollHeight;
    };
</script>

</body>
</html>