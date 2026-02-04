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

include 'userMenu.php';
?>