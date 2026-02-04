<?php
session_start();
require_once('DBHandler.php');

$nome = htmlspecialchars($_POST['nome']);
$pass = password_hash($_POST['password'], PASSWORD_DEFAULT); // Criptiamo la password!
$diploma = htmlspecialchars($_POST['tipoDiploma']);
$ruolo = htmlspecialchars($_POST['ruolo']);

try {
    $sql = "INSERT INTO utenti (nome, password, ruolo, tipoDiploma) VALUES (:nome, :pass, :ruolo, :dip)";
    $sth = DBHandler::getPDO()->prepare($sql);
    $sth->execute([
        ':nome' => $nome,
        ':pass' => $pass,
        ':ruolo' => $ruolo,
        ':dip' => $diploma
    ]);
    
    // Se va bene, vai al login
    header('Location: loginForm.php?success=registrato');
} catch (PDOException $e) {
    echo "Errore registrazione (forse il nome esiste già): " . $e->getMessage();
}
?>