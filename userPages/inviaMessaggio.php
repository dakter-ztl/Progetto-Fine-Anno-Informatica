<?php
session_start();
require_once '../include/DBHandler.php';

if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_SESSION['idUtente'])) {
    $idMittente = $_SESSION['idUtente'];
    $idDestinatario = (int)$_POST['idDestinatario'];
    $testo = trim($_POST['testo']);

    if (!empty($testo) && $idDestinatario > 0) {
        $db = DBHandler::getPDO();
        $stmt = $db->prepare("INSERT INTO messaggi_privati (idMittente, idDestinatario, testo) VALUES (?, ?, ?)");
        $stmt->execute([$idMittente, $idDestinatario, $testo]);
    }
    
    header("Location: chat.php?idDestinatario=$idDestinatario");
    exit();
}