<?php


if (session_status() === PHP_SESSION_NONE) {
    session_start(); 
}

require_once 'DBHandler.php'; 

try {
    $dbConnection = DBHandler::getPDO();

    if ($_SERVER['REQUEST_METHOD'] === 'POST') {
        $nomeUtente = trim($_POST['nome'] ?? '');
        $passwordInserita = trim($_POST['password'] ?? '');

        if (!empty($nomeUtente) && !empty($passwordInserita)) {
            
            $stmt = $dbConnection->prepare("SELECT * FROM utenti WHERE nome = ?");
            $stmt->execute([$nomeUtente]);
            $utenteTrovato = $stmt->fetch(PDO::FETCH_ASSOC);

            if ($utenteTrovato && password_verify($passwordInserita, $utenteTrovato['password'])) {
                
                session_regenerate_id(true);

        
                $_SESSION['idUtente'] = $utenteTrovato['idUtente'];
                $_SESSION['nomeUtente'] = $utenteTrovato['nome'];
                $_SESSION['ruoloUtente'] = $utenteTrovato['ruolo']; 

            
                session_write_close();

        
                header("Location: ../userPages/home.php");
                exit();
            } else {
                header("Location: ../include/loginForm.php?error=1");
                exit();
            }
        } else {
            header("Location: ../include/loginForm.php?error=empty");
            exit();
        }
    }
} catch (Exception $e) {
    error_log("Errore Login: " . $e->getMessage());
    header("Location: ../include/loginForm.php?error=system");
    exit();
}