    <?php
    require_once 'DBHandler.php';

    if (session_status() === PHP_SESSION_NONE) {
        session_start();
    }

    $dbConnection = DBHandler::getPDO();

    if ($_SERVER['REQUEST_METHOD'] === 'POST') {
        $nomeUtente = trim($_POST['nome'] ?? '');
        $passwordInserita = trim($_POST['password'] ?? '');

        if (!empty($nomeUtente) && !empty($passwordInserita)) {
            $stmt = $dbConnection->prepare("SELECT * FROM utenti WHERE nome = ?");
            $stmt->execute([$nomeUtente]);
            $utenteTrovato = $stmt->fetch();

            if ($utenteTrovato && password_verify($passwordInserita, $utenteTrovato['password'])) {
                session_regenerate_id(true);

                $_SESSION['idUtente'] = $utenteTrovato['idUtente'];
                $_SESSION['nomeUtente'] = $utenteTrovato['nome'];
                $_SESSION['ruoloUtente'] = $utenteTrovato['ruolo'];

                //salvataggio della sessione
                session_write_close();

                header("Location: ../userPages/home.php");
                exit();
            } else {
                header("Location: loginForm.php?error=1");
                exit();
            }
        }
    }