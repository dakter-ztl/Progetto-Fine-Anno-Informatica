
CREATE DATABASE IF NOT EXISTS NextStep;
USE NextStep;

CREATE TABLE utenti (
    idUtente              INT          AUTO_INCREMENT NOT NULL,
    nome                  VARCHAR(100) NOT NULL UNIQUE,
    password              VARCHAR(255) NOT NULL,
    ruolo                 ENUM('studente','admin') DEFAULT 'studente',
    tipoDiploma           ENUM('Liceo','Istituto Tecnico','Professionale'),
    punteggioAffidabilita INT DEFAULT 0,
    PRIMARY KEY (idUtente)
);

CREATE TABLE categorie (
    idCategoria   INT         AUTO_INCREMENT NOT NULL,
    nomeCategoria VARCHAR(50) NOT NULL UNIQUE,
    PRIMARY KEY (idCategoria)
);

CREATE TABLE materie (
    idMateria   INT          AUTO_INCREMENT NOT NULL,
    nomeMateria VARCHAR(100) NOT NULL UNIQUE,
    PRIMARY KEY (idMateria)
);

CREATE TABLE percorsi (
    idPercorso        INT           AUTO_INCREMENT NOT NULL,
    titolo            VARCHAR(150)  NOT NULL,
    descrizione       TEXT          NOT NULL,
    costoMedioMensile DECIMAL(10,2) NOT NULL,
    difficolta        INT           NOT NULL CHECK (difficolta BETWEEN 1 AND 5),
    citta             VARCHAR(100)  NOT NULL,
    idCategoria       INT           NOT NULL,
    PRIMARY KEY (idPercorso),
    FOREIGN KEY (idCategoria) REFERENCES categorie(idCategoria)
);

CREATE TABLE percorsi_materie (
    idPercorso INT NOT NULL,
    idMateria  INT NOT NULL,
    PRIMARY KEY (idPercorso, idMateria),
    FOREIGN KEY (idPercorso) REFERENCES percorsi(idPercorso) ON DELETE CASCADE,
    FOREIGN KEY (idMateria)  REFERENCES materie(idMateria)   ON DELETE CASCADE
);

CREATE TABLE annunci (
    idAnnuncio        INT          AUTO_INCREMENT NOT NULL,
    titolo            VARCHAR(150) NOT NULL,
    testo             TEXT         NOT NULL,
    dataPubblicazione DATETIME     DEFAULT CURRENT_TIMESTAMP,
    stato             ENUM('aperto','chiuso') DEFAULT 'aperto',
    inEvidenza        BOOLEAN      DEFAULT FALSE,
    idUtente          INT          NOT NULL,
    PRIMARY KEY (idAnnuncio),
    FOREIGN KEY (idUtente) REFERENCES utenti(idUtente) ON DELETE CASCADE
);

CREATE TABLE risposte (
    idRisposta   INT      AUTO_INCREMENT NOT NULL,
    testo        TEXT     NOT NULL,
    dataRisposta DATETIME DEFAULT CURRENT_TIMESTAMP,
    utile        BOOLEAN  DEFAULT FALSE,
    idAnnuncio   INT      NOT NULL,
    idUtente     INT      NOT NULL,
    PRIMARY KEY (idRisposta),
    FOREIGN KEY (idAnnuncio) REFERENCES annunci(idAnnuncio) ON DELETE CASCADE,
    FOREIGN KEY (idUtente)   REFERENCES utenti(idUtente)    ON DELETE CASCADE
);

CREATE TABLE recensioni (
    idRecensione      INT      AUTO_INCREMENT NOT NULL,
    idUtenteScirttore INT      NOT NULL,
    idUtenteRicevente INT      NOT NULL,
    idRisposta        INT      NOT NULL,
    voto              INT      NOT NULL CHECK (voto BETWEEN 1 AND 10),
    commento          TEXT,
    dataRecensione    DATETIME DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (idRecensione),
    UNIQUE KEY unica_valutazione (idUtenteScirttore, idRisposta),
    FOREIGN KEY (idUtenteScirttore) REFERENCES utenti(idUtente)     ON DELETE CASCADE,
    FOREIGN KEY (idUtenteRicevente) REFERENCES utenti(idUtente)     ON DELETE CASCADE,
    FOREIGN KEY (idRisposta)        REFERENCES risposte(idRisposta) ON DELETE CASCADE
);

