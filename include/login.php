-- Active: 1768501873902@@127.0.0.1@3306@NextStep
<?php
session_start();
require_once('DBHandler.php'); // Carica la connessione al DB

// 1. Prende i dati dal form
$nome = htmlspecialchars($_POST['nome']);
$passwordInserita = htmlspecialchars($_POST['password']);

// 2. Prepara la query SQL
// Cerca un utente che ha quel nome esatto
$sql = "SELECT idUtente, nome, password, ruolo FROM utenti WHERE nome = :nome";
$sth = DBHandler::getPDO()->prepare($sql);
$sth->bindParam('nome', $nome, PDO::PARAM_STR);
$sth->execute();

// 3. Controlla il risultato
if($sth->rowCount() > 0){
    // Utente trovato, prendiamo i dati
    $riga = $sth->fetch();
    $passwordNelDB = $riga['password']; // Questa è la password criptata (Hash)

    // 4. Verifica se la password inserita corrisponde all'Hash nel DB
    if(password_verify($passwordInserita, $passwordNelDB)){
        // LOGIN RIUSCITO!
        $_SESSION['userId'] = $riga['idUtente'];
        $_SESSION['nome'] = $riga['nome'];
        $_SESSION['ruolo'] = $riga['ruolo'];
        
        // Manda l'utente alla bacheca
        header('Location:../userpages/bacheca.php');
    }
    else {
        // Password sbagliata -> Torna al form con errore
        header('Location:loginForm.php?error=1');
    }
} else {
    // Utente non trovato -> Torna al form con errore
    header('Location:loginForm.php?error=1');
}
?>