<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <title>Next Step</title>
</head>
<body>

<nav class="navbar navbar-expand-sm navbar-dark bg-dark mb-4">
  <div class="container-fluid">
    <a class="navbar-brand" href="home.php">Next Step 🚀</a>
    <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#mynavbar">
      <span class="navbar-toggler-icon"></span>
    </button>
    <div class="collapse navbar-collapse" id="mynavbar">
      <ul class="navbar-nav me-auto">
        <li class="nav-item">
          <a class="nav-link" href="home.php">Simulatore</a>
        </li>
        <li class="nav-item">
          <a class="nav-link" href="bacheca.php">Bacheca</a>
        </li>

        <?php 
        
        
        if(isset($_SESSION['idUtente'])): ?>
            <li class="nav-item">
              <a class="nav-link text-warning fw-bold" href="profilo.php">Il mio profilo</a>
            </li>
            
            <?php if(isset($_SESSION['ruoloUtente']) && $_SESSION['ruoloUtente'] == 'admin'): ?>

                <li class="nav-item">
                    <a class="nav-link" href="../include/adminMenu.php">Modalità ADMIN</a>
                </li>
            <?php endif; ?>
        <?php endif; ?>

      </ul>
      <ul class="navbar-nav ms-auto">
        <li class="nav-item">
            <?php if(isset($_SESSION['idUtente'])): ?>
                <span class="navbar-text me-3 text-white">Ciao, <?= htmlspecialchars($_SESSION['nomeUtente']); ?></span>
                <a class="btn btn-warning btn-sm" href="../include/logout.php">Logout</a>
            <?php else: ?>
                <a class="btn btn-outline-light btn-sm" href="../include/loginForm.php">Accedi</a>
            <?php endif; ?>
        </li>
      </ul>
    </div>
  </div>
</nav>