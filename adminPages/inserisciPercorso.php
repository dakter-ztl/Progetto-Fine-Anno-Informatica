<?php
session_start();
require_once '../include/DBHandler.php';
include '../include/menuChoice.php';

$materie = DBHandler::getPDO()->query("SELECT idMateria, nomeMateria FROM materie ORDER BY nomeMateria")->fetchAll(PDO::FETCH_ASSOC);

$messaggioEsito = "";
if ($_SERVER['REQUEST_METHOD'] === 'POST' && !empty($_POST['titolo'])) {
    try {
        $pdo = DBHandler::getPDO();
        $pdo->beginTransaction();

        $stmt = $pdo->prepare("INSERT INTO percorsi (titolo, descrizione, costoMedioMensile, difficolta, citta, idCategoria) 
                VALUES (:titolo, :descrizione, :costoMedioMensile, :difficolta, :citta, :idCategoria)");
        $stmt->execute([
            ':titolo' => $_POST['titolo'],
            ':descrizione' => $_POST['descrizione'],
            ':costoMedioMensile' => $_POST['costoMedioMensile'],
            ':difficolta' => $_POST['difficolta'],
            ':citta' => $_POST['citta'],
            ':idCategoria' => $_POST['idCategoria']
        ]);

        $idPercorso = $pdo->lastInsertId();

        if (!empty($_POST['materie'])) {
            $stmtMateria = $pdo->prepare("INSERT INTO percorsiMaterie (idPercorso, idMateria) VALUES (:idPercorso, :idMateria)");
            foreach ($_POST['materie'] as $idMateria) {
                $stmtMateria->execute([
                    ':idPercorso' => $idPercorso,
                    ':idMateria' => (int)$idMateria
                ]);
            }
        }

        $pdo->commit();
        $messaggioEsito = "Percorso inserito con successo!";

    } catch (PDOException $e) {
        $pdo->rollBack();
        $messaggioEsito = "Errore: " . $e->getMessage();
    }
}
?>
<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <title>Admin - Inserisci Percorso</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        .materie-box {
            max-height: 300px;
            overflow-y: auto;
            border: 1px solid #dee2e6;
            border-radius: 8px;
            padding: 10px;
        }
        .materia-item:hover {
            background-color: #f0f0f0;
            border-radius: 4px;
        }
    </style>
</head>
<body class="bg-light">
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
                        <label class="form-label fw-bold">Titolo del Percorso</label>
                        <input type="text" name="titolo" class="form-control" required placeholder="Es. Laurea in Economia">
                    </div>
                    <div class="col-md-6 mb-3">
                        <label class="form-label fw-bold">Categoria</label>
                        <select name="idCategoria" class="form-select" required>
                            <option value="">Seleziona...</option>
                            <option value="1">ITS</option>
                            <option value="2">Università</option>
                            <option value="3">Lavoro</option>
                        </select>
                    </div>
                </div>

                <div class="mb-3">
                    <label class="form-label fw-bold">Descrizione del Percorso</label>
                    <textarea name="descrizione" class="form-control" rows="3" required></textarea>
                </div>

                <div class="row">
                    <div class="col-md-4 mb-3">
                        <label class="form-label fw-bold">Costo mensile (€)</label>
                        <input type="number" name="costoMedioMensile" class="form-control" required>
                    </div>
                    <div class="col-md-4 mb-3">
                        <label class="form-label fw-bold">Città</label>
                        <input type="text" name="citta" class="form-control" required>
                    </div>
                    <div class="col-md-4 mb-3">
                        <label class="form-label fw-bold">Difficoltà (1-5)</label>
                        <input type="range" name="difficolta" class="form-range" min="1" max="5" value="3"
                               oninput="this.nextElementSibling.value = this.value">
                        <output>3</output>
                    </div>
                </div>

                <div class="mb-4">
                    <label class="form-label fw-bold">Materie collegate</label>
                    <small class="text-muted d-block mb-2">Seleziona una o più materie relative a questo percorso</small>
                    <div class="materie-box">
                        <?php foreach ($materie as $materia): ?>
                            <div class="form-check materia-item p-1">
                                <input class="form-check-input" type="checkbox"
                                       name="materie[]"
                                       value="<?= $materia['idMateria'] ?>"
                                       id="materia_<?= $materia['idMateria'] ?>">
                                <label class="form-check-label" for="materia_<?= $materia['idMateria'] ?>">
                                    <?= htmlspecialchars($materia['nomeMateria']) ?>
                                </label>
                            </div>
                        <?php endforeach; ?>
                    </div>
                </div>

                <button type="submit" class="btn btn-primary w-100">Salva Percorso</button>
                <a href="../userPages/home.php" class="btn btn-secondary w-100 mt-2">Torna alla Dashboard</a>
            </form>
        </div>
    </div>
</div>
</body>
</html>