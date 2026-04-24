<?php
session_start();
require_once('DBHandler.php');

// Validazione campi obbligatori
if (empty($_POST['nome']) || empty($_POST['password']) || empty($_POST['tipoDiploma']) || empty($_POST['ruolo'])) {
    header('Location: registrazioneForm.php?error=campi_vuoti');
    exit;
}

// Whitelist ruoli ammessi — 'admin' non può mai arrivare dall'esterno
$ruoliAmmessi = ['studente', 'mentore'];
if (!in_array($_POST['ruolo'], $ruoliAmmessi)) {
    header('Location: registrazioneForm.php?error=ruolo_invalido');
    exit;
}

$nome = htmlspecialchars($_POST['nome']);
$pass = password_hash($_POST['password'], PASSWORD_DEFAULT); 
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
    header('Location: loginForm.php?success=registrato');
} catch (PDOException $e) {
    echo "Errore registrazione (forse il nome esiste già): " . $e->getMessage();
}
?>