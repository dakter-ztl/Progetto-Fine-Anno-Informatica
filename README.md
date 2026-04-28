
## Mereuta Victor 5IE

## Titolo progetto: Next Step


Il progetto consiste in un portale web di simulazione e orientamento post-diploma. Si tratta di un motore di ricerca intelligente che permette agli utenti (studenti) di trovare percorsi di studio, universitari o lavorativi inserendo filtri concreti come budget mensile disponibile, materie di interesse, difficoltà (da 1 a 5) e la città desiderata del percorso. Il sito offre funzionalità di confronto diretto tra i percorsi e include una sezione "Bacheca" interattiva: qui gli utenti registrati possono pubblicare annunci (offerte di lavoro entry-level, richieste info, ricerca alloggi),visuallizare altri profili da dove si possono inviare messaggi privati e rispondere agli annunci esistenti. Il sistema prevede un'area pubblica per la ricerca, un'area riservata accessibile tramite login per la gestione del profilo e la pubblicazione degli annunci e un'area admin per gli amministratori che prevede un pannello di controllo aggiuntivo.


## Descrizione approfondita passo per passo del progetto Next Step

### **MODALITÀ SENZA LOGIN**
Al primo accesso al sito, lo studente visualizza un menu (`menuChoice.php`) realizzato con Bootstrap, dove può selezionare il **Simulatore**, la **Bacheca** o il **Login** (posizionato a destra). 

* **Simulatore:** Selezionando il Simulatore (o di default all'apertura del sito), l’utente viene indirizzato sulla homepage (`userPages/home.php`). Qui può impostare diversi filtri: materie di interesse, budget massimo mensile, città e difficoltà desiderata. 
* **Ricerca:** Cliccando sul pulsante **"Consigliami"**, parte la ricerca del percorso che rispetta i filtri impostati. I risultati vengono mostrati tramite card che riportano titolo, una breve descrizione, la città e il costo medio mensile.
* **Dettagli:** Cliccando sul pulsante **"Dettagli"**, l’utente viene indirizzato alla pagina `dettagliPercorso.php`, contenente l'indirizzo dell'istituto (Università, ITS o lavoro), il numero di telefono, gli orari di accoglienza, una descrizione approfondita, il breakdown del budget e un link URL al percorso originale.
* **Bacheca e Sicurezza:** Se un utente non loggato prova ad accedere alla Bacheca, viene reindirizzato alla pagina di login. Il sistema prevede un massimo di **5 tentativi di login ogni 2 minuti** per prevenire lo spam. Se l'utente non possiede un account, può crearlo tramite il pulsante **"Registrati qui"**.

### **MODALITÀ CON LOGIN**
Una volta effettuato l'accesso, vengono sbloccate le funzionalità avanzate:

* **Bacheca:** L'utente può pubblicare un massimo di 4 annunci, rispondere agli altri post nella sezione commenti e recensire le risposte degli altri utenti tramite il pulsante **"Valuta"**.
* **Sistema di Valutazione:** Cliccando su "Valuta", l'utente accede a `recensioni.php` dove deve inserire un voto (da 1 a 10) e una motivazione. In base al voto, il punteggio di affidabilità dell'utente valutato aumenta di **3 punti** (voto $\ge$ 5) o diminuisce di **2 punti** (voto < 5).
* **Profili e Chat:** Cliccando sul nome di un utente in bacheca, si viene indirizzati a `visualizzaProfilo.php`, dove sono visibili il nome e il punteggio di affidabilità. Il pulsante **"Contatta"** apre `chat.php`, una chat effettiva che permette di inviare e cancellare messaggi.
* **Il Mio Profilo:** Nel menu appare la voce `profilo.php`, dove l'utente può visualizzare i propri post recenti, le notifiche (risposte ai post in bacheca) e accedere alla sezione **"Vai ai messaggi privati"** (`messaggi.php`) per consultare lo storico delle chat. È presente inoltre il tasto **Logout** per distruggere la sessione.

### **MODALITÀ ADMIN**
Gli utenti con privilegi admin visualizzano nel menu la voce **"Modalità ADMIN"**, che reindirizza ad `adminMenu.php`. Questo pannello di controllo presenta due sezioni principali per l'aggiornamento del database:

1.  **Gestione Materie (`inserisciMaterie.php`):** Permette di aggiungere una nuova materia inserendone il nome e salvandola nel database.
2.  **Gestione Percorsi (`inserisciPercorsi.php`):** Permette di creare un nuovo percorso inserendo Titolo, Categoria (selezionabile tra **ITS, Università o Lavoro**), descrizione, costo medio mensile, città, difficoltà e la lista delle materie collegate.
* **Moderazione:** Gli amministratori hanno la facoltà di eliminare gli annunci e i commenti di tutti gli utenti per garantire la corretta convivenza sulla piattaforma.


Link del sito: https://prontonextstep.it

* **STRUTTURA DATABASE:**

‘’’sql
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

CREATE TABLE dettagliPercorsi(
    idDettaglio INT AUTO_INCREMENT NOT NULL,
    idPercorso INT NOT NULL,
    descrizione TEXT NOT NULL,
    indirizzo VARCHAR(100) not NULL,
    orariAccoglienza VARCHAR(100) NOT NULL,
    breakdownBudget TEXT NOT NULL,
    nrTelefono INT NOT NULL,
    url VARCHAR(2048) NOT NULL,
    PRIMARY KEY(idDettaglio),
    Foreign Key (idPercorso) REFERENCES percorsi(idPercorso) ON DELETE CASCADE
);


’’’
