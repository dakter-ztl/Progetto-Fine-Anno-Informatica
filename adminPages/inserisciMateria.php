<?php
session_start();
require_once '../include/DBHandler.php';
include '../include/menuChoice.php';

if (!isset($_SESSION['ruoloUtente']) || strtolower($_SESSION['ruoloUtente']) !== 'admin') {
    header("Location: ../userPages/home.php");
    exit;
}

$messaggioEsito = "";

if ($_SERVER['REQUEST_METHOD'] === 'POST' && !empty($_POST['nomeMateria'])) {
    try {
        $stmt = DBHandler::getPDO()->prepare("INSERT INTO materie (nomeMateria) VALUES (:nome)");
        $stmt->execute([':nome' => trim($_POST['nomeMateria'])]);
        $messaggioEsito = "Materia inserita con successo";
    } catch (PDOException $e) {
        $messaggioEsito = "errore " . $e->getMessage();
    }
}


?>
<div class="container mt-5">
    <div class="card shadow">
        <div class="card-header bg-primary text-white">
            <h3>Inserisci una nuova materia</h3>
        </div>
        <div class="card-body">
            <?php if ($messaggioEsito): ?>
                <div class="alert alert-info"><?= htmlspecialchars($messaggioEsito) ?></div>
            <?php endif; ?>
            <form method="POST">
                <div class="mb-3">
                    <label class="form-label">Nome materia : </label>
                    <input type="text" name="nomeMateria" class="form-control" required>
                </div>
                <button type="submit" class="btn btn-success">Salva : </button>
            <a href="../userPages/home.php" class="btn btn-secondary w-100 mt-2">Torna alla Dashboard </a>

            </form>
        </div>
    </div>
</div>