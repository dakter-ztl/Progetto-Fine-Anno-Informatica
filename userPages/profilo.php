<?php
include '../include/menuChoice.php';

$myId = $_SESSION['idUtente'];

if(isset($_POST['delete_notifica'])) {
    $stmt = DBHandler::getPDO()->prepare("DELETE FROM notifiche WHERE idNotifica = :id AND idUtente = :me");
    $stmt->execute([':id' => $_POST['delete_notifica'], ':me' => $myId]);
    header("Location: profilo.php");
    exit;
}
?>

<div class="container mt-4">
    <div class="row">
        <div class="col-md-4">
            <div class="card shadow mb-4">
                <div class="card-body text-center">
                    <div class="display-1 mb-2">👤</div>
                    <h3 class="card-title"><?= htmlspecialchars($_SESSION['nomeUtente']) ?></h3>
                    <span class="badge bg-primary mb-4 p-2"><?= strtoupper($_SESSION['ruoloUtente']) ?></span>
                    
                    <div class="d-grid gap-2">
                        <a href="messaggi.php" class="btn btn-info text-white">📩 Vai ai Messaggi Privati</a>
                        <a href="../include/logout.php" class="btn btn-outline-danger">Esci (Logout)</a>
                    </div>
                </div>
            </div>
        </div>

        <div class="col-md-8">
            
            <div class="card shadow-sm mb-4">
                <div class="card-header bg-warning text-dark d-flex justify-content-between align-items-center">
                    <span class="fw-bold">🔔 Le tue Notifiche</span>
                </div>
                <ul class="list-group list-group-flush">
                    <?php
                    $sql = "SELECT * FROM notifiche WHERE idUtente = :me ORDER BY dataNotifica DESC LIMIT 10";
                    $stmt = DBHandler::getPDO()->prepare($sql);
                    $stmt->execute([':me' => $myId]);
                    $notifiche = $stmt->fetchAll();

                    if(count($notifiche) > 0) {
                        foreach($notifiche as $notifica) {
                            echo '<li class="list-group-item d-flex justify-content-between align-items-center">';
                            echo '<span>' . htmlspecialchars($notifica['testo']) . ' <small class="text-muted ms-2">(' . $notifica['dataNotifica'] . ')</small></span>';
                            
                            // Form per cancellare la notifica
                            echo '<form method="POST" class="m-0">';
                            echo '<button name="delete_notifica" value="'.$notifica['idNotifica'].'" class="btn btn-sm btn-close" aria-label="Cancella"></button>';
                            echo '</form>';
                            
                            echo '</li>';
                        }
                    } else {
                        echo '<li class="list-group-item text-muted text-center py-3">Nessuna nuova notifica.</li>';
                    }
                    ?>
                </ul>
            </div>

            <div class="card shadow-sm">
                <div class="card-header bg-secondary text-white">
                    📝 I tuoi post recenti
                </div>
                <div class="card-body">
                    <?php
                    $sql = "SELECT * FROM annunci WHERE idUtente = :me ORDER BY dataPubblicazione DESC LIMIT 5";
                    $stmt = DBHandler::getPDO()->prepare($sql);
                    $stmt->execute([':me' => $myId]);
                    $mieiPost = $stmt->fetchAll();

                    if(count($mieiPost) > 0){
                        foreach($mieiPost as $post){
                            echo '<div class="alert alert-light border mb-2">';
                            echo '<strong>'.htmlspecialchars($post['titolo']).'</strong>';
                            echo '<br><small class="text-muted">'.substr($post['testo'], 0, 60).'...</small>';
                            echo '</div>';
                        }
                    } else {
                        echo "<p class='text-muted'>Non hai ancora scritto nulla in bacheca.</p>";
                    }
                    ?>
                </div>
            </div>

        </div>
    </div>
</div>
</body>
</html>