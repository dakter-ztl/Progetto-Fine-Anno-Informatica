
<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <title>Admin - Inserisci Percorso</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">
<?php
require_once '../include/DBHandler.php';
include '../include/menuChoice.php';

$messaggioEsito = "";

if ($_SERVER['REQUEST_METHOD'] === 'POST' && !empty($_POST['nomeMateria'])) {
    try {
        $stmt = DBHandler::getPDO()->prepare("INSERT INTO percorsi (titolo, descrizione, costoMedioMensile, difficolta, citta, idCategoria) 
                VALUES (:titolo, :descrizione, :costoMedioMensile, :difficolta, :citta, :idCategoria)");
        $stmt->execute([
            ':titolo' => $_POST['titolo'],
            ':desc' => $_POST['descrizione'],
            ':costoMedioMensile' => $_POST['costoMedioMensile'],
            ':difficolta' => $_POST['difficolta'],
            ':citta' => $_POST['citta'],
            ':idCategoria' => $_POST['idCategoria']
        ]);
        $messaggioEsito = "Percorso inserito con successo";
    } catch (PDOException $e) {
        $messaggioEsito = "errore " . $e->getMessage();
    }
}

?>

<div class="container mt-5 mb-5">
    <div class="card shadow">
        <div class="card-header bg-success text-white">
            <h3>🚀 Aggiungi Un Nuovo Percorso</h3>
        </div>
        <div class="card-body">
            
            <?php if ($messaggioEsito): ?>
                <div class="alert alert-info"><?= htmlspecialchars($messaggioEsito) ?></div>
            <?php endif; ?>

            <form method="POST">
                <div class="row">
                    <div class="col-md-6 mb-3">
                        <label class="form-label">Titolo Percorso</label>
                        <input type="text" name="titolo" class="form-control" required placeholder="Es. Laurea in Economia">
                    </div>
                    <div class="col-md-6 mb-3">
                        <label class="form-label">Tipo</label>
                        <select name="tipo" class="form-select">
                            <option value="universita">Università</option>
                            <option value="lavoro">Lavoro</option>
                            <option value="its">ITS / Corso</option>
                        </select>
                    </div>
                </div>

                <div class="mb-3">
                    <label class="form-label">Descrizione</label>
                    <textarea name="descrizione" class="form-control" rows="3" required></textarea>
                </div>

                <div class="row">
                    <div class="col-md-4 mb-3">
                        <label class="form-label">Città</label>
                        <input type="text" name="citta" class="form-control" required>
                    </div>
                    <div class="col-md-4 mb-3">
                        <label class="form-label">Budget Mensile Richiesto (€)</label>
                        <input type="number" name="budget" class="form-control" required>
                    </div>
                    <div class="col-md-4 mb-3">
                        <label class="form-label">Stipendio Previsto (€)</label>
                        <input type="number" name="stipendio" class="form-control" required>
                    </div>
                </div>

                <div class="mb-3">
                    <label class="form-label">Livello Difficoltà (1-5)</label>
                    <input type="range" name="difficolta" class="form-range" min="1" max="5" value="3" oninput="this.nextElementSibling.value = this.value">
                    <output>3</output>
                </div>

                <button type="submit" class="btn btn-primary w-100">Salva Percorso</button>
                <a href="../userPages/home.php" class="btn btn-secondary w-100 mt-2">Torna alla Dashboard </a>
            </form>

        </div>
    </div>
</div>

</body>
</html>