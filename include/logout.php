<?php
    session_start();
    $_SESSION = array(); // Svuota le variabili di sessione
    session_destroy();   // Distrugge la sessione
    header('Location: ../userpages/home.php'); // Torna alla home
    exit();
?>