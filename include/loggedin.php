<?php
// Se non esiste l'ID utente nella sessione...
if(!isset($_SESSION['userId'])){
    // ...Reindirizza al modulo di login
    header('Location: ../include/loginForm.php');
    exit; // Blocca l'esecuzione del resto della pagina
}
?>