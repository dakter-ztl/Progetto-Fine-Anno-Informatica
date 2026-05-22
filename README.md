
## Mereuta Victor 5IE

## Titolo progetto: Next Step


Il progetto consiste in un portale web di simulazione e orientamento post-diploma. Si tratta di un motore di ricerca intelligente che permette agli utenti di trovare percorsi di studio, universitari o lavorativi inserendo filtri concreti come budget mensile disponibile, materie di interesse, difficoltà (da 1 a 5) e la città desiderata del percorso. Il sito offre funzionalità di confronto diretto tra i percorsi e include una sezione "Bacheca" interattiva: qui gli utenti registrati possono pubblicare annunci (offerte di lavoro entry-level, richieste info, ricerca alloggi), visualizzare altri profili da dove si possono inviare messaggi privati e rispondere agli annunci esistenti. Il sistema prevede un'area pubblica per la ricerca, un'area riservata accessibile tramite login per la gestione del profilo e la pubblicazione degli annunci e un'area admin per gli amministratori che prevede un pannello di controllo aggiuntivo dove si possono inserire materie e percorsi e gestire le recensioni degli utenti in bacheca.


## Descrizione approfondita passo per passo del progetto Next Step

### **MODALITÀ SENZA LOGIN**
Al primo accesso al sito, lo studente visualizza un menu (`menuChoice.php`) realizzato con Bootstrap, dove può selezionare il **Simulatore**, la **Bacheca** o il **Login** (posizionato a destra). 

