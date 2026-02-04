<?php
// 1. Legge il file JSON che abbiamo appena creato
$json = file_get_contents('../include/pages.json');

// 2. Prende il nome del file che l'utente sta visitando (es. home.php)
$pageName = basename($_SERVER['PHP_SELF']);

// 3. Trasforma il JSON in un oggetto PHP utilizzabile
$obj = json_decode($json);

// 4. CONTROLLO LOGIN
// Se la pagina attuale è nella lista "loggedInPages", controlla se sei loggato
if(in_array($pageName, $obj->loggedInPages)){
    require 'header.php'; // Header conterrà il controllo sessione
}

// 5. CONTROLLO DATABASE
// Se la pagina attuale è nella lista "DBPages", connette il database
if(in_array($pageName, $obj->DBPages)){
    require_once 'DBHandler.php';
}

// 6. CARICAMENTO MENU
// Carica sempre il menu di navigazione
include 'userMenu.php';
?>