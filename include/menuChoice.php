<?php
$json = file_get_contents('../include/pages.json');
$pageName = basename($_SERVER['PHP_SELF']);
$obj = json_decode($json);

if(in_array($pageName, $obj->loggedInPages)){
    require 'header.php';
}
if(in_array($pageName, $obj->DBPages)){
    require_once 'DBHandler.php';
}

// Determina se siamo in un contesto admin
$isAdminContext = in_array($pageName, $obj->adminpages);

if($isAdminContext){
    // Siamo in una pagina admin, quindi i link verso userPages devono risalire
    $GLOBALS['menuPathPrefix'] = '../userPages/';
    require 'adminMenu.php';
} else {
    // Siamo in una pagina user normale, quindi i link sono relativi alla stessa directory
    $GLOBALS['menuPathPrefix'] = './';
    include 'userMenu.php';
}
?>