* **Simulatore:** Selezionando il Simulatore (o di default all'apertura del sito), l’utente viene indirizzato sulla homepage (`userPages/home.php`). Qui può impostare diversi filtri: materie di interesse (scrivendo nella barra realizzata con javascript oppure selezionando le materie con il puntatore), budget massimo mensile, città e difficoltà desiderata. 
* **Ricerca:** Cliccando sul pulsante **"Consigliami"**, parte la ricerca del percorso che rispetta i filtri impostati. I risultati vengono mostrati tramite card che riportano titolo, una breve descrizione, la città, il costo medio mensile e il pulsante dettagli.
* **Dettagli:** Cliccando sul pulsante **"Dettagli"**, l’utente viene indirizzato alla pagina `dettagliPercorso.php`, contenente l'indirizzo fisico della struttura (Università, ITS o lavoro), il numero di telefono, gli orari di accoglienza, una descrizione approfondita, il breakdown del budget e un link URL al sito web originale.
* **Bacheca e Sicurezza:** Se un utente non loggato prova ad accedere alla Bacheca, viene reindirizzato alla pagina di login. Se l'utente non possiede un account, può crearlo tramite il pulsante **"Registrati qui"**.

### **MODALITÀ CON LOGIN**
Una volta effettuato l'accesso, vengono sbloccate le funzionalità avanzate:

* **Bacheca:** L'utente può pubblicare un massimo di 4 annunci, rispondere agli altri post nella sezione commenti e recensire le risposte degli altri utenti tramite il pulsante **"Valuta"**.
* **Sistema di Valutazione:** Cliccando su "Valuta", l'utente accede a `recensioni.php` dove deve inserire un voto (da 1 a 10) e una motivazione della scelta. In base al voto, il punteggio di affidabilità dell'utente valutato aumenta di **3 punti** (voto $\ge$ 5) o diminuisce di **2 punti** (voto < 5).
* **Profili e Chat:** Cliccando sul nome di un utente in bacheca, si viene indirizzati a `visualizzaProfilo.php`, dove sono visibili il nome e il punteggio di affidabilità. Il pulsante **"Contatta"** apre `chat.php`, una chat effettiva che permette di inviare e cancellare messaggi.
* **Il Mio Profilo:** Schiacciando sul proprio nome utente si viene indirizzati a `profilo.php`, dove l'utente può visualizzare i propri post recenti, le notifiche (risposte ai post in bacheca e messaggi) e accedere alla sezione **"Vai ai messaggi privati"** (`messaggi.php`) per consultare lo storico delle chat. È presente inoltre il tasto **Logout** per distruggere la sessione.

### **MODALITÀ ADMIN**
Gli utenti con privilegi admin visualizzano nel menu la voce **"Modalità ADMIN"**, che reindirizza ad `adminMenu.php`. Questo pannello di controllo presenta due sezioni principali per l'aggiornamento del database:

1.  **Gestione Materie (`inserisciMaterie.php`):** Permette di aggiungere una nuova materia inserendone il nome e salvandola nel database.
2.  **Gestione Percorsi (`inserisciPercorsi.php`):** Permette di creare un nuovo percorso inserendo Titolo, Categoria (selezionabile tra **ITS, Università o Lavoro**), descrizione, costo medio mensile, città, difficoltà e la lista delle materie collegate.
* **Gestione recensioni:(`gestisciRecensioni.php`)** Gli amministratori hanno la facoltà di controllare le recensioni dei commenti di tutti gli utenti per garantire una corretta funzionalita del sistema di punteggio.


Link del sito: https://prontonextstep.it


### Diagramma delle relazioni delle tabelle del database

```
utenti (1) ──── pubblica ──── (N) annunci
utenti (1) ──── scrive ──── (N) risposte
utenti (1) ──── invia/riceve ──── (N) messaggi
utenti (1) ──── riceve ──── (N) notifiche
utenti (1) ──── salva ──── (N) preferiti
utenti (1) ──── valuta ──── (N) recensioni (M:N con utenti)

categorie (1) ──── contiene ──── (N) percorsi
percorsi (1) ──── ha ──── (1) dettagliPercorsi
percorsi (M) ──── include ──── (N) materie [via percorsiMaterie]

annunci (1) ──── riceve ──── (N) risposte
preferiti (M) ──── collega ──── (N) percorsi e utenti
```

* **STRUTTURA DATABASE:**

```sql

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

CREATE TABLE percorsiMaterie (
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

CREATE TABLE messaggi (
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
-- Blocca il doppio voto e l'auto-valutazione.DELIMITER //

CREATE PROCEDURE valutaRisposta(
    IN idUtenteChePubblicaLaRecensione INT,
    IN idRispostaSelezionata           INT,
    IN votoAssegnato                   INT,
    IN commentoRecensione              TEXT
)
BEGIN
    DECLARE idUtenteCheRiceveLaRecensione INT;

    -- Controlla se l'utente ha già valutato questa risposta
    IF EXISTS (
        SELECT 1 FROM recensioni
        WHERE idUtenteScirttore = idUtenteChePubblicaLaRecensione
          AND idRisposta        = idRispostaSelezionata
    ) THEN
        RESIGNAL
            SET MESSAGE_TEXT = 'Hai già valutato questa risposta.';
    END IF;

    -- Recupera l'ID dell'utente che riceve la recensione
    SELECT idUtente INTO idUtenteCheRiceveLaRecensione
    FROM   risposte
    WHERE  idRisposta = idRispostaSelezionata;

    -- Controlla se l'utente sta cercando di valutare la propria risposta
    IF idUtenteCheRiceveLaRecensione = idUtenteChePubblicaLaRecensione THEN
        RESIGNAL
            SET MESSAGE_TEXT = 'Non puoi valutare una tua risposta.';
    END IF;

    -- Inserisce la recensione nella tabella
    INSERT INTO recensioni (idUtenteScirttore, idUtenteRicevente, idRisposta, voto, commento)
    VALUES (
        idUtenteChePubblicaLaRecensione,
        idUtenteCheRiceveLaRecensione,
        idRispostaSelezionata,
        votoAssegnato,
        commentoRecensione
    );

    -- Aggiorna il punteggio di affidabilità dell'utente che riceve la recensione
    UPDATE utenti
    SET    punteggioAffidabilita = punteggioAffidabilita + IF(votoAssegnato >= 5, 3, -2)
    WHERE  idUtente = idUtenteCheRiceveLaRecensione;
END //

DELIMITER ;
```
### **Screenshot**
____________________________________________________________

### **Home senza aver fatto l'accesso**

<img width="1876" height="991" alt="simsenzalogin" src="https://github.com/user-attachments/assets/79b5fa36-2d24-4a14-986f-d12fcb6a61d1" />

### **Esempio di ricerca sul simulatore senza login**

<img width="1877" height="952" alt="esricercasimsenzalogin" src="https://github.com/user-attachments/assets/c83dde43-6bcb-4af6-bb25-84fe98c69af1" />

### **Dettagli del percorso**

<img width="1877" height="955" alt="es dettaglipercoros" src="https://github.com/user-attachments/assets/382f7f49-53e4-4c1b-8d07-c57001a8631b" />

### **Esempio di ricerca a vuoto senza filtri**
<img width="1877" height="959" alt="ricercasimtuttipercorsi" src="https://github.com/user-attachments/assets415ec81b-6b5b-4cd9-bdee-0f7c32eee97f" />

### **Home avendo fatto l'accesso**

<img width="1877" height="954" alt="homeconlogin" src="https://github.com/user-attachments/assets/36601512-5ba1-4695-b605-dfad50bdf3c2" />

### **Bacheca**

<img width="1878" height="955" alt="bacheca" src="https://github.com/user-attachments/assets/1b0c5838-2e7e-445b-bb65-d54d8a34cc5a" />

### **Valuta un commento in bacheca**

<img width="1877" height="957" alt="valutacommento" src="https://github.com/user-attachments/assets/031fd40a-934f-4750-ae87-c5f5ba4da06e" />

### **Visualizza un profilo schiacciando sul nome in bacheca**

<img width="1878" height="956" alt="visualizzaprofi" src="https://github.com/user-attachments/assets/d7711a86-5ce3-49af-84a3-2cec43a5174d" />

### **Il tuo profilo dove si trovano notifiche etc**

<img width="1877" height="992" alt="iltuoprofilo" src="https://github.com/user-attachments/assets/2a958498-a99c-45a4-a4d3-cbfdcaa25f3f" />

### **Le tue conversazioni**

<img width="1877" height="960" alt="letueconversazioni" src="https://github.com/user-attachments/assets/6fe18dcf-dc32-445b-9f7f-d44d8c6bfc7b" />

### **Esempio chat banale**

<img width="1880" height="957" alt="chat" src="https://github.com/user-attachments/assets/3a42e857-d3a1-4166-b39f-fd577920fbc8" />

### **Home con accesso admin (privilegi elevati)**

<img width="1877" height="957" alt="homeadmin" src="https://github.com/user-attachments/assets/fd7274b6-f1cb-4832-9197-91da7f05ee6c" />

### **Bacheca admin**

<img width="1875" height="957" alt="bachechaadmin" src="https://github.com/user-attachments/assets/2db9a8f3-b739-4412-9f41-d10e81e43b74" />

### **Panello di controllo admin**

<img width="1877" height="957" alt="pannellodiconytrollo" src="https://github.com/user-attachments/assets/4703202a-f2a9-48bd-871a-8f929ff47cb0" />

### **Sezione aggiunta percorsi**

<img width="1876" height="955" alt="aggiuntapercorsi" src="https://github.com/user-attachments/assets/24585958-1153-45d0-a8e9-9962aceb6bb4" />

### **Sezione aggiunta materie**

<img width="1877" height="956" alt="aggiuntmaterie" src="https://github.com/user-attachments/assets/2feae5a9-d11f-41cf-85c6-afb9160c2e86" />



Questo progetto è stato sviluppato come progetto scolastico di fine anno in Informatica.

**Autore:** Mereuta Victor - Classe 5IE  
**Anno Scolastico:** 2025/2026

---
