    <?php
    if(!isset($_SESSION['idUtente'])){
        header('Location: ../include/loginForm.php');
        exit; 
    }
    ?>