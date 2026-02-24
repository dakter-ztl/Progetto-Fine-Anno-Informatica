<?php


if (session_status() === PHP_SESSION_NONE) {
    session_start(); // SESSIONE: Deve partire prima di tutto
}

require_once 'DBHandler.php'; // INCLUSIONE: Carica il DB dopo aver avviato il buffer

try {
    $dbConnection = DBHandler::getPDO();

    if ($_SERVER['REQUEST_METHOD'] === 'POST') {
        $nomeUtente = trim($_POST['nome'] ?? '');
        $passwordInserita = trim($_POST['password'] ?? '');

        if (!empty($nomeUtente) && !empty($passwordInserita)) {
            // Query preparata per evitare SQL Injection
            $stmt = $dbConnection->prepare("SELECT * FROM utenti WHERE nome = ?");
            $stmt->execute([$nomeUtente]);
            $utenteTrovato = $stmt->fetch(PDO::FETCH_ASSOC);

            // Verifica password e utente
            if ($utenteTrovato && password_verify($passwordInserita, $utenteTrovato['password'])) {
                
                // Rigenera ID sessione per sicurezza
                session_regenerate_id(true);

                // Salva i dati in sessione
                $_SESSION['idUtente'] = $utenteTrovato['idUtente'];
                $_SESSION['nomeUtente'] = $utenteTrovato['nome'];
                $_SESSION['ruoloUtente'] = $utenteTrovato['ruolo']; // Assicurati che nel DB la colonna si chiami 'ruoloUtente' o 'ruolo'

                // Chiudi la sessione per permettere il redirect immediato
                session_write_close();

                // Redirect
                header("Location: ../userPages/home.php");
                exit();
            } else {
                // Password errata o utente non trovato
                header("Location: ../userPages/loginForm.php?error=1");
                exit();
            }
        } else {
            // Campi vuoti
            header("Location: ../userPages/loginForm.php?error=empty");
            exit();
        }
    }
} catch (Exception $e) {
    // Gestione errori DB per non mostrare scritte a schermo che rompono il login
    error_log("Errore Login: " . $e->getMessage());
    header("Location: ../userPages/loginForm.php?error=system");
    exit();
}