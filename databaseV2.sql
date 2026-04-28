CREATE DATABASE IF NOT EXISTS NextStep;
USE NextStep;

CREATE TABLE utenti(
    idUtente INT AUTO_INCREMENT NOT NULL,
    nome VARCHAR(100) NOT NULL,        
    password VARCHAR(255) NOT NULL,   
    ruolo ENUM('studente','mentore','admin') DEFAULT 'studente',
    tipoDiploma VARCHAR(255),
    punteggioAffidabilita INT DEFAULT 0, 
    PRIMARY KEY(idUtente)
);

CREATE TABLE categorie(
    idCategoria INT AUTO_INCREMENT NOT NULL,
    nomeCategoria VARCHAR(50) NOT NULL, 
    PRIMARY KEY(idCategoria)
);

CREATE TABLE percorsi(
    idPercorso INT AUTO_INCREMENT NOT NULL,
    titolo VARCHAR(150),               
    descrizione TEXT,                 
    costoMedioMensile DECIMAL(10,2),   
    difficolta INT CHECK (difficolta BETWEEN 1 AND 5), 
    citta VARCHAR(100),
    idCategoria INT NOT NULL,
    PRIMARY KEY(idPercorso),
    FOREIGN KEY(idCategoria) REFERENCES categorie(idCategoria)
);

CREATE TABLE annunci(
    idAnnuncio INT AUTO_INCREMENT NOT NULL,
    titolo VARCHAR(150),
    testo TEXT,                       
    dataPubblicazione DATETIME DEFAULT CURRENT_TIMESTAMP,
    stato ENUM('aperto', 'chiuso') DEFAULT 'aperto', 
    inEvidenza BOOLEAN DEFAULT FALSE,
    idUtente INT NOT NULL,             
    PRIMARY KEY(idAnnuncio),
    FOREIGN KEY(idUtente) REFERENCES utenti(idUtente) ON DELETE CASCADE
);

CREATE TABLE risposte(
    idRisposta INT AUTO_INCREMENT NOT NULL,
    testo TEXT,
    dataRisposta DATETIME DEFAULT CURRENT_TIMESTAMP,
    utile BOOLEAN DEFAULT FALSE,
    idAnnuncio INT NOT NULL,
    idUtente INT NOT NULL,
    PRIMARY KEY(idRisposta),
    FOREIGN KEY(idAnnuncio) REFERENCES annunci(idAnnuncio) ON DELETE CASCADE,
    FOREIGN KEY(idUtente) REFERENCES utenti(idUtente) ON DELETE CASCADE
);

CREATE TABLE preferiti(
    idUtente INT NOT NULL,
    idPercorso INT NOT NULL,
    dataSalvataggio DATETIME DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY(idUtente, idPercorso),
    FOREIGN KEY(idUtente) REFERENCES utenti(idUtente) ON DELETE CASCADE,
    FOREIGN KEY(idPercorso) REFERENCES percorsi(idPercorso) ON DELETE CASCADE
);
CREATE TABLE messaggi_privati (
    idMessaggio INT AUTO_INCREMENT PRIMARY KEY,
    idMittente INT NOT NULL,
    idDestinatario INT NOT NULL,
    testo TEXT NOT NULL,
    dataInvio DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (idMittente) REFERENCES utenti(idUtente) ON DELETE CASCADE,
    FOREIGN KEY (idDestinatario) REFERENCES utenti(idUtente) ON DELETE CASCADE
);

CREATE TABLE notifiche (
    idNotifica INT AUTO_INCREMENT PRIMARY KEY,
    idUtente INT NOT NULL, 
    testo TEXT NOT NULL,
    dataNotifica DATETIME DEFAULT CURRENT_TIMESTAMP,
    letta BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (idUtente) REFERENCES utenti(idUtente) ON DELETE CASCADE
);


UPDATE utenti SET ruolo = 'admin' WHERE idUtente = 1;