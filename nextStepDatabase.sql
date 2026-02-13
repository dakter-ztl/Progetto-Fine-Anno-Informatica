-- phpMyAdmin SQL Dump
-- version 5.2.2
-- https://www.phpmyadmin.net/
--
-- Host: tb-be04-hclwebnx036.srv.teamblue-ops.net:3306
-- Creato il: Feb 05, 2026 alle 18:56
-- Versione del server: 8.0.36-28
-- Versione PHP: 7.4.28

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `pronv6_zwjejm53`
--

-- --------------------------------------------------------

--
-- Struttura della tabella `annunci`
--

CREATE TABLE `annunci` (
  `idAnnuncio` int NOT NULL,
  `titolo` varchar(150) DEFAULT NULL,
  `testo` text,
  `dataPubblicazione` datetime DEFAULT CURRENT_TIMESTAMP,
  `stato` enum('aperto','chiuso') DEFAULT 'aperto',
  `inEvidenza` tinyint(1) DEFAULT '0',
  `idUtente` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dump dei dati per la tabella `annunci`
--

INSERT INTO `annunci` (`idAnnuncio`, `titolo`, `testo`, `dataPubblicazione`, `stato`, `inEvidenza`, `idUtente`) VALUES
(1, 'Consiglio su Ingegneria', 'Qualcuno sa dirmi se la Sapienza è molto difficile?', '2026-02-04 23:45:47', 'aperto', 0, 2),
(2, 'Cerco Mentore per PHP', 'Ho difficoltà con le classi e il PDO.', '2026-02-04 23:45:47', 'aperto', 0, 4),
(3, 'Sbocchi lavorativi Marketing', 'Conviene fare un master dopo la triennale?', '2026-02-04 23:45:47', 'aperto', 0, 2),
(4, 'Consiglio su Ingegneria', 'Qualcuno sa dirmi se la Sapienza è molto difficile?', '2026-02-05 09:40:34', 'aperto', 0, 5),
(5, 'Consiglio su Ingegneria', '3123123', '2026-02-05 09:46:15', 'aperto', 0, 12),
(6, 'Consiglio su Ingegneria', '123', '2026-02-05 09:48:56', 'aperto', 0, 12),
(7, 'Consiglio su Ingegneria', '123', '2026-02-05 09:49:18', 'aperto', 0, 12),
(8, '123', '123', '2026-02-05 09:49:21', 'aperto', 0, 12),
(9, '123', '123', '2026-02-05 09:49:48', 'aperto', 0, 12),
(10, '123', '123', '2026-02-05 09:49:51', 'aperto', 0, 12);

-- --------------------------------------------------------

--
-- Struttura della tabella `categorie`
--

CREATE TABLE `categorie` (
  `idCategoria` int NOT NULL,
  `nomeCategoria` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dump dei dati per la tabella `categorie`
--

INSERT INTO `categorie` (`idCategoria`, `nomeCategoria`) VALUES
(1, 'Università'),
(2, 'Academy IT'),
(3, 'Master Specialistico'),
(4, 'Corsi Professionali');

-- --------------------------------------------------------

--
-- Struttura della tabella `materie`
--

CREATE TABLE `materie` (
  `idMateria` int NOT NULL,
  `nomeMateria` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dump dei dati per la tabella `materie`
--

INSERT INTO `materie` (`idMateria`, `nomeMateria`) VALUES
(1, 'Informatica'),
(2, 'Economia'),
(3, 'Marketing'),
(4, 'Design'),
(5, 'Diritto');

-- --------------------------------------------------------

--
-- Struttura della tabella `messaggi_privati`
--

CREATE TABLE `messaggi_privati` (
  `idMessaggio` int NOT NULL,
  `idMittente` int NOT NULL,
  `idDestinatario` int NOT NULL,
  `testo` text NOT NULL,
  `dataInvio` datetime DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Struttura della tabella `notifiche`
--

CREATE TABLE `notifiche` (
  `idNotifica` int NOT NULL,
  `idUtente` int NOT NULL,
  `testo` text NOT NULL,
  `dataNotifica` datetime DEFAULT CURRENT_TIMESTAMP,
  `letta` tinyint(1) DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dump dei dati per la tabella `notifiche`
--

INSERT INTO `notifiche` (`idNotifica`, `idUtente`, `testo`, `dataNotifica`, `letta`) VALUES
(1, 2, 'Elena Bianchi ha risposto al tuo annuncio.', '2026-02-04 23:45:47', 0),
(2, 4, 'Admin ha commentato la tua richiesta.', '2026-02-04 23:45:47', 0),
(3, 2, ' ha commentato il tuo post in bacheca.', '2026-02-05 09:40:07', 0);

-- --------------------------------------------------------

--
-- Struttura della tabella `percorsi`
--

CREATE TABLE `percorsi` (
  `idPercorso` int NOT NULL,
  `titolo` varchar(150) DEFAULT NULL,
  `descrizione` text,
  `costoMedioMensile` decimal(10,2) DEFAULT NULL,
  `difficolta` int DEFAULT NULL,
  `citta` varchar(100) DEFAULT NULL,
  `idCategoria` int NOT NULL
) ;

--
-- Dump dei dati per la tabella `percorsi`
--

INSERT INTO `percorsi` (`idPercorso`, `titolo`, `descrizione`, `costoMedioMensile`, `difficolta`, `citta`, `idCategoria`) VALUES
(1, 'Ingegneria Informatica Sapienza', 'Percorso accademico focalizzato su software e sistemi.', 0.00, 5, 'Roma', 1),
(2, 'Full Stack Web Developer', 'Corso intensivo su HTML, CSS, JS e PHP.', 450.00, 3, 'Milano', 2),
(3, 'Digital Marketing Master', 'Specializzazione in SEO e Social Media Ads.', 250.00, 2, 'Torino', 3),
(4, 'Economia e Finanza', 'Laurea triennale in gestione dei mercati finanziari.', 0.00, 4, 'Bologna', 1),
(5, 'Graphic Design Academy', 'Impara Photoshop, Illustrator e UX Design.', 180.00, 3, 'Napoli', 4),
(6, 'Cybersecurity Expert', 'Protezione reti e analisi delle vulnerabilità.', 500.00, 5, 'Pisa', 2),
(7, 'Giurisprudenza', 'Studio approfondito del sistema giuridico italiano.', 0.00, 5, 'Padova', 1),
(8, 'Social Media Manager', 'Gestione professionale di brand sui social.', 120.00, 2, 'Bari', 4),
(9, 'Data Science Master', 'Analisi dati avanzata e Machine Learning.', 600.00, 5, 'Milano', 3),
(10, 'E-commerce Management', 'Gestione operativa di store online.', 300.00, 3, 'Firenze', 3);

-- --------------------------------------------------------

--
-- Struttura della tabella `percorsi_materie`
--

CREATE TABLE `percorsi_materie` (
  `idPercorso` int NOT NULL,
  `idMateria` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dump dei dati per la tabella `percorsi_materie`
--

INSERT INTO `percorsi_materie` (`idPercorso`, `idMateria`) VALUES
(1, 1),
(2, 1),
(6, 1),
(9, 1),
(4, 2),
(10, 2),
(3, 3),
(8, 3),
(10, 3),
(2, 4),
(5, 4),
(7, 5);

-- --------------------------------------------------------

--
-- Struttura della tabella `preferiti`
--

CREATE TABLE `preferiti` (
  `idUtente` int NOT NULL,
  `idPercorso` int NOT NULL,
  `dataSalvataggio` datetime DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Struttura della tabella `risposte`
--

CREATE TABLE `risposte` (
  `idRisposta` int NOT NULL,
  `testo` text,
  `dataRisposta` datetime DEFAULT CURRENT_TIMESTAMP,
  `utile` tinyint(1) DEFAULT '0',
  `idAnnuncio` int NOT NULL,
  `idUtente` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dump dei dati per la tabella `risposte`
--

INSERT INTO `risposte` (`idRisposta`, `testo`, `dataRisposta`, `utile`, `idAnnuncio`, `idUtente`) VALUES
(1, 'È impegnativa, ma con la giusta costanza si supera.', '2026-02-04 23:45:47', 1, 1, 3),
(2, 'Ti consiglio di guardare la documentazione ufficiale di PHP.', '2026-02-04 23:45:47', 0, 2, 1),
(3, 'Assolutamente sì, il master ti dà competenze pratiche.', '2026-02-04 23:45:47', 1, 3, 3),
(4, 'barra neik', '2026-02-05 09:40:07', 0, 1, 5);

-- --------------------------------------------------------

--
-- Struttura della tabella `utenti`
--

CREATE TABLE `utenti` (
  `idUtente` int NOT NULL,
  `nome` varchar(100) NOT NULL,
  `password` varchar(255) NOT NULL,
  `ruolo` enum('studente','mentore','admin') DEFAULT 'studente',
  `tipoDiploma` varchar(255) DEFAULT NULL,
  `punteggioAffidabilita` int DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dump dei dati per la tabella `utenti`
--

INSERT INTO `utenti` (`idUtente`, `nome`, `password`, `ruolo`, `tipoDiploma`, `punteggioAffidabilita`) VALUES
(1, 'Admin_NextStep', 'ciscoX123', 'admin', 'Liceo Scientifico', 100),
(2, 'Marco_Rossi', 'password123', 'studente', 'Perito Informatico', 10),
(3, 'Elena_Bianchi', 'password123', 'mentore', 'Liceo Classico', 85),
(4, 'Alessandro_Verdi', 'password123', 'studente', 'Ragioneria', 5),
(5, 'vichiosu', '$2y$10$kMfREP0Go4MphCoK51qizu/DwHDfne.OZZwc9ZMN0fxrUOUto4vPu', 'studente', 'Professionale', 0),
(6, 'dakter', '$2y$10$P7gG7EqE2cRmRycILpbPZe5BQbcsuddb1CEi045dekkrGdgfoI72.', 'studente', 'Liceo', 0),
(7, 'dakter', '$2y$10$BM.C04R4IwmT13tmGVyVMO/maegsQPcgO1ixIJm512UapEQ6XVF76', 'studente', 'Tecnico', 0),
(8, 'dakter', '$2y$10$GKRF/I.u5HeCTq1aX9bfQegOkAyntTjRpHZ.jy8Y.XjBOhtDPua8S', 'studente', 'Professionale', 0),
(9, 'dakter', '$2y$10$/0ufhz2reG6qgO6UtE4k.uGJSXxMeVqhjwF2L8E65sM5I84W22gwa', 'studente', 'Tecnico', 0),
(10, 'pizda', '$2y$10$1otZ5sPrnt0LMyDAw9CsUepp7olewK3a9.CWXYWCTMYuw/sPB0Z4W', 'studente', 'Tecnico', 0),
(11, 'porcaccioDdio', '$2y$10$4Y4TImAvpdI3xq4OjX3/L.3WqwU80SuGw3M4slcizOnkszBFg./9C', 'studente', 'Tecnico', 0),
(12, 'giancristofaro', '$2y$10$xZray.auqP9kj1Ak31/uOOO8g1B/B1jtlNUrPefr3Sq2v/hHesAfe', 'studente', 'Tecnico', 0);

--
-- Indici per le tabelle scaricate
--

--
-- Indici per le tabelle `annunci`
--
ALTER TABLE `annunci`
  ADD PRIMARY KEY (`idAnnuncio`),
  ADD KEY `idUtente` (`idUtente`);

--
-- Indici per le tabelle `categorie`
--
ALTER TABLE `categorie`
  ADD PRIMARY KEY (`idCategoria`);

--
-- Indici per le tabelle `materie`
--
ALTER TABLE `materie`
  ADD PRIMARY KEY (`idMateria`);

--
-- Indici per le tabelle `messaggi_privati`
--
ALTER TABLE `messaggi_privati`
  ADD PRIMARY KEY (`idMessaggio`),
  ADD KEY `idMittente` (`idMittente`),
  ADD KEY `idDestinatario` (`idDestinatario`);

--
-- Indici per le tabelle `notifiche`
--
ALTER TABLE `notifiche`
  ADD PRIMARY KEY (`idNotifica`),
  ADD KEY `idUtente` (`idUtente`);

--
-- Indici per le tabelle `percorsi`
--
ALTER TABLE `percorsi`
  ADD PRIMARY KEY (`idPercorso`),
  ADD KEY `idCategoria` (`idCategoria`);

--
-- Indici per le tabelle `percorsi_materie`
--
ALTER TABLE `percorsi_materie`
  ADD PRIMARY KEY (`idPercorso`,`idMateria`),
  ADD KEY `fk_materia` (`idMateria`);

--
-- Indici per le tabelle `preferiti`
--
ALTER TABLE `preferiti`
  ADD PRIMARY KEY (`idUtente`,`idPercorso`),
  ADD KEY `idPercorso` (`idPercorso`);

--
-- Indici per le tabelle `risposte`
--
ALTER TABLE `risposte`
  ADD PRIMARY KEY (`idRisposta`),
  ADD KEY `idAnnuncio` (`idAnnuncio`),
  ADD KEY `idUtente` (`idUtente`);

--
-- Indici per le tabelle `utenti`
--
ALTER TABLE `utenti`
  ADD PRIMARY KEY (`idUtente`);

--
-- AUTO_INCREMENT per le tabelle scaricate
--

--
-- AUTO_INCREMENT per la tabella `annunci`
--
ALTER TABLE `annunci`
  MODIFY `idAnnuncio` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT per la tabella `categorie`
--
ALTER TABLE `categorie`
  MODIFY `idCategoria` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT per la tabella `materie`
--
ALTER TABLE `materie`
  MODIFY `idMateria` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT per la tabella `messaggi_privati`
--
ALTER TABLE `messaggi_privati`
  MODIFY `idMessaggio` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT per la tabella `notifiche`
--
ALTER TABLE `notifiche`
  MODIFY `idNotifica` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT per la tabella `percorsi`
--
ALTER TABLE `percorsi`
  MODIFY `idPercorso` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT per la tabella `risposte`
--
ALTER TABLE `risposte`
  MODIFY `idRisposta` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT per la tabella `utenti`
--
ALTER TABLE `utenti`
  MODIFY `idUtente` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- Limiti per le tabelle scaricate
--

--
-- Limiti per la tabella `annunci`
--
ALTER TABLE `annunci`
  ADD CONSTRAINT `annunci_ibfk_1` FOREIGN KEY (`idUtente`) REFERENCES `utenti` (`idUtente`) ON DELETE CASCADE;

--
-- Limiti per la tabella `messaggi_privati`
--
ALTER TABLE `messaggi_privati`
  ADD CONSTRAINT `messaggi_privati_ibfk_1` FOREIGN KEY (`idMittente`) REFERENCES `utenti` (`idUtente`) ON DELETE CASCADE,
  ADD CONSTRAINT `messaggi_privati_ibfk_2` FOREIGN KEY (`idDestinatario`) REFERENCES `utenti` (`idUtente`) ON DELETE CASCADE;

--
-- Limiti per la tabella `notifiche`
--
ALTER TABLE `notifiche`
  ADD CONSTRAINT `notifiche_ibfk_1` FOREIGN KEY (`idUtente`) REFERENCES `utenti` (`idUtente`) ON DELETE CASCADE;

--
-- Limiti per la tabella `percorsi`
--
ALTER TABLE `percorsi`
  ADD CONSTRAINT `percorsi_ibfk_1` FOREIGN KEY (`idCategoria`) REFERENCES `categorie` (`idCategoria`);

--
-- Limiti per la tabella `percorsi_materie`
--
ALTER TABLE `percorsi_materie`
  ADD CONSTRAINT `fk_materia` FOREIGN KEY (`idMateria`) REFERENCES `materie` (`idMateria`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_percorso` FOREIGN KEY (`idPercorso`) REFERENCES `percorsi` (`idPercorso`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Limiti per la tabella `preferiti`
--
ALTER TABLE `preferiti`
  ADD CONSTRAINT `preferiti_ibfk_1` FOREIGN KEY (`idUtente`) REFERENCES `utenti` (`idUtente`) ON DELETE CASCADE,
  ADD CONSTRAINT `preferiti_ibfk_2` FOREIGN KEY (`idPercorso`) REFERENCES `percorsi` (`idPercorso`) ON DELETE CASCADE;

--
-- Limiti per la tabella `risposte`
--
ALTER TABLE `risposte`
  ADD CONSTRAINT `risposte_ibfk_1` FOREIGN KEY (`idAnnuncio`) REFERENCES `annunci` (`idAnnuncio`) ON DELETE CASCADE,
  ADD CONSTRAINT `risposte_ibfk_2` FOREIGN KEY (`idUtente`) REFERENCES `utenti` (`idUtente`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