CREATE TABLE preferiti (
    idUtente        INT      NOT NULL,
    idPercorso      INT      NOT NULL,
    dataSalvataggio DATETIME DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (idUtente, idPercorso),
    FOREIGN KEY (idUtente)   REFERENCES utenti(idUtente)     ON DELETE CASCADE,
    FOREIGN KEY (idPercorso) REFERENCES percorsi(idPercorso) ON DELETE CASCADE
);

CREATE TABLE messaggi_privati (
    idMessaggio    INT      AUTO_INCREMENT PRIMARY KEY,
    idMittente     INT      NOT NULL,
    idDestinatario INT      NOT NULL,
    testo          TEXT     NOT NULL,
    dataInvio      DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (idMittente)     REFERENCES utenti(idUtente) ON DELETE CASCADE,
    FOREIGN KEY (idDestinatario) REFERENCES utenti(idUtente) ON DELETE CASCADE
);

CREATE TABLE notifiche (
    idNotifica   INT      AUTO_INCREMENT PRIMARY KEY,
    idUtente     INT      NOT NULL,
    testo        TEXT     NOT NULL,
    dataNotifica DATETIME DEFAULT CURRENT_TIMESTAMP,
    letta        BOOLEAN  DEFAULT FALSE,
    FOREIGN KEY (idUtente) REFERENCES utenti(idUtente) ON DELETE CASCADE
);

CREATE TABLE dettagliPercorsi (
    idDettaglio      INT           AUTO_INCREMENT NOT NULL,
    idPercorso       INT           NOT NULL UNIQUE,
    descrizione      TEXT          NOT NULL,
    indirizzo        VARCHAR(100)  NOT NULL,
    orariAccoglienza VARCHAR(100)  NOT NULL,
    breakdownBudget  TEXT          NOT NULL,
    nrTelefono       VARCHAR(20)   NOT NULL,
    url              VARCHAR(2048) NOT NULL,
    PRIMARY KEY (idDettaglio),
    FOREIGN KEY (idPercorso) REFERENCES percorsi(idPercorso) ON DELETE CASCADE
);


UPDATE utenti SET ruolo = 'admin' WHERE idUtente = 1;


DELIMITER //

-- Inserisce un annuncio solo se l'utente ha meno di 4 attivi.
CREATE PROCEDURE publicaAnnuncio(
    IN idUtenteAutore  INT,
    IN titoloAnnuncio  VARCHAR(150),
    IN testoAnnuncio   TEXT
)
BEGIN
    DECLARE numeroAnnunciAttivi INT;
    SELECT COUNT(*) INTO numeroAnnunciAttivi
    FROM   annunci
    WHERE  idUtente = idUtenteAutore AND stato = 'aperto';
    IF numeroAnnunciAttivi >= 4 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Hai raggiunto il limite di 4 annunci attivi.';
    END IF;
    INSERT INTO annunci (idUtente, titolo, testo)
    VALUES (idUtenteAutore, titoloAnnuncio, testoAnnuncio);
    SELECT LAST_INSERT_ID() AS idAnnuncio;
END //

-- Inserisce una recensione e aggiorna punteggioAffidabilita.
-- Blocca il doppio voto e l'auto-valutazione.
CREATE PROCEDURE valutaRisposta(
    IN idUtenteChePubblicaLaRecensione INT,
    IN idRispostaSelezionata           INT,
    IN votoAssegnato                   INT,
    IN commentoRecensione              TEXT
)
BEGIN
    DECLARE idUtenteCheRiceveLaRecensione INT;
    IF EXISTS (
        SELECT 1 FROM recensioni
        WHERE idUtenteScirttore = idUtenteChePubblicaLaRecensione
          AND idRisposta        = idRispostaSelezionata
    ) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Hai già valutato questa risposta.';
    END IF;
    SELECT idUtente INTO idUtenteCheRiceveLaRecensione
    FROM   risposte
    WHERE  idRisposta = idRispostaSelezionata;
    IF idUtenteCheRiceveLaRecensione = idUtenteChePubblicaLaRecensione THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Non puoi valutare una tua risposta.';
    END IF;
    INSERT INTO recensioni (idUtenteScirttore, idUtenteRicevente, idRisposta, voto, commento)
    VALUES (
        idUtenteChePubblicaLaRecensione,
        idUtenteCheRiceveLaRecensione,
        idRispostaSelezionata,
        votoAssegnato,
        commentoRecensione
    );

    UPDATE utenti
    SET    punteggioAffidabilita = punteggioAffidabilita + IF(votoAssegnato >= 5, 3, -2)
    WHERE  idUtente = idUtenteCheRiceveLaRecensione;
END //

DELIMITER ;
