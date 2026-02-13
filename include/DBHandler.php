<?php
class DBHandler {
    
    private static $host = 'pronv6.ftp.tb-hosting.com'; 
    private static $dbName = 'pronv6_zwjejm53'; 
    private static $userName = 'pronv6_dakter';       
    private static $password = 'ciscoX123'; 

    private static $dbHandler = null;

    public static function getPDO(){
        if(self::$dbHandler == null){
            try {
                $dsn = "mysql:host=" . self::$host . ";dbname=" . self::$dbName . ";charset=utf8";
                
                $options = [
                    PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
                    PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
                    PDO::ATTR_EMULATE_PREPARES => false,
                ];

                self::$dbHandler = new PDO($dsn, self::$userName, self::$password, $options);
                
            } catch (PDOException $e) {
                die("errore connessione: " . $e->getMessage()); 
            }
        }
        return self::$dbHandler;
    }
}