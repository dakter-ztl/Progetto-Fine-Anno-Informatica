<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Login Next Step</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="../css/style.css" rel="stylesheet">
    </head>
    <body class="bg-light">
        
        <div class="container mt-5">
            <div class="row justify-content-center">
                <div class="col-md-4">
                    <div class="card shadow">
                        <div class="card-body p-4">
                            <h3 class="text-center mb-4">Accedi</h3>
                            
                            <?php if(isset($_GET['error'])): ?>
                                <div class="alert alert-danger">Nome o Password errati!</div>
                            <?php endif; ?>
                            
                            <?php if(isset($_GET['success'])): ?>
                                <div class="alert alert-success">Registrazione avvenuta! Ora puoi accedere.</div>
                            <?php endif; ?>

                            <form action="login.php" method="post">
                                <div class="mb-3">
                                    <label for="nome" class="form-label">Nome Utente</label>
                                    <input type="text" name="nome" id="nome" class="form-control" required>
                                </div>
                                <div class="mb-3">
                                    <label for="password" class="form-label">Password</label>
                                    <input type="password" name="password" id="password" class="form-control" required>
                                </div>
                                <div class="d-grid">
                                    <input type="submit" value="Entra" class="btn btn-primary">
                                </div>
                            </form>

                            <hr class="my-4">
                            <div class="text-center">
                                <p class="mb-2">Non ti sei ancora registrato?</p>
                                <a href="registrazioneForm.php" class="btn btn-outline-success w-100">Registrati qui</a>
                            </div>
                            <div class="mt-3 text-center">
                                <a href="../userPages/home.php" class="text-decoration-none text-muted small">Torna alla Home</a>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

    </body>
</html>