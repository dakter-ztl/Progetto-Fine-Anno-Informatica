# 🎓 Next Step - Portale di Orientamento Post-Diploma

[![Project Status](https://img.shields.io/badge/status-active-success.svg)]()
[![GitHub](https://img.shields.io/badge/github-dakter--ztl-blue)](https://github.com/dakter-ztl/Progetto-Fine-Anno-Informatica)
[![Website](https://img.shields.io/badge/website-online-green)](https://prontonextstep.it)

> **Progetto di Fine Anno - Informatica 5IE**  
> **Autore:** Mereuta Victor

Un portale web intelligente per l'orientamento post-diploma che aiuta gli studenti a trovare il percorso formativo o lavorativo più adatto alle loro esigenze, con funzionalità social e sistema di messaggistica integrato.

---

## 📋 Indice

- [Panoramica](#-panoramica)
- [Caratteristiche Principali](#-caratteristiche-principali)
- [Tecnologie Utilizzate](#-tecnologie-utilizzate)
- [Architettura del Sistema](#-architettura-del-sistema)
- [Struttura Database](#-struttura-database)
- [Funzionalità Dettagliate](#-funzionalità-dettagliate)
- [Screenshot](#-screenshot)
- [Installazione](#-installazione)
- [Sicurezza](#-sicurezza)
- [Roadmap](#-roadmap)

---

## 🎯 Panoramica

**Next Step** è un motore di ricerca intelligente che permette agli studenti di trovare percorsi universitari, ITS o opportunità lavorative entry-level in base a criteri concreti:

- 💰 **Budget mensile disponibile**
- 📚 **Materie di interesse**
- 📊 **Livello di difficoltà** (scala 1-5)
- 📍 **Città desiderata**

Il sistema include una **bacheca interattiva** dove gli utenti possono pubblicare annunci, rispondere a post, valutare altri utenti e comunicare tramite messaggistica privata.

🌐 **Sito live:** [prontonextstep.it](https://prontonextstep.it)

---

## ✨ Caratteristiche Principali

### 🔍 Simulatore Intelligente
- **Filtri avanzati** per ricerca personalizzata
- **Card informative** con dettagli immediati
- **Pagine di dettaglio** complete con:
  - Indirizzo dell'istituto
  - Contatti e orari
  - Breakdown dettagliato del budget
  - Link al sito ufficiale

### 💬 Bacheca Social
- **Pubblicazione annunci** (max 4 per utente)
- **Sistema di commenti** e risposte
- **Valutazione peer-to-peer** (voti da 1 a 10)
- **Punteggio di affidabilità** dinamico

### 📨 Sistema di Messaggistica
- **Chat privata** tra utenti
- **Storico messaggi** completo
- **Notifiche** per nuove risposte agli annunci

### 👤 Gestione Profili
- Visualizzazione profili pubblici
- Punteggio di affidabilità visibile
- Cronologia post personali

### 🛡️ Pannello Admin
- **Gestione materie** e categorie
- **Inserimento percorsi** con materie collegate
- **Moderazione** annunci e commenti
- **Controllo completo** del contenuto

---

## 🛠️ Tecnologie Utilizzate

### Frontend
- ![HTML5](https://img.shields.io/badge/-HTML5-E34F26?logo=html5&logoColor=white) HTML5
- ![CSS3](https://img.shields.io/badge/-CSS3-1572B6?logo=css3&logoColor=white) CSS3
- ![JavaScript](https://img.shields.io/badge/-JavaScript-F7DF1E?logo=javascript&logoColor=black) JavaScript
- ![Bootstrap](https://img.shields.io/badge/-Bootstrap-7952B3?logo=bootstrap&logoColor=white) Bootstrap

### Backend
- ![PHP](https://img.shields.io/badge/-PHP-777BB4?logo=php&logoColor=white) PHP
- ![MySQL](https://img.shields.io/badge/-MySQL-4479A1?logo=mysql&logoColor=white) MySQL

### Sicurezza
- Sistema di **rate limiting** (5 tentativi ogni 2 minuti)
- **Hashing password** con algoritmi sicuri
- **Validazione input** lato server
- **Protezione SQL injection**

---

## 🏗️ Architettura del Sistema

```
Next Step/
├── userPages/
│   ├── home.php              # Homepage con simulatore
│   ├── bacheca.php           # Bacheca annunci
│   ├── dettagliPercorso.php  # Dettagli percorso
│   ├── profilo.php           # Profilo utente
│   ├── visualizzaProfilo.php # Profilo pubblico altri utenti
│   ├── chat.php              # Chat privata
│   ├── messaggi.php          # Lista conversazioni
│   └── percorsiSalvati.php   # Percorsi preferiti
├── adminPages/
│   ├── adminMenu.php         # Pannello di controllo
│   ├── inserisciPercorsi.php # Gestione percorsi
│   └── inserisciMaterie.php  # Gestione materie
├── include/
│   ├── loginForm.php         # Form login
│   ├── menuChoice.php        # Menu navigazione
│   └── recensioni.php        # Sistema valutazione
└── assets/
    ├── css/
    ├── js/
    └── images/
```

---

## 🗄️ Struttura Database

### Schema E-R Completo

Il database è progettato con 11 tabelle principali e relazioni ottimizzate:

#### 📊 Tabelle Principali

**1. utenti**
```sql
CREATE TABLE utenti(
    idUtente INT AUTO_INCREMENT NOT NULL,
    nome VARCHAR(100) NOT NULL,        
    password VARCHAR(255) NOT NULL,   
    ruolo ENUM('studente','mentore','admin') DEFAULT 'studente',
    tipoDiploma VARCHAR(255),
    punteggioAffidabilita INT DEFAULT 0, 
    PRIMARY KEY(idUtente)
);
```

**2. categorie**
```sql
CREATE TABLE categorie(
    idCategoria INT AUTO_INCREMENT NOT NULL,
    nomeCategoria VARCHAR(50) NOT NULL, 
    PRIMARY KEY(idCategoria)
);
```

**3. percorsi**
```sql
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
```

**4. dettagliPercorsi**
```sql
CREATE TABLE dettagliPercorsi(
    idDettaglio INT AUTO_INCREMENT NOT NULL,
    idPercorso INT NOT NULL,
    descrizione TEXT NOT NULL,
    indirizzo VARCHAR(100) NOT NULL,
    orariAccoglienza VARCHAR(100) NOT NULL,
    breakdownBudget TEXT NOT NULL,
    nrTelefono VARCHAR(20) NOT NULL,
    url VARCHAR(2048) NOT NULL,
    PRIMARY KEY(idDettaglio),
    FOREIGN KEY(idPercorso) REFERENCES percorsi(idPercorso) ON DELETE CASCADE
);
```

**5. materie**
```sql
CREATE TABLE materie(
    idMateria INT AUTO_INCREMENT NOT NULL,
    nomeMateria VARCHAR(100) NOT NULL,
    PRIMARY KEY(idMateria)
);
```

**6. percorsi_materie** (Tabella Junction M:N)
```sql
CREATE TABLE percorsi_materie(
    idPercorso INT NOT NULL,
    idMateria INT NOT NULL,
    PRIMARY KEY(idPercorso, idMateria),
    FOREIGN KEY(idPercorso) REFERENCES percorsi(idPercorso) ON DELETE CASCADE,
    FOREIGN KEY(idMateria) REFERENCES materie(idMateria) ON DELETE CASCADE
);
```

**7. annunci**
```sql
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
```

**8. risposte**
```sql
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
```

**9. recensioni**
```sql
CREATE TABLE recensioni(
    idRecensione INT AUTO_INCREMENT NOT NULL,
    idUtenteScritore INT NOT NULL,
    idUtenteRicevente INT NOT NULL,
    voto INT CHECK (voto BETWEEN 1 AND 10),
    commento TEXT,
    dataRecensione DATETIME DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY(idRecensione),
    FOREIGN KEY(idUtenteScritore) REFERENCES utenti(idUtente) ON DELETE CASCADE,
    FOREIGN KEY(idUtenteRicevente) REFERENCES utenti(idUtente) ON DELETE CASCADE
);
```

**10. messaggi_privati**
```sql
CREATE TABLE messaggi_privati(
    idMessaggio INT AUTO_INCREMENT PRIMARY KEY,
    idMittente INT NOT NULL,
    idDestinatario INT NOT NULL,
    testo TEXT NOT NULL,
    dataInvio DATETIME DEFAULT CURRENT_TIMESTAMP,
    letto BOOLEAN DEFAULT FALSE,
    FOREIGN KEY(idMittente) REFERENCES utenti(idUtente) ON DELETE CASCADE,
    FOREIGN KEY(idDestinatario) REFERENCES utenti(idUtente) ON DELETE CASCADE
);
```

**11. notifiche**
```sql
CREATE TABLE notifiche(
    idNotifica INT AUTO_INCREMENT PRIMARY KEY,
    idUtente INT NOT NULL, 
    testo TEXT NOT NULL,
    dataNotifica DATETIME DEFAULT CURRENT_TIMESTAMP,
    letta BOOLEAN DEFAULT FALSE,
    FOREIGN KEY(idUtente) REFERENCES utenti(idUtente) ON DELETE CASCADE
);
```

**12. preferiti**
```sql
CREATE TABLE preferiti(
    idUtente INT NOT NULL,
    idPercorso INT NOT NULL,
    dataSalvataggio DATETIME DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY(idUtente, idPercorso),
    FOREIGN KEY(idUtente) REFERENCES utenti(idUtente) ON DELETE CASCADE,
    FOREIGN KEY(idPercorso) REFERENCES percorsi(idPercorso) ON DELETE CASCADE
);
```

### Diagramma delle Relazioni

```
utenti (1) ──── pubblica ──── (N) annunci
utenti (1) ──── scrive ──── (N) risposte
utenti (1) ──── invia/riceve ──── (N) messaggi_privati
utenti (1) ──── riceve ──── (N) notifiche
utenti (1) ──── salva ──── (N) preferiti
utenti (1) ──── valuta ──── (N) recensioni (M:N con utenti)

categorie (1) ──── contiene ──── (N) percorsi
percorsi (1) ──── ha ──── (1) dettagliPercorsi
percorsi (M) ──── include ──── (N) materie [via percorsi_materie]

annunci (1) ──── riceve ──── (N) risposte
preferiti (M) ──── collega ──── (N) percorsi e utenti
```

---

## 📱 Funzionalità Dettagliate

### 🔓 Modalità Pubblica (Senza Login)

#### Simulatore
1. **Accesso alla homepage** (`userPages/home.php`)
2. **Impostazione filtri:**
   - Selezione materie (checkbox multipli)
   - Budget massimo mensile (input numerico)
   - Città desiderata (input testo)
   - Difficoltà (slider 1-5)
3. **Ricerca percorsi** tramite pulsante "Consigliami"
4. **Visualizzazione risultati** in card con:
   - Titolo percorso
   - Descrizione breve
   - Città
   - Costo medio mensile
5. **Dettagli completi** cliccando su "Dettagli"

#### Protezioni
- Redirect automatico al login per accesso bacheca
- Rate limiting: **5 tentativi ogni 2 minuti**

---

### 🔐 Modalità Utente Registrato

#### Bacheca Interattiva
- **Pubblicazione annunci** (limite 4 per utente)
- **Risposta ad annunci** esistenti
- **Valutazione risposte** tramite sistema recensioni

#### Sistema Recensioni
- Accesso a `recensioni.php` tramite pulsante "Valuta"
- **Input richiesti:**
  - Voto: 1-10
  - Motivazione testuale
- **Algoritmo punteggio:**
  - Voto ≥ 5: **+3 punti** affidabilità
  - Voto < 5: **-2 punti** affidabilità

#### Profili e Social
- **Visualizzazione profili** cliccando sul nome utente
- **Informazioni visibili:**
  - Nome
  - Punteggio affidabilità
- **Pulsante "Contatta"** → apertura chat privata

#### Chat e Messaggistica
- Chat in tempo reale (`chat.php`)
- **Funzionalità:**
  - Invio messaggi
  - Cancellazione messaggi propri
  - Storico conversazioni (`messaggi.php`)

#### Area Personale
- **Sezione "Il Mio Profilo"** (`profilo.php`)
  - Post recenti
  - Notifiche (risposte ai propri annunci)
  - Accesso messaggi privati
  - Pulsante **Logout**

#### Percorsi Salvati
- **Salvataggio preferiti** con timestamp
- **Accesso rapido** ai percorsi salvati

---

### 👨‍💼 Modalità Amministratore

#### Pannello di Controllo (`adminMenu.php`)

**1. Gestione Materie** (`inserisciMaterie.php`)
- Aggiunta nuove materie al database
- Campi richiesti:
  - Nome materia

**2. Gestione Percorsi** (`inserisciPercorsi.php`)
- Creazione nuovi percorsi
- **Campi richiesti:**
  - Titolo
  - Categoria (ITS, Università, Lavoro)
  - Descrizione
  - Costo medio mensile
  - Città
  - Difficoltà (1-5)
  - Materie collegate (selezione multipla)

**3. Moderazione Contenuti**
- **Eliminazione annunci** inappropriati
- **Rimozione commenti** non conformi
- Garantisce convivenza corretta sulla piattaforma

---

## 📸 Screenshot

### 🏠 Homepage (Senza Login)
![Home senza login](https://github.com/user-attachments/assets/79b5fa36-2d24-4a14-986f-d12fcb6a61d1)

### 🔍 Esempio Ricerca Simulatore
![Ricerca simulatore](https://github.com/user-attachments/assets/c83dde43-6bcb-4af6-bb25-84fe98c69af1)

### 📄 Dettagli Percorso
![Dettagli percorso](https://github.com/user-attachments/assets/382f7f49-53e4-4c1b-8d07-c57001a8631b)

### 🔍 Ricerca Completa (Tutti i Percorsi)
![Ricerca tutti percorsi](https://github.com/user-attachments/assets/415ec81b-6b5b-4cd9-bdee-0f7c32eee97f)

### 🏠 Homepage (Con Login)
![Home con login](https://github.com/user-attachments/assets/36601512-5ba1-4695-b605-dfad50bdf3c2)

### 📋 Bacheca Annunci
![Bacheca](https://github.com/user-attachments/assets/1b0c5838-2e7e-445b-bb65-d54d8a34cc5a)

### ⭐ Valutazione Commento
![Valuta commento](https://github.com/user-attachments/assets/031fd40a-934f-4750-ae87-c5f5ba4da06e)

### 👤 Visualizzazione Profilo
![Visualizza profilo](https://github.com/user-attachments/assets/d7711a86-5ce3-49af-84a3-2cec43a5174d)

### 👤 Il Tuo Profilo
![Il tuo profilo](https://github.com/user-attachments/assets/2a958498-a99c-45a4-a4d3-cbfdcaa25f3f)

### 💬 Lista Conversazioni
![Conversazioni](https://github.com/user-attachments/assets/6fe18dcf-dc32-445b-9f7f-d44d8c6bfc7b)

### 💬 Esempio Chat
![Chat](https://github.com/user-attachments/assets/3a42e857-d3a1-4166-b39f-fd577920fbc8)

### 👨‍💼 Home Admin
![Home admin](https://github.com/user-attachments/assets/fd7274b6-f1cb-4832-9197-91da7f05ee6c)

### 📋 Bacheca Admin
![Bacheca admin](https://github.com/user-attachments/assets/2db9a8f3-b739-4412-9f41-d10e81e43b74)

### ⚙️ Pannello di Controllo Admin
![Pannello controllo](https://github.com/user-attachments/assets/4703202a-f2a9-48bd-871a-8f929ff47cb0)

### ➕ Aggiunta Percorsi
![Aggiunta percorsi](https://github.com/user-attachments/assets/24585958-1153-45d0-a8e9-9962aceb6bb4)

### ➕ Aggiunta Materie
![Aggiunta materie](https://github.com/user-attachments/assets/2feae5a9-d11f-41cf-85c6-afb9160c2e86)

---

## 🚀 Installazione

### Requisiti
- PHP 7.4 o superiore
- MySQL 5.7 o superiore
- Apache/Nginx web server
- Supporto sessioni PHP

### Setup Locale

1. **Clone del repository**
```bash
git clone https://github.com/dakter-ztl/Progetto-Fine-Anno-Informatica.git
cd Progetto-Fine-Anno-Informatica
```

2. **Configurazione database**
```bash
# Crea il database
mysql -u root -p < database/schema.sql

# Configura credenziali in config.php
cp config.example.php config.php
# Modifica config.php con le tue credenziali
```

3. **Configurazione web server**
```bash
# Apache
sudo a2enmod rewrite
sudo systemctl restart apache2

# Imposta document root su /path/to/project
```

4. **Permessi**
```bash
chmod 755 userPages/ adminPages/ include/
chmod 644 *.php
```

5. **Accedi al sito**
```
http://localhost/
```

### Setup Produzione

Per il deployment su server di produzione:

1. **Upload files** via FTP/SFTP
2. **Importa database** tramite phpMyAdmin
3. **Configura SSL/HTTPS** (consigliato Let's Encrypt)
4. **Imposta permessi** corretti (755 directory, 644 files)
5. **Configura backup** automatici database

---

## 🔒 Sicurezza

### Misure Implementate

✅ **Autenticazione**
- Password hashing con `password_hash()` (bcrypt)
- Protezione contro brute force (rate limiting)
- Sessioni sicure con timeout

✅ **Validazione Input**
- Prepared statements per query SQL
- Sanitizzazione input utente
- Validazione lato server e client

✅ **Protezione XSS**
- Escape output con `htmlspecialchars()`
- Content Security Policy headers

✅ **Protezione CSRF**
- Token CSRF per form critici
- Verifica referer

✅ **Rate Limiting**
- Max 5 tentativi login ogni 2 minuti
- Blocco temporaneo IP sospetti

---

## 🗺️ Roadmap

### ✅ Versione 1.0 (Attuale)
- [x] Simulatore percorsi con filtri
- [x] Sistema bacheca e annunci
- [x] Chat privata tra utenti
- [x] Sistema recensioni e affidabilità
- [x] Pannello admin completo

### 🎯 Versione 2.0 (Pianificata)
- [ ] **Sistema notifiche push** (real-time)
- [ ] **Matching automatico** basato su AI
- [ ] **Calendario eventi** orientamento
- [ ] **Forum tematico** per categoria
- [ ] **Export CV** automatico
- [ ] **Integrazione API** università
- [ ] **App mobile** (React Native)
- [ ] **Sistema badge** e gamification

### 🔮 Future Features
- [ ] Videoconferenze integrate
- [ ] Chatbot AI per assistenza
- [ ] Sistema raccomandazioni ML
- [ ] Analytics avanzati per admin
- [ ] Marketplace servizi tutoring

---

## 📊 Statistiche Progetto

- **Linee di codice:** ~5,000+
- **Tabelle database:** 12
- **Pagine PHP:** 20+
- **Ruoli utente:** 3 (studente, mentore, admin)
- **Materie disponibili:** 200+

---

## 🤝 Contributi

Questo è un progetto educativo. Per suggerimenti o segnalazioni:

1. Apri una **Issue** su GitHub
2. Descrivi il problema o la feature richiesta
3. Attendi feedback

---

## 📄 Licenza

Questo progetto è stato sviluppato come progetto scolastico per l'esame di Informatica.

**Autore:** Mereuta Victor - Classe 5IE  
**Anno Scolastico:** 2025/2026

---

## 📧 Contatti

- **Sito Web:** [prontonextstep.it](https://prontonextstep.it)
- **GitHub:** [dakter-ztl](https://github.com/dakter-ztl)
- **Repository:** [Progetto-Fine-Anno-Informatica](https://github.com/dakter-ztl/Progetto-Fine-Anno-Informatica)
