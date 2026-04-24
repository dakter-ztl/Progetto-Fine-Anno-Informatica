<?php
require_once __DIR__ . '/../config.php';

class DBHandler {
    private static $dbHandler = null;

    public static function getPDO() {
        if (self::$dbHandler == null) {
            try {
                $dsn = "mysql:host=" . DB_HOST . ";dbname=" . DB_NAME . ";charset=utf8";
                $options = [
                    PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
                    PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
                    PDO::ATTR_EMULATE_PREPARES => false,
                ];
                self::$dbHandler = new PDO($dsn, DB_USER, DB_PASS, $options);
            } catch (PDOException $e) {
                die("Errore connessione DB"); 
            }
        }
        return self::$dbHandler;
    }
}