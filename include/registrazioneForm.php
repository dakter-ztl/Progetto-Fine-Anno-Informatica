<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Registrazione Next Step</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">
    <div class="container mt-5">
        <div class="row justify-content-center">
            <div class="col-md-6">
                <div class="card shadow">
                    <div class="card-body p-4">
                        <h3 class="text-center">Registrati</h3>
                        <form action="registrazione.php" method="post">
                            <div class="mb-3">
                                <label>Nome Utente</label>
                                <input type="text" name="nome" class="form-control" required>
                            </div>
                            <div class="mb-3">
                                <label>Password</label>
                                <input type="password" name="password" class="form-control" required>
                            </div>
                            <div class="mb-3">
                                <label>Tipo Diploma</label>
                                <select name="tipoDiploma" class="form-control">
                                    <option value="Liceo">Liceo</option>
                                    <option value="Tecnico">Istituto Tecnico</option>
                                    <option value="Professionale">Professionale</option>
                                </select>
                            </div>
                            <div class="mb-3">
                                <label>Ruolo</label>
                                <select name="ruolo" class="form-control">
                                    <option value="studente">Studente</option>
                                    <option value="mentore">Mentore</option>
                                </select>
                            </div>
                            <button type="submit" class="btn btn-success w-100">Registrati</button>
                        </form>
                        <div class="mt-3 text-center">
                            <a href="loginForm.php">Hai già un account? Accedi</a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</body>
</html>