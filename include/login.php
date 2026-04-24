<?php


if (session_status() === PHP_SESSION_NONE) {
    session_start(); 
}

require_once 'DBHandler.php'; 

// Inizializza contatori se non esistono
if (!isset($_SESSION['login_tentativi'])) {
    $_SESSION['login_tentativi'] = 0;
    $_SESSION['login_ultimo_tentativo'] = time();
}

// Se sono passati 2 minuti, resetta il contatore
if (time() - $_SESSION['login_ultimo_tentativo'] > 120) {
    $_SESSION['login_tentativi'] = 0;
    $_SESSION['login_ultimo_tentativo'] = time();
}

// Blocca dopo 3 tentativi falliti
if ($_SESSION['login_tentativi'] >= 3) {
    $minutiRimasti = ceil((180 - (time() - $_SESSION['login_ultimo_tentativo'])) / 60);
    header("Location: ../include/loginForm.php?error=bloccato&minuti=$minutiRimasti");
    exit();
}

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