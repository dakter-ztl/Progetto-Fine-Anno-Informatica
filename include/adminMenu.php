<?php
session_start();

 if(isset($_SESSION['ruolo']) && $_SESSION['ruolo'] == 'admin'){
    require_once '../include/menuChoice.php';
    exit;
}

?>

<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <title>Dashboard Admin</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">

<div class="container mt-5">
    
    <div class="text-center mb-5">
        <h1 class="display-4 fw-bold">Pannello di Controllo</h1>
        <p class="lead text-muted">Gestisci i contenuti del simulatore </p>
    </div>

    <div class="row justify-content-center">
        
        <div class="col-md-5 mb-4">
            <div class="card shadow-sm h-100 border-0 hover-effect">
                <div class="card-body text-center p-5">
                    <div class="display-1 mb-3">📚</div>
                    <h2 class="card-title">Inserisci Materie</h2>
                    <p class="card-text text-muted">
                        Aggiungi nuove materie scolastiche al database per migliorare l'algoritmo di matching.
                    </p>
                    <a href="../adminPages/inserisciMateria.php" class="btn btn-primary btn-lg mt-3 w-100">
                        Vai a Gestione Materie
                    </a>
                </div>
            </div>
        </div>
        
        

        <div class="col-md-5 mb-4">
            <div class="card shadow-sm h-100 border-0 hover-effect">
                <div class="card-body text-center p-5">
                    <div class="display-1 mb-3">🚀</div>
                    <h2 class="card-title">Inserisci Percorsi</h2>
                    <p class="card-text text-muted">
                        Crea nuove schede per Università, Lavori o Corsi ITS con i relativi dati economici.
                    </p>
                    <a href="../adminPages/inserisciPercorso.php" class="btn btn-success btn-lg mt-3 w-100">
                        Vai a Gestione Percorsi
                    </a>
                </div>
            </div>
        </div>

    </div>
</div>

<style>
    .hover-effect:hover {
        transform: translateY(-5px);
        transition: transform 0.3s ease;
        box-shadow: 0 1rem 3rem rgba(0,0,0,.175)!important;
    }
</style>

</body>
</html>