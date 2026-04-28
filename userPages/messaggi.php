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
?>
<link href="../css/style.css" rel="stylesheet">

<div class="container mt-4">
    <h2 class="mb-4">Le tue Conversazioni</h2>

    <div class="list-group">
        <?php
        $sql = "SELECT DISTINCT u.idUtente, u.nome, u.ruolo 
                FROM utenti u
                WHERE u.idUtente IN (
                    SELECT idMittente FROM messaggi WHERE idDestinatario = :me1
                    UNION
                    SELECT idDestinatario FROM messaggi WHERE idMittente = :me2
                )";
        
        try {
            $db = DBHandler::getPDO();
            $sth = $db->prepare($sql);
            $sth->execute([':me1' => $idUtenteMio, ':me2' => $idUtenteMio]);
            $conversazioni = $sth->fetchAll(PDO::FETCH_ASSOC);

            if (count($conversazioni) > 0) {
                foreach ($conversazioni as $chat) {
                
                    $chat = array_change_key_case($chat, CASE_LOWER);

                  
                    $idPartner = 0;
                    if (!empty($chat['idutente'])) $idPartner = $chat['idutente'];
                    elseif (!empty($chat['id']))   $idPartner = $chat['id'];

                    if ($idPartner <= 0) {
                        echo '<div class="alert alert-danger">Errore riga: ID non trovato</div>';
                        continue; 
                    }

                    $nomeUtente = htmlspecialchars($chat['nome']); 
                    $ruoloUtente = htmlspecialchars($chat['ruolo']);

                    echo '
                    <a href="visualizzaProfilo.php?idUtente=' . $idPartner . '" class="list-group-item list-group-item-action d-flex justify-content-between align-items-center shadow-sm mb-2 rounded">
                        <div>
                            <h5 class="mb-1">' . $nomeUtente . '</h5>
                            <small class="text-muted">Ruolo: ' . ucfirst($ruoloUtente) . '</small>
                        </div>
                        <span class="btn btn-info btn-sm text-white">Vedi Profilo ➝</span>
                    </a>';
                }
            } else {
                echo '<div class="alert alert-info text-center">
                        <h5>Nessun messaggio trovato</h5>
                        <p>Non hai ancora conversazioni attive.</p>
                      </div>';
            }
        } catch (PDOException $e) {
            echo '<div class="alert alert-danger">Errore SQL: ' . htmlspecialchars($e->getMessage()) . '</div>';
        }
        ?>
    </div>
    
    <div class="mt-4 text-center">
        <a href="bacheca.php" class="btn btn-outline-secondary">← Torna alla Bacheca</a>
    </div>
</div>
</body>
</html>