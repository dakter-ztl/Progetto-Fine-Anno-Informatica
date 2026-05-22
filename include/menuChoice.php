<?php
$json = file_get_contents(__DIR__ . '/pages.json');
$pageName = basename($_SERVER['PHP_SELF']);
$obj = json_decode($json);

if(in_array($pageName, $obj->loggedInPages)){
    require 'header.php';
}
if(in_array($pageName, $obj->DBPages)){
    require_once 'DBHandler.php';
}

// Determina se siamo in un contesto admin
$isAdminContext = in_array($pageName, $obj->adminPages);

// Imposta il prefisso del percorso in base al contesto
if($isAdminContext){
    // Siamo in una pagina admin (include/ o adminPages/)
    $GLOBALS['menuPathPrefix'] = '../userPages/';
} else {
    // Siamo in una pagina user normale
    $GLOBALS['menuPathPrefix'] = './';
}

// Includi sempre userMenu.php (che ora userà il prefisso corretto)
include __DIR__ . '/userMenu.php';
?>