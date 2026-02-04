<?php
include '../include/menuChoice.php';

$myId = $_SESSION['userId'];
?>

<div class="container mt-4">
    <h2 class="mb-4">📬 Le tue Conversazioni</h2>

    <div class="list-group">
        <?php
       
        $sql = "SELECT DISTINCT u.idUtente, u.nome, u.ruolo 
                FROM utenti u
                WHERE u.idUtente IN (
                    SELECT idMittente FROM messaggi_privati WHERE idDestinatario = :me
                    UNION
                    SELECT idDestinatario FROM messaggi_privati WHERE idMittente = :me
                )";
        
        $sth = DBHandler::getPDO()->prepare($sql);
        $sth->execute([':me' => $myId]);
        $conversazioni = $sth->fetchAll();

        if(count($conversazioni) > 0) {
            foreach($conversazioni as $chat) {
                
                echo '
                <a href="chat.php?partner=' . $chat['idUtente'] . '" class="list-group-item list-group-item-action d-flex justify-content-between align-items-center">
                    <div>
                        <h5 class="mb-1">' . htmlspecialchars($chat['nome']) . '</h5>
                        <small class="text-muted">Ruolo: ' . $chat['ruolo'] . '</small>
                    </div>
                    <span class="badge bg-primary rounded-pill">Apri Chat ➝</span>
                </a>';
            }
        } else {
            echo '<div class="alert alert-info">Non hai ancora messaggi. Vai in bacheca e scrivi a qualcuno!</div>';
        }
        ?>
    </div>
    
    <div class="mt-4">
        <a href="bacheca.php" class="btn btn-secondary">← Torna alla Bacheca</a>
    </div>
</div>
</body>
</html>