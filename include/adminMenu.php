<?php
session_start();

if(!isset($_SESSION['ruoloUtente']) || $_SESSION['ruoloUtente'] !== 'admin'){
    header("Location: ../userPages/home.php");
    exit();
}
require_once '../include/menuChoice.php';
?>

<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <title>Dashboard Admin</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="../css/style.css" rel="stylesheet">
</head>
<body class="bg-light">

<div class="container mt-5">
    
    <div class="text-center mb-5">
        <h1 class="display-4 fw-bold">Pannello di Controllo</h1>
        <p class="lead text-muted">Gestisci i contenuti del simulatore</p>
    </div>

    <div class="row justify-content-center">
        
        <div class="col-md-4 mb-4">
            <a href="../adminPages/inserisciMateria.php" class="text-decoration-none">
                <div class="card shadow-sm h-100 border-0 hover-effect clickable-card">
                    <div class="card-body text-center p-5">
                        <div class="display-1 mb-3">📚</div>
                        <h2 class="card-title">Inserisci Materie</h2>
                        <p class="card-text text-muted">
                            Aggiungi nuove materie scolastiche al database per migliorare l'algoritmo di matching.
                        </p>
                    </div>
                </div>
            </a>
        </div>
        
        <div class="col-md-4 mb-4">
            <a href="../adminPages/inserisciPercorso.php" class="text-decoration-none">
                <div class="card shadow-sm h-100 border-0 hover-effect clickable-card">
                    <div class="card-body text-center p-5">
                        <div class="display-1 mb-3">🚀</div>
                        <h2 class="card-title">Inserisci Percorsi</h2>
                        <p class="card-text text-muted">
                            Crea nuove schede per Università, Lavori o Corsi ITS con i relativi dati economici.
                        </p>
                    </div>
                </div>
            </a>
        </div>

        <div class="col-md-4 mb-4">
            <a href="../adminPages/gestisciRecensioni.php" class="text-decoration-none">
                <div class="card shadow-sm h-100 border-0 hover-effect clickable-card">
                    <div class="card-body text-center p-5">
                        <div class="display-1 mb-3">⭐</div>
                        <h2 class="card-title">Gestisci Recensioni</h2>
                        <p class="card-text text-muted">
                            Approva o rifiuta le recensioni degli utenti per mantenere la qualità del sistema.
                        </p>
                    </div>
                </div>
            </a>
        </div>
        
    </div> <!-- Chiusura row -->
    
</div> <!-- Chiusura container -->

<style>
    .clickable-card {
        cursor: pointer;
        transition: transform 0.3s ease, box-shadow 0.3s ease;
    }
    
    .hover-effect:hover {
        transform: translateY(-5px);
        box-shadow: 0 1rem 3rem rgba(0,0,0,.175)!important;
    }
    
    .clickable-card .card-title {
        color: #212529;
    }
</style>

</body>
</html>