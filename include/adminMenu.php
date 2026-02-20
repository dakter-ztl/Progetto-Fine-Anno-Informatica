<?php
session_start();
if (!isset($_SESSION['ruoloUtente']) || $_SESSION['ruoloUtente'] !== 'admin') {
    header("Location: ../userPages/home.php");
    exit;
}
?>
<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <title>Pannello Admin</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-dark text-white">

<div class="container mt-5 text-center">
    <h1>🔧 Pannello Amministrazione</h1>
    <p class="lead">Gestisci i contenuti del sito Bivio</p>
    
    <div class="row mt-4 justify-content-center">
        <div class="col-md-4">
            <div class="card bg-secondary text-white mb-3">
                <div class="card-body">
                    <h3>📚 Materie</h3>
                    <p>Aggiungi nuove materie scolastiche.</p>
                    <a href="inserisciMateria.php" class="btn btn-light">Gestisci Materie</a>
                </div>
            </div>
        </div>
        <div class="col-md-4">
            <div class="card bg-success text-white mb-3">
                <div class="card-body">
                    <h3>🚀 Percorsi</h3>
                    <p>Inserisci università, lavori o corsi ITS.</p>
                    <a href="inserisciPercorso.php" class="btn btn-light">Gestisci Percorsi</a>
                </div>
            </div>
        </div>
    </div>
    
    <a href="../userPages/home.php" class="btn btn-outline-light mt-4">⬅ Torna al sito</a>
</div>

</body>
</html>