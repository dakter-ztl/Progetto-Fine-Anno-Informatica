-- phpMyAdmin SQL Dump
-- version 5.2.3
-- https://www.phpmyadmin.net/
--
-- Host: tb-be04-hclwebnx036.srv.teamblue-ops.net:3306
-- Creato il: Apr 21, 2026 alle 11:04
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

DELIMITER $$
--
-- Procedure
--
CREATE DEFINER=`pronv6_dakter`@`%` PROCEDURE `InserisciAnnuncio` (IN `p_idUtente` INT, IN `p_titolo` VARCHAR(150), IN `p_testo` TEXT, IN `p_inEvidenza` BOOLEAN)   BEGIN
    DECLARE v_count INT;
    
    SELECT COUNT(*) INTO v_count 
    FROM annunci 
    WHERE idUtente = p_idUtente;
    
    IF v_count < 4 THEN
        INSERT INTO annunci (idUtente, titolo, testo, inEvidenza)
        VALUES (p_idUtente, p_titolo, p_testo, p_inEvidenza);
    ELSE
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Errore: L\'utente ha già raggiunto il limite massimo di 4 annunci.';
    END IF;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Struttura della tabella `annunci`
--

CREATE TABLE `annunci` (
  `idAnnuncio` int NOT NULL,
  `idUtente` int NOT NULL,
  `titolo` varchar(150) NOT NULL,
  `testo` text,
  `dataPubblicazione` datetime DEFAULT CURRENT_TIMESTAMP,
  `stato` enum('aperto','chiuso') DEFAULT 'aperto',
  `inEvidenza` tinyint(1) DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dump dei dati per la tabella `annunci`
--

INSERT INTO `annunci` (`idAnnuncio`, `idUtente`, `titolo`, `testo`, `dataPubblicazione`, `stato`, `inEvidenza`) VALUES
(3, 1, 'Laurea in informatica', '123', '2026-03-20 11:28:44', 'aperto', 0);

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
(1, 'ITS Istituto Tecnico Superiore'),
(2, 'Universita'),
(3, 'Lavoro');

-- --------------------------------------------------------

--
-- Struttura della tabella `dettagliPercorsi`
--

CREATE TABLE `dettagliPercorsi` (
  `idDettaglio` int NOT NULL,
  `idPercorso` int NOT NULL,
  `descrizione` text NOT NULL,
  `indirizzo` varchar(100) NOT NULL,
  `orariAccoglienza` varchar(100) NOT NULL,
  `breakdownBudget` text NOT NULL,
  `nrTelefono` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dump dei dati per la tabella `dettagliPercorsi`
--

INSERT INTO `dettagliPercorsi` (`idDettaglio`, `idPercorso`, `descrizione`, `indirizzo`, `orariAccoglienza`, `breakdownBudget`, `nrTelefono`) VALUES
(1, 1, 'Il corso di Laurea in Ingegneria Informatica a Milano offre formazione accademica completa con lezioni frontali, laboratori pratici e tirocini presso aziende convenzionate. Al termine si acquisisce un titolo riconosciuto a livello europeo con accesso ai concorsi pubblici.', 'Via Festa del Perdono, 7', 'Lun-Ven 9:00-17:00', 'Tasse universitarie: ~€175/mese; Vitto e alloggio: ~€122/mese; Trasporti: ~€35/mese; Libri e materiali: ~€17/mese', 211000000),
(2, 2, 'Il corso di Laurea in Ingegneria Elettronica a Torino offre formazione accademica completa con lezioni frontali, laboratori pratici e tirocini presso aziende convenzionate. Al termine si acquisisce un titolo riconosciuto a livello europeo con accesso ai concorsi pubblici.', 'Via Po, 18', 'Lun-Ven 8:30-18:00', 'Tasse universitarie: ~€175/mese; Vitto e alloggio: ~€122/mese; Trasporti: ~€35/mese; Libri e materiali: ~€17/mese', 211001731),
(3, 3, 'Il corso di Laurea in Ingegneria Meccanica a Bologna offre formazione accademica completa con lezioni frontali, laboratori pratici e tirocini presso aziende convenzionate. Al termine si acquisisce un titolo riconosciuto a livello europeo con accesso ai concorsi pubblici.', 'Piazza Verdi, 5', 'Lun-Gio 9:00-16:00, Ven 9:00-13:00', 'Tasse universitarie: ~€175/mese; Vitto e alloggio: ~€122/mese; Trasporti: ~€35/mese; Libri e materiali: ~€17/mese', 211003462),
(4, 4, 'Il corso di Laurea in Ingegneria Elettrica a Napoli offre formazione accademica completa con lezioni frontali, laboratori pratici e tirocini presso aziende convenzionate. Al termine si acquisisce un titolo riconosciuto a livello europeo con accesso ai concorsi pubblici.', 'Piazza Cavour, 80', 'Lun-Ven 10:00-16:00', 'Tasse universitarie: ~€175/mese; Vitto e alloggio: ~€122/mese; Trasporti: ~€35/mese; Libri e materiali: ~€17/mese', 211005193),
(5, 5, 'Il corso di Laurea in Fisica a Roma offre formazione accademica completa con lezioni frontali, laboratori pratici e tirocini presso aziende convenzionate. Al termine si acquisisce un titolo riconosciuto a livello europeo con accesso ai concorsi pubblici.', 'Via Ostiense, 234', 'Mar-Ven 9:00-17:00, Sab 9:00-12:00', 'Tasse universitarie: ~€150/mese; Vitto e alloggio: ~€105/mese; Trasporti: ~€30/mese; Libri e materiali: ~€15/mese', 211006924),
(6, 6, 'Il corso di Laurea in Chimica a Milano offre formazione accademica completa con lezioni frontali, laboratori pratici e tirocini presso aziende convenzionate. Al termine si acquisisce un titolo riconosciuto a livello europeo con accesso ai concorsi pubblici.', 'Via Conservatorio, 7', 'Lun-Ven 8:00-19:00', 'Tasse universitarie: ~€150/mese; Vitto e alloggio: ~€105/mese; Trasporti: ~€30/mese; Libri e materiali: ~€15/mese', 211008655),
(7, 7, 'Il corso di Laurea in Biologia a Roma offre formazione accademica completa con lezioni frontali, laboratori pratici e tirocini presso aziende convenzionate. Al termine si acquisisce un titolo riconosciuto a livello europeo con accesso ai concorsi pubblici.', 'Via delle Tre Fontane, 40', 'Lun-Mer 9:00-17:00, Gio-Ven 9:00-14:00', 'Tasse universitarie: ~€150/mese; Vitto e alloggio: ~€105/mese; Trasporti: ~€30/mese; Libri e materiali: ~€15/mese', 211010386),
(8, 8, 'Il corso di Laurea in Matematica a Pisa offre formazione accademica completa con lezioni frontali, laboratori pratici e tirocini presso aziende convenzionate. Al termine si acquisisce un titolo riconosciuto a livello europeo con accesso ai concorsi pubblici.', 'Via Buonarroti, 2', 'Lun-Ven 9:00-17:00', 'Tasse universitarie: ~€150/mese; Vitto e alloggio: ~€105/mese; Trasporti: ~€30/mese; Libri e materiali: ~€15/mese', 211012117),
(9, 9, 'Il corso di Laurea in Economia e Commercio a Milano offre formazione accademica completa con lezioni frontali, laboratori pratici e tirocini presso aziende convenzionate. Al termine si acquisisce un titolo riconosciuto a livello europeo con accesso ai concorsi pubblici.', 'Piazza Leonardo da Vinci, 32', 'Lun-Ven 8:30-18:00', 'Tasse universitarie: ~€160/mese; Vitto e alloggio: ~€112/mese; Trasporti: ~€32/mese; Libri e materiali: ~€16/mese', 211013848),
(10, 10, 'Il corso di Laurea in Giurisprudenza a Roma offre formazione accademica completa con lezioni frontali, laboratori pratici e tirocini presso aziende convenzionate. Al termine si acquisisce un titolo riconosciuto a livello europeo con accesso ai concorsi pubblici.', 'Via Ostiense, 234', 'Lun-Gio 9:00-16:00, Ven 9:00-13:00', 'Tasse universitarie: ~€160/mese; Vitto e alloggio: ~€112/mese; Trasporti: ~€32/mese; Libri e materiali: ~€16/mese', 211015579),
(11, 11, 'Il corso di Laurea in Lettere a Firenze offre formazione accademica completa con lezioni frontali, laboratori pratici e tirocini presso aziende convenzionate. Al termine si acquisisce un titolo riconosciuto a livello europeo con accesso ai concorsi pubblici.', 'Via Laura, 48', 'Lun-Ven 10:00-16:00', 'Tasse universitarie: ~€140/mese; Vitto e alloggio: ~€98/mese; Trasporti: ~€28/mese; Libri e materiali: ~€14/mese', 211017310),
(12, 12, 'Il corso di Laurea in Filosofia a Bologna offre formazione accademica completa con lezioni frontali, laboratori pratici e tirocini presso aziende convenzionate. Al termine si acquisisce un titolo riconosciuto a livello europeo con accesso ai concorsi pubblici.', 'Via Belmeloro, 14', 'Mar-Ven 9:00-17:00, Sab 9:00-12:00', 'Tasse universitarie: ~€140/mese; Vitto e alloggio: ~€98/mese; Trasporti: ~€28/mese; Libri e materiali: ~€14/mese', 211019041),
(13, 13, 'Il corso di Laurea in Psicologia a Padova offre formazione accademica completa con lezioni frontali, laboratori pratici e tirocini presso aziende convenzionate. Al termine si acquisisce un titolo riconosciuto a livello europeo con accesso ai concorsi pubblici.', 'Via VIII Febbraio, 2', 'Lun-Ven 8:00-19:00', 'Tasse universitarie: ~€150/mese; Vitto e alloggio: ~€105/mese; Trasporti: ~€30/mese; Libri e materiali: ~€15/mese', 211020772),
(14, 14, 'Il corso di Laurea in Sociologia a Trento offre formazione accademica completa con lezioni frontali, laboratori pratici e tirocini presso aziende convenzionate. Al termine si acquisisce un titolo riconosciuto a livello europeo con accesso ai concorsi pubblici.', 'Via Verdi, 26', 'Lun-Mer 9:00-17:00, Gio-Ven 9:00-14:00', 'Tasse universitarie: ~€140/mese; Vitto e alloggio: ~€98/mese; Trasporti: ~€28/mese; Libri e materiali: ~€14/mese', 211022503),
(15, 15, 'Il corso di Laurea in Scienze della Formazione a Roma offre formazione accademica completa con lezioni frontali, laboratori pratici e tirocini presso aziende convenzionate. Al termine si acquisisce un titolo riconosciuto a livello europeo con accesso ai concorsi pubblici.', 'Via Ostiense, 234', 'Lun-Ven 9:00-17:00', 'Tasse universitarie: ~€140/mese; Vitto e alloggio: ~€98/mese; Trasporti: ~€28/mese; Libri e materiali: ~€14/mese', 211024234),
(16, 16, 'Il corso di Laurea in Architettura a Milano offre formazione accademica completa con lezioni frontali, laboratori pratici e tirocini presso aziende convenzionate. Al termine si acquisisce un titolo riconosciuto a livello europeo con accesso ai concorsi pubblici.', 'Piazza Leonardo da Vinci, 32', 'Lun-Ven 8:30-18:00', 'Tasse universitarie: ~€190/mese; Vitto e alloggio: ~€133/mese; Trasporti: ~€38/mese; Libri e materiali: ~€19/mese', 211025965),
(17, 17, 'Il corso di Laurea in Agraria a Bologna offre formazione accademica completa con lezioni frontali, laboratori pratici e tirocini presso aziende convenzionate. Al termine si acquisisce un titolo riconosciuto a livello europeo con accesso ai concorsi pubblici.', 'Via Belmeloro, 14', 'Lun-Gio 9:00-16:00, Ven 9:00-13:00', 'Tasse universitarie: ~€150/mese; Vitto e alloggio: ~€105/mese; Trasporti: ~€30/mese; Libri e materiali: ~€15/mese', 211027696),
(18, 18, 'Il corso di Laurea in Scienze Politiche a Roma offre formazione accademica completa con lezioni frontali, laboratori pratici e tirocini presso aziende convenzionate. Al termine si acquisisce un titolo riconosciuto a livello europeo con accesso ai concorsi pubblici.', 'Viale Regina Elena, 291', 'Lun-Ven 10:00-16:00', 'Tasse universitarie: ~€140/mese; Vitto e alloggio: ~€98/mese; Trasporti: ~€28/mese; Libri e materiali: ~€14/mese', 211029427),
(19, 19, 'Il corso di Laurea in Informatica a Milano offre formazione accademica completa con lezioni frontali, laboratori pratici e tirocini presso aziende convenzionate. Al termine si acquisisce un titolo riconosciuto a livello europeo con accesso ai concorsi pubblici.', 'Via Durando, 10', 'Mar-Ven 9:00-17:00, Sab 9:00-12:00', 'Tasse universitarie: ~€160/mese; Vitto e alloggio: ~€112/mese; Trasporti: ~€32/mese; Libri e materiali: ~€16/mese', 211031158),
(20, 20, 'Il corso di Laurea in Statistica a Padova offre formazione accademica completa con lezioni frontali, laboratori pratici e tirocini presso aziende convenzionate. Al termine si acquisisce un titolo riconosciuto a livello europeo con accesso ai concorsi pubblici.', 'Via Belzoni, 22', 'Lun-Ven 8:00-19:00', 'Tasse universitarie: ~€150/mese; Vitto e alloggio: ~€105/mese; Trasporti: ~€30/mese; Libri e materiali: ~€15/mese', 211032889),
(21, 21, 'Il corso di Laurea in Lingue e Letterature Straniere a Venezia offre formazione accademica completa con lezioni frontali, laboratori pratici e tirocini presso aziende convenzionate. Al termine si acquisisce un titolo riconosciuto a livello europeo con accesso ai concorsi pubblici.', 'Dorsoduro, 3861', 'Lun-Mer 9:00-17:00, Gio-Ven 9:00-14:00', 'Tasse universitarie: ~€140/mese; Vitto e alloggio: ~€98/mese; Trasporti: ~€28/mese; Libri e materiali: ~€14/mese', 211034620),
(22, 22, 'Il corso di Laurea in Scienze Naturali a Genova offre formazione accademica completa con lezioni frontali, laboratori pratici e tirocini presso aziende convenzionate. Al termine si acquisisce un titolo riconosciuto a livello europeo con accesso ai concorsi pubblici.', 'Piazzale Mazzini, 4', 'Lun-Ven 9:00-17:00', 'Tasse universitarie: ~€145/mese; Vitto e alloggio: ~€101/mese; Trasporti: ~€29/mese; Libri e materiali: ~€14/mese', 211036351),
(23, 23, 'Il corso di Laurea in Geologia a Napoli offre formazione accademica completa con lezioni frontali, laboratori pratici e tirocini presso aziende convenzionate. Al termine si acquisisce un titolo riconosciuto a livello europeo con accesso ai concorsi pubblici.', 'Via Tito Angelini, 22', 'Lun-Ven 8:30-18:00', 'Tasse universitarie: ~€145/mese; Vitto e alloggio: ~€101/mese; Trasporti: ~€29/mese; Libri e materiali: ~€14/mese', 211038082),
(24, 24, 'Il corso di Laurea in Biotecnologie a Milano offre formazione accademica completa con lezioni frontali, laboratori pratici e tirocini presso aziende convenzionate. Al termine si acquisisce un titolo riconosciuto a livello europeo con accesso ai concorsi pubblici.', 'Via Celoria, 2', 'Lun-Gio 9:00-16:00, Ven 9:00-13:00', 'Tasse universitarie: ~€160/mese; Vitto e alloggio: ~€112/mese; Trasporti: ~€32/mese; Libri e materiali: ~€16/mese', 211039813),
(25, 25, 'Il corso di Laurea in Medicina e Chirurgia a Roma offre formazione accademica completa con lezioni frontali, laboratori pratici e tirocini presso aziende convenzionate. Al termine si acquisisce un titolo riconosciuto a livello europeo con accesso ai concorsi pubblici.', 'Via Ostiense, 234', 'Lun-Ven 10:00-16:00', 'Tasse universitarie: ~€250/mese; Vitto e alloggio: ~€175/mese; Trasporti: ~€50/mese; Libri e materiali: ~€25/mese', 211041544),
(26, 26, 'Il corso di Laurea in Economia Aziendale a Bocconi offre formazione accademica completa con lezioni frontali, laboratori pratici e tirocini presso aziende convenzionate. Al termine si acquisisce un titolo riconosciuto a livello europeo con accesso ai concorsi pubblici.', 'Via Roberto Sarfatti, 25, Milano', 'Mar-Ven 9:00-17:00, Sab 9:00-12:00', 'Tasse universitarie: ~€160/mese; Vitto e alloggio: ~€112/mese; Trasporti: ~€32/mese; Libri e materiali: ~€16/mese', 211043275),
(27, 27, 'Il corso di Laurea in Comunicazione a Milano offre formazione accademica completa con lezioni frontali, laboratori pratici e tirocini presso aziende convenzionate. Al termine si acquisisce un titolo riconosciuto a livello europeo con accesso ai concorsi pubblici.', 'Via Conservatorio, 7', 'Lun-Ven 8:00-19:00', 'Tasse universitarie: ~€145/mese; Vitto e alloggio: ~€101/mese; Trasporti: ~€29/mese; Libri e materiali: ~€14/mese', 211045006),
(28, 28, 'Il corso di Laurea in Design a Milano offre formazione accademica completa con lezioni frontali, laboratori pratici e tirocini presso aziende convenzionate. Al termine si acquisisce un titolo riconosciuto a livello europeo con accesso ai concorsi pubblici.', 'Via Mancinelli, 7', 'Lun-Mer 9:00-17:00, Gio-Ven 9:00-14:00', 'Tasse universitarie: ~€200/mese; Vitto e alloggio: ~€140/mese; Trasporti: ~€40/mese; Libri e materiali: ~€20/mese', 211046737),
(29, 29, 'Il corso di Laurea in Conservazione dei Beni Culturali a Firenze offre formazione accademica completa con lezioni frontali, laboratori pratici e tirocini presso aziende convenzionate. Al termine si acquisisce un titolo riconosciuto a livello europeo con accesso ai concorsi pubblici.', 'Piazza San Marco, 4', 'Lun-Ven 9:00-17:00', 'Tasse universitarie: ~€145/mese; Vitto e alloggio: ~€101/mese; Trasporti: ~€29/mese; Libri e materiali: ~€14/mese', 211048468),
(30, 30, 'Il corso di Laurea in Musicologia a Bologna offre formazione accademica completa con lezioni frontali, laboratori pratici e tirocini presso aziende convenzionate. Al termine si acquisisce un titolo riconosciuto a livello europeo con accesso ai concorsi pubblici.', 'Via Marsala, 26', 'Lun-Ven 8:30-18:00', 'Tasse universitarie: ~€140/mese; Vitto e alloggio: ~€98/mese; Trasporti: ~€28/mese; Libri e materiali: ~€14/mese', 211050199),
(31, 31, 'Percorso biennale post-diploma con forte orientamento pratico, sviluppato in collaborazione con imprese del settore a Milano. Include lezioni in aula, laboratori e almeno 800 ore di tirocinio. Il diploma ITS e riconosciuto come titolo di V livello EQF.', 'Via Celoria, 2', 'Lun-Gio 9:00-16:00, Ven 9:00-13:00', 'Quota di iscrizione: ~€120/mese; Materiali didattici: ~€50/mese; Trasporti: ~€30/mese', 211051930),
(32, 32, 'Percorso biennale post-diploma con forte orientamento pratico, sviluppato in collaborazione con imprese del settore a Torino. Include lezioni in aula, laboratori e almeno 800 ore di tirocinio. Il diploma ITS e riconosciuto come titolo di V livello EQF.', 'Via Po, 18', 'Lun-Ven 10:00-16:00', 'Quota di iscrizione: ~€120/mese; Materiali didattici: ~€50/mese; Trasporti: ~€30/mese', 211053661),
(33, 33, 'Percorso biennale post-diploma con forte orientamento pratico, sviluppato in collaborazione con imprese del settore a Bologna. Include lezioni in aula, laboratori e almeno 800 ore di tirocinio. Il diploma ITS e riconosciuto come titolo di V livello EQF.', 'Piazza Verdi, 5', 'Mar-Ven 9:00-17:00, Sab 9:00-12:00', 'Quota di iscrizione: ~€108/mese; Materiali didattici: ~€45/mese; Trasporti: ~€27/mese', 211055392),
(34, 34, 'Percorso biennale post-diploma con forte orientamento pratico, sviluppato in collaborazione con imprese del settore a Roma. Include lezioni in aula, laboratori e almeno 800 ore di tirocinio. Il diploma ITS e riconosciuto come titolo di V livello EQF.', 'Corso Vittorio Emanuele II, 244', 'Lun-Ven 8:00-19:00', 'Quota di iscrizione: ~€114/mese; Materiali didattici: ~€47/mese; Trasporti: ~€28/mese', 211057123),
(35, 35, 'Percorso biennale post-diploma con forte orientamento pratico, sviluppato in collaborazione con imprese del settore a Firenze. Include lezioni in aula, laboratori e almeno 800 ore di tirocinio. Il diploma ITS e riconosciuto come titolo di V livello EQF.', 'Via Laura, 48', 'Lun-Mer 9:00-17:00, Gio-Ven 9:00-14:00', 'Quota di iscrizione: ~€108/mese; Materiali didattici: ~€45/mese; Trasporti: ~€27/mese', 211058854),
(36, 36, 'Percorso biennale post-diploma con forte orientamento pratico, sviluppato in collaborazione con imprese del settore a Verona. Include lezioni in aula, laboratori e almeno 800 ore di tirocinio. Il diploma ITS e riconosciuto come titolo di V livello EQF.', 'Viale dell\'Universita, 4', 'Lun-Ven 9:00-17:00', 'Quota di iscrizione: ~€102/mese; Materiali didattici: ~€42/mese; Trasporti: ~€25/mese', 211060585),
(37, 37, 'Percorso biennale post-diploma con forte orientamento pratico, sviluppato in collaborazione con imprese del settore a Venezia. Include lezioni in aula, laboratori e almeno 800 ore di tirocinio. Il diploma ITS e riconosciuto come titolo di V livello EQF.', 'Dorsoduro, 3861', 'Lun-Ven 8:30-18:00', 'Quota di iscrizione: ~€102/mese; Materiali didattici: ~€42/mese; Trasporti: ~€25/mese', 211062316),
(38, 38, 'Percorso biennale post-diploma con forte orientamento pratico, sviluppato in collaborazione con imprese del settore a Milano. Include lezioni in aula, laboratori e almeno 800 ore di tirocinio. Il diploma ITS e riconosciuto come titolo di V livello EQF.', 'Via Celoria, 2', 'Lun-Gio 9:00-16:00, Ven 9:00-13:00', 'Quota di iscrizione: ~€108/mese; Materiali didattici: ~€45/mese; Trasporti: ~€27/mese', 211064047),
(39, 39, 'Percorso biennale post-diploma con forte orientamento pratico, sviluppato in collaborazione con imprese del settore a Milano. Include lezioni in aula, laboratori e almeno 800 ore di tirocinio. Il diploma ITS e riconosciuto come titolo di V livello EQF.', 'Corso Italia, 1', 'Lun-Ven 10:00-16:00', 'Quota di iscrizione: ~€114/mese; Materiali didattici: ~€47/mese; Trasporti: ~€28/mese', 211065778),
(40, 40, 'Percorso biennale post-diploma con forte orientamento pratico, sviluppato in collaborazione con imprese del settore a Genova. Include lezioni in aula, laboratori e almeno 800 ore di tirocinio. Il diploma ITS e riconosciuto come titolo di V livello EQF.', 'Piazzale Mazzini, 4', 'Mar-Ven 9:00-17:00, Sab 9:00-12:00', 'Quota di iscrizione: ~€114/mese; Materiali didattici: ~€47/mese; Trasporti: ~€28/mese', 211067509),
(41, 41, 'Percorso biennale post-diploma con forte orientamento pratico, sviluppato in collaborazione con imprese del settore a Torino. Include lezioni in aula, laboratori e almeno 800 ore di tirocinio. Il diploma ITS e riconosciuto come titolo di V livello EQF.', 'Corso Duca degli Abruzzi, 24', 'Lun-Ven 8:00-19:00', 'Quota di iscrizione: ~€120/mese; Materiali didattici: ~€50/mese; Trasporti: ~€30/mese', 211069240),
(42, 42, 'Percorso biennale post-diploma con forte orientamento pratico, sviluppato in collaborazione con imprese del settore a Roma. Include lezioni in aula, laboratori e almeno 800 ore di tirocinio. Il diploma ITS e riconosciuto come titolo di V livello EQF.', 'Via delle Tre Fontane, 40', 'Lun-Mer 9:00-17:00, Gio-Ven 9:00-14:00', 'Quota di iscrizione: ~€120/mese; Materiali didattici: ~€50/mese; Trasporti: ~€30/mese', 211070971),
(43, 43, 'Percorso biennale post-diploma con forte orientamento pratico, sviluppato in collaborazione con imprese del settore a Milano. Include lezioni in aula, laboratori e almeno 800 ore di tirocinio. Il diploma ITS e riconosciuto come titolo di V livello EQF.', 'Via Festa del Perdono, 7', 'Lun-Ven 9:00-17:00', 'Quota di iscrizione: ~€120/mese; Materiali didattici: ~€50/mese; Trasporti: ~€30/mese', 211072702),
(44, 44, 'Percorso biennale post-diploma con forte orientamento pratico, sviluppato in collaborazione con imprese del settore a Bologna. Include lezioni in aula, laboratori e almeno 800 ore di tirocinio. Il diploma ITS e riconosciuto come titolo di V livello EQF.', 'Via dell\'Universita, 50', 'Lun-Ven 8:30-18:00', 'Quota di iscrizione: ~€108/mese; Materiali didattici: ~€45/mese; Trasporti: ~€27/mese', 211074433),
(45, 45, 'Percorso biennale post-diploma con forte orientamento pratico, sviluppato in collaborazione con imprese del settore a Roma. Include lezioni in aula, laboratori e almeno 800 ore di tirocinio. Il diploma ITS e riconosciuto come titolo di V livello EQF.', 'Via Ostiense, 234', 'Lun-Gio 9:00-16:00, Ven 9:00-13:00', 'Quota di iscrizione: ~€114/mese; Materiali didattici: ~€47/mese; Trasporti: ~€28/mese', 211076164),
(46, 46, 'Percorso professionale per inserirsi nel mondo del lavoro nel settore di riferimento a Milano. Moduli teorico-pratici con docenti provenienti dal settore, stage aziendale incluso e supporto al collocamento al termine del corso.', 'Corso Italia, 1', 'Lun-Ven 10:00-16:00', 'Percorso finanziato: nessun costo di iscrizione; Eventuali spese di trasporto a carico del corsista', 211077895),
(47, 47, 'Percorso professionale per inserirsi nel mondo del lavoro nel settore di riferimento a Torino. Moduli teorico-pratici con docenti provenienti dal settore, stage aziendale incluso e supporto al collocamento al termine del corso.', 'Via Po, 18', 'Mar-Ven 9:00-17:00, Sab 9:00-12:00', 'Percorso finanziato: nessun costo di iscrizione; Eventuali spese di trasporto a carico del corsista', 211079626),
(48, 48, 'Percorso professionale per inserirsi nel mondo del lavoro nel settore di riferimento a Brescia. Moduli teorico-pratici con docenti provenienti dal settore, stage aziendale incluso e supporto al collocamento al termine del corso.', 'Piazza Tebaldo Brusato, 3', 'Lun-Ven 8:00-19:00', 'Percorso finanziato: nessun costo di iscrizione; Eventuali spese di trasporto a carico del corsista', 211081357),
(49, 49, 'Percorso professionale per inserirsi nel mondo del lavoro nel settore di riferimento a Milano. Moduli teorico-pratici con docenti provenienti dal settore, stage aziendale incluso e supporto al collocamento al termine del corso.', 'Via Mancinelli, 7', 'Lun-Mer 9:00-17:00, Gio-Ven 9:00-14:00', 'Percorso finanziato: nessun costo di iscrizione; Eventuali spese di trasporto a carico del corsista', 211083088),
(50, 50, 'Percorso professionale per inserirsi nel mondo del lavoro nel settore di riferimento a Roma. Moduli teorico-pratici con docenti provenienti dal settore, stage aziendale incluso e supporto al collocamento al termine del corso.', 'Via Ostiense, 234', 'Lun-Ven 9:00-17:00', 'Percorso finanziato: nessun costo di iscrizione; Eventuali spese di trasporto a carico del corsista', 211084819),
(51, 51, 'Percorso professionale per inserirsi nel mondo del lavoro nel settore di riferimento a Venezia. Moduli teorico-pratici con docenti provenienti dal settore, stage aziendale incluso e supporto al collocamento al termine del corso.', 'Dorsoduro, 3861', 'Lun-Ven 8:30-18:00', 'Percorso finanziato: nessun costo di iscrizione; Eventuali spese di trasporto a carico del corsista', 211086550),
(52, 52, 'Percorso professionale per inserirsi nel mondo del lavoro nel settore di riferimento a Milano. Moduli teorico-pratici con docenti provenienti dal settore, stage aziendale incluso e supporto al collocamento al termine del corso.', 'Via Celoria, 2', 'Lun-Gio 9:00-16:00, Ven 9:00-13:00', 'Percorso finanziato: nessun costo di iscrizione; Eventuali spese di trasporto a carico del corsista', 211088281),
(53, 53, 'Percorso professionale per inserirsi nel mondo del lavoro nel settore di riferimento a Bari. Moduli teorico-pratici con docenti provenienti dal settore, stage aziendale incluso e supporto al collocamento al termine del corso.', 'Via Amendola, 165', 'Lun-Ven 10:00-16:00', 'Percorso finanziato: nessun costo di iscrizione; Eventuali spese di trasporto a carico del corsista', 211090012),
(54, 54, 'Percorso professionale per inserirsi nel mondo del lavoro nel settore di riferimento a Roma. Moduli teorico-pratici con docenti provenienti dal settore, stage aziendale incluso e supporto al collocamento al termine del corso.', 'Corso Vittorio Emanuele II, 244', 'Mar-Ven 9:00-17:00, Sab 9:00-12:00', 'Percorso finanziato: nessun costo di iscrizione; Eventuali spese di trasporto a carico del corsista', 211091743),
(55, 55, 'Percorso professionale per inserirsi nel mondo del lavoro nel settore di riferimento a Milano. Moduli teorico-pratici con docenti provenienti dal settore, stage aziendale incluso e supporto al collocamento al termine del corso.', 'Via Conservatorio, 7', 'Lun-Ven 8:00-19:00', 'Percorso finanziato: nessun costo di iscrizione; Eventuali spese di trasporto a carico del corsista', 211093474),
(56, 56, 'Percorso professionale per inserirsi nel mondo del lavoro nel settore di riferimento a Milano. Moduli teorico-pratici con docenti provenienti dal settore, stage aziendale incluso e supporto al collocamento al termine del corso.', 'Via Mancinelli, 7', 'Lun-Mer 9:00-17:00, Gio-Ven 9:00-14:00', 'Percorso finanziato: nessun costo di iscrizione; Eventuali spese di trasporto a carico del corsista', 211095205),
(57, 57, 'Percorso professionale per inserirsi nel mondo del lavoro nel settore di riferimento a Roma. Moduli teorico-pratici con docenti provenienti dal settore, stage aziendale incluso e supporto al collocamento al termine del corso.', 'Via delle Tre Fontane, 40', 'Lun-Ven 9:00-17:00', 'Percorso finanziato: nessun costo di iscrizione; Eventuali spese di trasporto a carico del corsista', 211096936),
(58, 58, 'Percorso professionale per inserirsi nel mondo del lavoro nel settore di riferimento a Milano. Moduli teorico-pratici con docenti provenienti dal settore, stage aziendale incluso e supporto al collocamento al termine del corso.', 'Piazza Leonardo da Vinci, 32', 'Lun-Ven 8:30-18:00', 'Percorso finanziato: nessun costo di iscrizione; Eventuali spese di trasporto a carico del corsista', 211098667),
(59, 59, 'Percorso professionale per inserirsi nel mondo del lavoro nel settore di riferimento a Napoli. Moduli teorico-pratici con docenti provenienti dal settore, stage aziendale incluso e supporto al collocamento al termine del corso.', 'Via Tito Angelini, 22', 'Lun-Gio 9:00-16:00, Ven 9:00-13:00', 'Percorso finanziato: nessun costo di iscrizione; Eventuali spese di trasporto a carico del corsista', 211100398),
(60, 60, 'Percorso professionale per inserirsi nel mondo del lavoro nel settore di riferimento a Roma. Moduli teorico-pratici con docenti provenienti dal settore, stage aziendale incluso e supporto al collocamento al termine del corso.', 'Via Ostiense, 234', 'Lun-Ven 10:00-16:00', 'Percorso finanziato: nessun costo di iscrizione; Eventuali spese di trasporto a carico del corsista', 211102129),
(61, 61, 'Percorso professionale per inserirsi nel mondo del lavoro nel settore di riferimento a Genova. Moduli teorico-pratici con docenti provenienti dal settore, stage aziendale incluso e supporto al collocamento al termine del corso.', 'Via Balbi, 5', 'Mar-Ven 9:00-17:00, Sab 9:00-12:00', 'Percorso finanziato: nessun costo di iscrizione; Eventuali spese di trasporto a carico del corsista', 211103860),
(62, 62, 'Percorso professionale per inserirsi nel mondo del lavoro nel settore di riferimento a Roma. Moduli teorico-pratici con docenti provenienti dal settore, stage aziendale incluso e supporto al collocamento al termine del corso.', 'Via delle Tre Fontane, 40', 'Lun-Ven 8:00-19:00', 'Percorso finanziato: nessun costo di iscrizione; Eventuali spese di trasporto a carico del corsista', 211105591),
(63, 63, 'Percorso professionale per inserirsi nel mondo del lavoro nel settore di riferimento a Verona. Moduli teorico-pratici con docenti provenienti dal settore, stage aziendale incluso e supporto al collocamento al termine del corso.', 'Via dell\'Artigliere, 11', 'Lun-Mer 9:00-17:00, Gio-Ven 9:00-14:00', 'Percorso finanziato: nessun costo di iscrizione; Eventuali spese di trasporto a carico del corsista', 211107322),
(64, 64, 'Percorso professionale per inserirsi nel mondo del lavoro nel settore di riferimento a Milano. Moduli teorico-pratici con docenti provenienti dal settore, stage aziendale incluso e supporto al collocamento al termine del corso.', 'Via Festa del Perdono, 7', 'Lun-Ven 9:00-17:00', 'Percorso finanziato: nessun costo di iscrizione; Eventuali spese di trasporto a carico del corsista', 211109053),
(65, 65, 'Percorso professionale per inserirsi nel mondo del lavoro nel settore di riferimento a Milano. Moduli teorico-pratici con docenti provenienti dal settore, stage aziendale incluso e supporto al collocamento al termine del corso.', 'Piazza Leonardo da Vinci, 32', 'Lun-Ven 8:30-18:00', 'Percorso finanziato: nessun costo di iscrizione; Eventuali spese di trasporto a carico del corsista', 211110784),
(66, 66, 'Percorso professionale per inserirsi nel mondo del lavoro nel settore di riferimento a Roma. Moduli teorico-pratici con docenti provenienti dal settore, stage aziendale incluso e supporto al collocamento al termine del corso.', 'Piazzale Aldo Moro, 5', 'Lun-Gio 9:00-16:00, Ven 9:00-13:00', 'Percorso finanziato: nessun costo di iscrizione; Eventuali spese di trasporto a carico del corsista', 211112515),
(67, 67, 'Percorso professionale per inserirsi nel mondo del lavoro nel settore di riferimento a Torino. Moduli teorico-pratici con docenti provenienti dal settore, stage aziendale incluso e supporto al collocamento al termine del corso.', 'Via Po, 18', 'Lun-Ven 10:00-16:00', 'Percorso finanziato: nessun costo di iscrizione; Eventuali spese di trasporto a carico del corsista', 211114246),
(68, 68, 'Percorso professionale per inserirsi nel mondo del lavoro nel settore di riferimento a Milano. Moduli teorico-pratici con docenti provenienti dal settore, stage aziendale incluso e supporto al collocamento al termine del corso.', 'Via Durando, 10', 'Mar-Ven 9:00-17:00, Sab 9:00-12:00', 'Percorso finanziato: nessun costo di iscrizione; Eventuali spese di trasporto a carico del corsista', 211115977),
(69, 69, 'Percorso professionale per inserirsi nel mondo del lavoro nel settore di riferimento a Milano. Moduli teorico-pratici con docenti provenienti dal settore, stage aziendale incluso e supporto al collocamento al termine del corso.', 'Via Conservatorio, 7', 'Lun-Ven 8:00-19:00', 'Percorso finanziato: nessun costo di iscrizione; Eventuali spese di trasporto a carico del corsista', 211117708),
(70, 70, 'Percorso professionale per inserirsi nel mondo del lavoro nel settore di riferimento a Bologna. Moduli teorico-pratici con docenti provenienti dal settore, stage aziendale incluso e supporto al collocamento al termine del corso.', 'Via Marsala, 26', 'Lun-Mer 9:00-17:00, Gio-Ven 9:00-14:00', 'Percorso finanziato: nessun costo di iscrizione; Eventuali spese di trasporto a carico del corsista', 211119439),
(71, 71, 'Il corso di Laurea in Ingegneria Civile a Milano offre formazione accademica completa con lezioni frontali, laboratori pratici e tirocini presso aziende convenzionate. Al termine si acquisisce un titolo riconosciuto a livello europeo con accesso ai concorsi pubblici.', 'Via Festa del Perdono, 7', 'Lun-Ven 9:00-17:00', 'Tasse universitarie: ~€175/mese; Vitto e alloggio: ~€122/mese; Trasporti: ~€35/mese; Libri e materiali: ~€17/mese', 211121170),
(72, 72, 'Il corso di Laurea in Ingegneria Aerospaziale a Roma offre formazione accademica completa con lezioni frontali, laboratori pratici e tirocini presso aziende convenzionate. Al termine si acquisisce un titolo riconosciuto a livello europeo con accesso ai concorsi pubblici.', 'Via delle Tre Fontane, 40', 'Lun-Ven 8:30-18:00', 'Tasse universitarie: ~€190/mese; Vitto e alloggio: ~€133/mese; Trasporti: ~€38/mese; Libri e materiali: ~€19/mese', 211122901),
(73, 73, 'Il corso di Laurea in Ingegneria Navale a Genova offre formazione accademica completa con lezioni frontali, laboratori pratici e tirocini presso aziende convenzionate. Al termine si acquisisce un titolo riconosciuto a livello europeo con accesso ai concorsi pubblici.', 'Via Balbi, 5', 'Lun-Gio 9:00-16:00, Ven 9:00-13:00', 'Tasse universitarie: ~€175/mese; Vitto e alloggio: ~€122/mese; Trasporti: ~€35/mese; Libri e materiali: ~€17/mese', 211124632),
(74, 74, 'Il corso di Laurea in Ingegneria delle Telecomunicazioni a Torino offre formazione accademica completa con lezioni frontali, laboratori pratici e tirocini presso aziende convenzionate. Al termine si acquisisce un titolo riconosciuto a livello europeo con accesso ai concorsi pubblici.', 'Via Verdi, 8', 'Lun-Ven 10:00-16:00', 'Tasse universitarie: ~€175/mese; Vitto e alloggio: ~€122/mese; Trasporti: ~€35/mese; Libri e materiali: ~€17/mese', 211126363),
(75, 75, 'Il corso di Laurea in Scienze Agrarie a Bologna offre formazione accademica completa con lezioni frontali, laboratori pratici e tirocini presso aziende convenzionate. Al termine si acquisisce un titolo riconosciuto a livello europeo con accesso ai concorsi pubblici.', 'Via Marsala, 26', 'Mar-Ven 9:00-17:00, Sab 9:00-12:00', 'Tasse universitarie: ~€145/mese; Vitto e alloggio: ~€101/mese; Trasporti: ~€29/mese; Libri e materiali: ~€14/mese', 211128094),
(76, 76, 'Il corso di Laurea in Medicina Veterinaria a Torino offre formazione accademica completa con lezioni frontali, laboratori pratici e tirocini presso aziende convenzionate. Al termine si acquisisce un titolo riconosciuto a livello europeo con accesso ai concorsi pubblici.', 'Corso Duca degli Abruzzi, 24', 'Lun-Ven 8:00-19:00', 'Tasse universitarie: ~€200/mese; Vitto e alloggio: ~€140/mese; Trasporti: ~€40/mese; Libri e materiali: ~€20/mese', 211129825),
(77, 77, 'Il corso di Laurea in Farmacia a Napoli offre formazione accademica completa con lezioni frontali, laboratori pratici e tirocini presso aziende convenzionate. Al termine si acquisisce un titolo riconosciuto a livello europeo con accesso ai concorsi pubblici.', 'Via Mezzocannone, 16', 'Lun-Mer 9:00-17:00, Gio-Ven 9:00-14:00', 'Tasse universitarie: ~€190/mese; Vitto e alloggio: ~€133/mese; Trasporti: ~€38/mese; Libri e materiali: ~€19/mese', 211131556),
(78, 78, 'Il corso di Laurea in Scienze Motorie a Roma offre formazione accademica completa con lezioni frontali, laboratori pratici e tirocini presso aziende convenzionate. Al termine si acquisisce un titolo riconosciuto a livello europeo con accesso ai concorsi pubblici.', 'Viale Regina Elena, 291', 'Lun-Ven 9:00-17:00', 'Tasse universitarie: ~€140/mese; Vitto e alloggio: ~€98/mese; Trasporti: ~€28/mese; Libri e materiali: ~€14/mese', 211133287),
(79, 79, 'Il corso di Laurea in Economia del Turismo a Venezia offre formazione accademica completa con lezioni frontali, laboratori pratici e tirocini presso aziende convenzionate. Al termine si acquisisce un titolo riconosciuto a livello europeo con accesso ai concorsi pubblici.', 'Dorsoduro, 3861', 'Lun-Ven 8:30-18:00', 'Tasse universitarie: ~€150/mese; Vitto e alloggio: ~€105/mese; Trasporti: ~€30/mese; Libri e materiali: ~€15/mese', 211135018),
(80, 80, 'Il corso di Laurea in Ingegneria Gestionale a Milano offre formazione accademica completa con lezioni frontali, laboratori pratici e tirocini presso aziende convenzionate. Al termine si acquisisce un titolo riconosciuto a livello europeo con accesso ai concorsi pubblici.', 'Via Celoria, 2', 'Lun-Gio 9:00-16:00, Ven 9:00-13:00', 'Tasse universitarie: ~€175/mese; Vitto e alloggio: ~€122/mese; Trasporti: ~€35/mese; Libri e materiali: ~€17/mese', 211136749),
(81, 81, 'Il corso di Laurea in Scienze dell\'Educazione a Roma offre formazione accademica completa con lezioni frontali, laboratori pratici e tirocini presso aziende convenzionate. Al termine si acquisisce un titolo riconosciuto a livello europeo con accesso ai concorsi pubblici.', 'Piazzale Aldo Moro, 5', 'Lun-Ven 10:00-16:00', 'Tasse universitarie: ~€135/mese; Vitto e alloggio: ~€94/mese; Trasporti: ~€27/mese; Libri e materiali: ~€13/mese', 211138480),
(82, 82, 'Il corso di Laurea in Astronomia a Bologna offre formazione accademica completa con lezioni frontali, laboratori pratici e tirocini presso aziende convenzionate. Al termine si acquisisce un titolo riconosciuto a livello europeo con accesso ai concorsi pubblici.', 'Via Belmeloro, 14', 'Mar-Ven 9:00-17:00, Sab 9:00-12:00', 'Tasse universitarie: ~€150/mese; Vitto e alloggio: ~€105/mese; Trasporti: ~€30/mese; Libri e materiali: ~€15/mese', 211140211),
(83, 83, 'Il corso di Laurea in Ingegneria Biomedica a Milano offre formazione accademica completa con lezioni frontali, laboratori pratici e tirocini presso aziende convenzionate. Al termine si acquisisce un titolo riconosciuto a livello europeo con accesso ai concorsi pubblici.', 'Via Conservatorio, 7', 'Lun-Ven 8:00-19:00', 'Tasse universitarie: ~€185/mese; Vitto e alloggio: ~€129/mese; Trasporti: ~€37/mese; Libri e materiali: ~€18/mese', 211141942),
(84, 84, 'Il corso di Laurea in Scienze Ambientali a Venezia offre formazione accademica completa con lezioni frontali, laboratori pratici e tirocini presso aziende convenzionate. Al termine si acquisisce un titolo riconosciuto a livello europeo con accesso ai concorsi pubblici.', 'Cannaregio 873', 'Lun-Mer 9:00-17:00, Gio-Ven 9:00-14:00', 'Tasse universitarie: ~€145/mese; Vitto e alloggio: ~€101/mese; Trasporti: ~€29/mese; Libri e materiali: ~€14/mese', 211143673),
(85, 85, 'Il corso di Laurea in Relazioni Internazionali a Roma offre formazione accademica completa con lezioni frontali, laboratori pratici e tirocini presso aziende convenzionate. Al termine si acquisisce un titolo riconosciuto a livello europeo con accesso ai concorsi pubblici.', 'Via Ostiense, 234', 'Lun-Ven 9:00-17:00', 'Tasse universitarie: ~€150/mese; Vitto e alloggio: ~€105/mese; Trasporti: ~€30/mese; Libri e materiali: ~€15/mese', 211145404),
(86, 86, 'Il corso di Laurea in Ingegneria Chimica a Milano offre formazione accademica completa con lezioni frontali, laboratori pratici e tirocini presso aziende convenzionate. Al termine si acquisisce un titolo riconosciuto a livello europeo con accesso ai concorsi pubblici.', 'Piazza Leonardo da Vinci, 32', 'Lun-Ven 8:30-18:00', 'Tasse universitarie: ~€180/mese; Vitto e alloggio: ~€125/mese; Trasporti: ~€36/mese; Libri e materiali: ~€18/mese', 211147135),
(87, 87, 'Il corso di Laurea in Ingegneria dei Materiali a Torino offre formazione accademica completa con lezioni frontali, laboratori pratici e tirocini presso aziende convenzionate. Al termine si acquisisce un titolo riconosciuto a livello europeo con accesso ai concorsi pubblici.', 'Via Po, 18', 'Lun-Gio 9:00-16:00, Ven 9:00-13:00', 'Tasse universitarie: ~€175/mese; Vitto e alloggio: ~€122/mese; Trasporti: ~€35/mese; Libri e materiali: ~€17/mese', 211148866),
(88, 88, 'Il corso di Laurea in Storia a Firenze offre formazione accademica completa con lezioni frontali, laboratori pratici e tirocini presso aziende convenzionate. Al termine si acquisisce un titolo riconosciuto a livello europeo con accesso ai concorsi pubblici.', 'Piazza delle Belle Arti, 1', 'Lun-Ven 10:00-16:00', 'Tasse universitarie: ~€135/mese; Vitto e alloggio: ~€94/mese; Trasporti: ~€27/mese; Libri e materiali: ~€13/mese', 211150597),
(89, 89, 'Il corso di Laurea in Arte e Spettacolo a Roma offre formazione accademica completa con lezioni frontali, laboratori pratici e tirocini presso aziende convenzionate. Al termine si acquisisce un titolo riconosciuto a livello europeo con accesso ai concorsi pubblici.', 'Corso Vittorio Emanuele II, 244', 'Mar-Ven 9:00-17:00, Sab 9:00-12:00', 'Tasse universitarie: ~€145/mese; Vitto e alloggio: ~€101/mese; Trasporti: ~€29/mese; Libri e materiali: ~€14/mese', 211152328),
(90, 90, 'Il corso di Laurea in Scienze Infermieristiche a Milano offre formazione accademica completa con lezioni frontali, laboratori pratici e tirocini presso aziende convenzionate. Al termine si acquisisce un titolo riconosciuto a livello europeo con accesso ai concorsi pubblici.', 'Via Conservatorio, 7', 'Lun-Ven 8:00-19:00', 'Tasse universitarie: ~€150/mese; Vitto e alloggio: ~€105/mese; Trasporti: ~€30/mese; Libri e materiali: ~€15/mese', 211154059),
(91, 91, 'Percorso biennale post-diploma con forte orientamento pratico, sviluppato in collaborazione con imprese del settore a Milano. Include lezioni in aula, laboratori e almeno 800 ore di tirocinio. Il diploma ITS e riconosciuto come titolo di V livello EQF.', 'Via Mancinelli, 7', 'Lun-Mer 9:00-17:00, Gio-Ven 9:00-14:00', 'Quota di iscrizione: ~€114/mese; Materiali didattici: ~€47/mese; Trasporti: ~€28/mese', 211155790),
(92, 92, 'Percorso biennale post-diploma con forte orientamento pratico, sviluppato in collaborazione con imprese del settore a Bari. Include lezioni in aula, laboratori e almeno 800 ore di tirocinio. Il diploma ITS e riconosciuto come titolo di V livello EQF.', 'Piazza Umberto I, 1', 'Lun-Ven 9:00-17:00', 'Quota di iscrizione: ~€114/mese; Materiali didattici: ~€47/mese; Trasporti: ~€28/mese', 211157521),
(93, 93, 'Percorso biennale post-diploma con forte orientamento pratico, sviluppato in collaborazione con imprese del settore a Bologna. Include lezioni in aula, laboratori e almeno 800 ore di tirocinio. Il diploma ITS e riconosciuto come titolo di V livello EQF.', 'Piazza Verdi, 5', 'Lun-Ven 8:30-18:00', 'Quota di iscrizione: ~€108/mese; Materiali didattici: ~€45/mese; Trasporti: ~€27/mese', 211159252),
(94, 94, 'Percorso biennale post-diploma con forte orientamento pratico, sviluppato in collaborazione con imprese del settore a Parma. Include lezioni in aula, laboratori e almeno 800 ore di tirocinio. Il diploma ITS e riconosciuto come titolo di V livello EQF.', 'Borgo San Martino, 4', 'Lun-Gio 9:00-16:00, Ven 9:00-13:00', 'Quota di iscrizione: ~€102/mese; Materiali didattici: ~€42/mese; Trasporti: ~€25/mese', 211160983),
(95, 95, 'Percorso biennale post-diploma con forte orientamento pratico, sviluppato in collaborazione con imprese del settore a Roma. Include lezioni in aula, laboratori e almeno 800 ore di tirocinio. Il diploma ITS e riconosciuto come titolo di V livello EQF.', 'Via Ostiense, 234', 'Lun-Ven 10:00-16:00', 'Quota di iscrizione: ~€114/mese; Materiali didattici: ~€47/mese; Trasporti: ~€28/mese', 211162714),
(96, 96, 'Percorso biennale post-diploma con forte orientamento pratico, sviluppato in collaborazione con imprese del settore a Milano. Include lezioni in aula, laboratori e almeno 800 ore di tirocinio. Il diploma ITS e riconosciuto come titolo di V livello EQF.', 'Via Durando, 10', 'Mar-Ven 9:00-17:00, Sab 9:00-12:00', 'Quota di iscrizione: ~€114/mese; Materiali didattici: ~€47/mese; Trasporti: ~€28/mese', 211164445),
(97, 97, 'Percorso biennale post-diploma con forte orientamento pratico, sviluppato in collaborazione con imprese del settore a Torino. Include lezioni in aula, laboratori e almeno 800 ore di tirocinio. Il diploma ITS e riconosciuto come titolo di V livello EQF.', 'Via Po, 18', 'Lun-Ven 8:00-19:00', 'Quota di iscrizione: ~€120/mese; Materiali didattici: ~€50/mese; Trasporti: ~€30/mese', 211166176),
(98, 98, 'Percorso biennale post-diploma con forte orientamento pratico, sviluppato in collaborazione con imprese del settore a Torino. Include lezioni in aula, laboratori e almeno 800 ore di tirocinio. Il diploma ITS e riconosciuto come titolo di V livello EQF.', 'Corso Vittorio Emanuele II, 39', 'Lun-Mer 9:00-17:00, Gio-Ven 9:00-14:00', 'Quota di iscrizione: ~€120/mese; Materiali didattici: ~€50/mese; Trasporti: ~€30/mese', 211167907),
(99, 99, 'Percorso biennale post-diploma con forte orientamento pratico, sviluppato in collaborazione con imprese del settore a Milano. Include lezioni in aula, laboratori e almeno 800 ore di tirocinio. Il diploma ITS e riconosciuto come titolo di V livello EQF.', 'Via Festa del Perdono, 7', 'Lun-Ven 9:00-17:00', 'Quota di iscrizione: ~€126/mese; Materiali didattici: ~€52/mese; Trasporti: ~€31/mese', 211169638),
(100, 100, 'Percorso biennale post-diploma con forte orientamento pratico, sviluppato in collaborazione con imprese del settore a Milano. Include lezioni in aula, laboratori e almeno 800 ore di tirocinio. Il diploma ITS e riconosciuto come titolo di V livello EQF.', 'Piazza Leonardo da Vinci, 32', 'Lun-Ven 8:30-18:00', 'Quota di iscrizione: ~€120/mese; Materiali didattici: ~€50/mese; Trasporti: ~€30/mese', 211171369),
(101, 101, 'Percorso professionale per inserirsi nel mondo del lavoro nel settore di riferimento a Roma. Moduli teorico-pratici con docenti provenienti dal settore, stage aziendale incluso e supporto al collocamento al termine del corso.', 'Piazzale Aldo Moro, 5', 'Lun-Gio 9:00-16:00, Ven 9:00-13:00', 'Percorso finanziato: nessun costo di iscrizione; Eventuali spese di trasporto a carico del corsista', 211173100),
(102, 102, 'Percorso professionale per inserirsi nel mondo del lavoro nel settore di riferimento a Milano. Moduli teorico-pratici con docenti provenienti dal settore, stage aziendale incluso e supporto al collocamento al termine del corso.', 'Corso Italia, 1', 'Lun-Ven 10:00-16:00', 'Percorso finanziato: nessun costo di iscrizione; Eventuali spese di trasporto a carico del corsista', 211174831),
(103, 103, 'Percorso professionale per inserirsi nel mondo del lavoro nel settore di riferimento a Torino. Moduli teorico-pratici con docenti provenienti dal settore, stage aziendale incluso e supporto al collocamento al termine del corso.', 'Corso Vittorio Emanuele II, 39', 'Mar-Ven 9:00-17:00, Sab 9:00-12:00', 'Percorso finanziato: nessun costo di iscrizione; Eventuali spese di trasporto a carico del corsista', 211176562),
(104, 104, 'Percorso professionale per inserirsi nel mondo del lavoro nel settore di riferimento a Milano. Moduli teorico-pratici con docenti provenienti dal settore, stage aziendale incluso e supporto al collocamento al termine del corso.', 'Via Conservatorio, 7', 'Lun-Ven 8:00-19:00', 'Percorso finanziato: nessun costo di iscrizione; Eventuali spese di trasporto a carico del corsista', 211178293),
(105, 105, 'Percorso professionale per inserirsi nel mondo del lavoro nel settore di riferimento a Milano. Moduli teorico-pratici con docenti provenienti dal settore, stage aziendale incluso e supporto al collocamento al termine del corso.', 'Via Mancinelli, 7', 'Lun-Mer 9:00-17:00, Gio-Ven 9:00-14:00', 'Percorso finanziato: nessun costo di iscrizione; Eventuali spese di trasporto a carico del corsista', 211180024),
(106, 106, 'Percorso professionale per inserirsi nel mondo del lavoro nel settore di riferimento a Verona. Moduli teorico-pratici con docenti provenienti dal settore, stage aziendale incluso e supporto al collocamento al termine del corso.', 'Viale dell\'Universita, 4', 'Lun-Ven 9:00-17:00', 'Percorso finanziato: nessun costo di iscrizione; Eventuali spese di trasporto a carico del corsista', 211181755),
(107, 107, 'Percorso professionale per inserirsi nel mondo del lavoro nel settore di riferimento a Bologna. Moduli teorico-pratici con docenti provenienti dal settore, stage aziendale incluso e supporto al collocamento al termine del corso.', 'Via Belmeloro, 14', 'Lun-Ven 8:30-18:00', 'Percorso finanziato: nessun costo di iscrizione; Eventuali spese di trasporto a carico del corsista', 211183486),
(108, 108, 'Percorso professionale per inserirsi nel mondo del lavoro nel settore di riferimento a Roma. Moduli teorico-pratici con docenti provenienti dal settore, stage aziendale incluso e supporto al collocamento al termine del corso.', 'Viale Regina Elena, 291', 'Lun-Gio 9:00-16:00, Ven 9:00-13:00', 'Percorso finanziato: nessun costo di iscrizione; Eventuali spese di trasporto a carico del corsista', 211185217),
(109, 109, 'Percorso professionale per inserirsi nel mondo del lavoro nel settore di riferimento a Milano. Moduli teorico-pratici con docenti provenienti dal settore, stage aziendale incluso e supporto al collocamento al termine del corso.', 'Corso Italia, 1', 'Lun-Ven 10:00-16:00', 'Percorso finanziato: nessun costo di iscrizione; Eventuali spese di trasporto a carico del corsista', 211186948),
(110, 110, 'Percorso professionale per inserirsi nel mondo del lavoro nel settore di riferimento a Roma. Moduli teorico-pratici con docenti provenienti dal settore, stage aziendale incluso e supporto al collocamento al termine del corso.', 'Via Ostiense, 234', 'Mar-Ven 9:00-17:00, Sab 9:00-12:00', 'Percorso finanziato: nessun costo di iscrizione; Eventuali spese di trasporto a carico del corsista', 211188679),
(111, 111, 'Percorso biennale post-diploma con forte orientamento pratico, sviluppato in collaborazione con imprese del settore a Mestre. Include lezioni in aula, laboratori e almeno 800 ore di tirocinio. Il diploma ITS e riconosciuto come titolo di V livello EQF.', 'Via Torino, 155', 'Lun-Ven 8:00-19:00', 'Quota di iscrizione: ~€120/mese; Materiali didattici: ~€50/mese; Trasporti: ~€30/mese', 211190410),
(112, 112, 'Percorso professionale per inserirsi nel mondo del lavoro nel settore di riferimento a Milano. Moduli teorico-pratici con docenti provenienti dal settore, stage aziendale incluso e supporto al collocamento al termine del corso.', 'Via Mancinelli, 7', 'Lun-Mer 9:00-17:00, Gio-Ven 9:00-14:00', 'Percorso finanziato: nessun costo di iscrizione; Eventuali spese di trasporto a carico del corsista', 211192141),
(113, 113, 'Percorso professionale per inserirsi nel mondo del lavoro nel settore di riferimento a Mestre. Moduli teorico-pratici con docenti provenienti dal settore, stage aziendale incluso e supporto al collocamento al termine del corso.', 'Via Torino, 155', 'Lun-Ven 9:00-17:00', 'Percorso finanziato: nessun costo di iscrizione; Eventuali spese di trasporto a carico del corsista', 211193872);

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
(1, 'Lingua e letteratura italiana'),
(2, 'Lingua e letteratura latina'),
(3, 'Lingua e letteratura greca'),
(4, 'Lingua e letteratura francese'),
(5, 'Lingua e letteratura inglese'),
(6, 'Lingua e letteratura tedesca'),
(7, 'Lingua e letteratura spagnola'),
(8, 'Lingua e letteratura russa'),
(9, 'Storia'),
(10, 'Filosofia'),
(11, 'Geografia'),
(12, 'Geografia politica ed economica'),
(13, 'Pedagogia'),
(14, 'Psicologia'),
(15, 'Sociologia'),
(16, 'Antropologia culturale'),
(17, 'Diritto'),
(18, 'Economia politica'),
(19, 'Diritto e legislazione scolastica'),
(20, 'Filosofia e scienze dell\'educazione'),
(21, 'Scienze sociali'),
(22, 'Matematica'),
(23, 'Matematica ed informatica'),
(24, 'Fisica'),
(25, 'Fisica ambientale'),
(26, 'Chimica'),
(27, 'Chimica e laboratorio'),
(28, 'Chimica agraria'),
(29, 'Chimica fisica'),
(30, 'Chimica organica e biologica'),
(31, 'Chimica industriale'),
(32, 'Chimica analitica'),
(33, 'Scienze naturali'),
(34, 'Biologia'),
(35, 'Microbiologia'),
(36, 'Geologia e mineralogia'),
(37, 'Anatomia e fisiologia'),
(38, 'Igiene e cultura medica'),
(39, 'Ecologia'),
(40, 'Economia aziendale'),
(41, 'Ragioneria applicata e computisteria'),
(42, 'Tecnica commerciale'),
(43, 'Tecnica bancaria'),
(44, 'Tecnica industriale'),
(45, 'Tecnica turistica'),
(46, 'Amministrazione alberghiera'),
(47, 'Computo e contabilità dei lavori'),
(48, 'Statistica'),
(49, 'Matematica finanziaria ed attuariale'),
(50, 'Informatica gestionale'),
(51, 'Trattamento testi e dati'),
(52, 'Lingua straniera per il commercio'),
(53, 'Corrispondenza commerciale'),
(54, 'Meccanica applicata e macchine'),
(55, 'Tecnologia meccanica'),
(56, 'Disegno meccanico'),
(57, 'Progettazione meccanica'),
(58, 'Elettrotecnica'),
(59, 'Elettronica'),
(60, 'Sistemi automatici'),
(61, 'Impianti elettrici'),
(62, 'Telecomunicazioni'),
(63, 'Tecnologia elettronica'),
(64, 'Informatica industriale'),
(65, 'Tecnologie e disegno tecnico'),
(66, 'Costruzioni'),
(67, 'Costruzioni navali'),
(68, 'Meccanica agraria'),
(69, 'Topografia'),
(70, 'Estimo'),
(71, 'Agronomia e coltivazioni'),
(72, 'Zootecnia'),
(73, 'Industrie agrarie'),
(74, 'Arte mineraria'),
(75, 'Tecnologia tessile'),
(76, 'Tintoria e stampa'),
(77, 'Confezione e modellismo'),
(78, 'Discipline pittoriche'),
(79, 'Discipline plastiche'),
(80, 'Discipline geometriche'),
(81, 'Disegno architettonico'),
(82, 'Storia dell\'arte'),
(83, 'Anatomia artistica'),
(84, 'Progettazione artistica'),
(85, 'Tecniche incisorie'),
(86, 'Fotografia'),
(87, 'Scenografia'),
(88, 'Ornato disegnato e modellato'),
(89, 'Architettura e rilievo'),
(90, 'Teoria, solfeggio e dettato musicale'),
(91, 'Storia della musica'),
(92, 'Armonia'),
(93, 'Esercitazioni corali'),
(94, 'Esercitazioni orchestrali'),
(95, 'Strumento principale'),
(96, 'Musica d\'insieme'),
(97, 'Scienza e cultura degli alimenti'),
(98, 'Laboratorio di cucina'),
(99, 'Laboratorio di sala e vendita'),
(100, 'Laboratorio di accoglienza turistica'),
(101, 'Tecnica dei servizi e pratica operativa'),
(102, 'Economia e gestione dell\'azienda ristorativa'),
(103, 'Diritto e legislazione turistica'),
(104, 'Psicologia applicata'),
(105, 'Metodologie operative'),
(106, 'Tecnica amministrativa'),
(107, 'Igiene e puericultura'),
(108, 'Modellazione odontotecnica'),
(109, 'Ottica fisiopatologica'),
(110, 'Esercitazioni di optometria'),
(111, 'Educazione fisica'),
(112, 'Religione cattolica'),
(113, 'Lingua e cultura ladina'),
(114, 'Lingua e cultura slovena'),
(115, 'Storia ed educazione civica'),
(116, 'Informatica e sistemi automatici'),
(117, 'Elementi di architettura'),
(118, 'Teoria delle forme e disegno'),
(119, 'Laboratorio di fisica e chimica'),
(120, 'Diritto ed economia delle aziende curatrici'),
(121, 'Scienza della terra'),
(122, 'Biologia molecolare e biotecnologie'),
(123, 'Matematica applicata all\'informatica'),
(124, 'Filosofia e storia'),
(125, 'Impianti termici e termotecnica'),
(126, 'Macchine a fluido'),
(127, 'Disegno e progettazione elettronica'),
(128, 'Tecnologia delle costruzioni aeronautiche'),
(129, 'Aerodinamica'),
(130, 'Navigazione aerea e controllo del traffico'),
(131, 'Meteorologia aeronautica'),
(132, 'Strutture e sistemi di bordo'),
(133, 'Teoria della nave'),
(134, 'Macchine marine'),
(135, 'Navigazione e astronomia nautica'),
(136, 'Oceanografia e meteorologia nautica'),
(137, 'Tecnologia dei materiali tessili'),
(138, 'Analisi e prove sui materiali'),
(139, 'Organizzazione della produzione e gestione reparti'),
(140, 'Chimica dei coloranti e nobilitazione'),
(141, 'Disegno dei tessuti e campionatura'),
(142, 'Tecnologia delle materie plastiche e della gomma'),
(143, 'Viticoltura ed enologia'),
(144, 'Difesa delle piante e fitopatologia'),
(145, 'Genetica agraria e biotecnologie'),
(146, 'Economia ed estimo agrario'),
(147, 'Gestione dell\'azienda agraria e contabilità'),
(148, 'Trasformazione dei prodotti agricoli'),
(149, 'Tecnica amministrativa e contabilità informatica'),
(150, 'Tecnica della produzione e dei servizi'),
(151, 'Organizzazione e gestione dei servizi turistici'),
(152, 'Lingua straniera applicata al settore turistico-alberghiero'),
(153, 'Psicologia sociale e delle pubbliche relazioni'),
(154, 'Diritto e legislazione del lavoro'),
(155, 'Igiene, anatomia e fisiologia dell\'ottico'),
(156, 'Esercitazioni di lenti oftalmiche'),
(157, 'Anatomia, fisiologia e igiene dentale'),
(158, 'Gnatologia e protesi dentale'),
(159, 'Chimica e laboratorio dei materiali dentali'),
(160, 'Tecnica della fotografia e comunicazione visiva'),
(161, 'Ripresa e montaggio video'),
(162, 'Grafica editoriale e pubblicitaria'),
(163, 'Organo e composizione organistica'),
(164, 'Lettura della partitura'),
(165, 'Letteratura poetica e drammatica'),
(166, 'Arte scenica'),
(167, 'Didattica della musica'),
(168, 'Paleografia musicale'),
(169, 'Informatica musicale'),
(170, 'Analisi e composizione assistita'),
(171, 'Storia e geografia'),
(172, 'Circolazione aerea e assistenza al volo'),
(173, 'Esercitazioni di navigazione aerea'),
(174, 'Logistica dei trasporti'),
(175, 'Diritto aeronautico e marittimo'),
(176, 'Meccanica applicata alle macchine marine'),
(177, 'Elettrotecnica e comunicazioni elettriche di bordo'),
(178, 'Progettazione e costruzione di mezzi di trasporto'),
(179, 'Tecnologia delle arti grafiche'),
(180, 'Laboratorio di fotolito e stampa'),
(181, 'Disegno professionale e figurino di moda'),
(182, 'Progettazione tessile e abbigliamento'),
(183, 'Storia dell\'arte applicata e del costume'),
(184, 'Marketing e tecniche della comunicazione pubblicitaria'),
(185, 'Psicologia della forma e percezione visiva'),
(186, 'Chimica applicata e dei materiali dentali'),
(187, 'Modellazione e disegno anatomico dei denti'),
(188, 'Ortodonzia e gnatologia'),
(189, 'Fisica dell\'ottica e lenti oftalmiche'),
(190, 'Ottica applicata e strumentazione per optometria'),
(191, 'Arte del legno e del mobile'),
(192, 'Arte del ferro e dei metalli'),
(193, 'Arte della ceramica e del vetro'),
(194, 'Arte del tessuto e della decorazione'),
(195, 'Arte dell\'oreficeria'),
(196, 'Design del prodotto industriale'),
(197, 'Filosofia delle religioni'),
(198, 'Analisi dei testi e critica letteraria'),
(199, 'Storia in lingua straniera'),
(200, 'Geografia in lingua straniera'),
(201, 'Diritto ed economia in lingua straniera'),
(202, 'Lingua e letteratura dell\'area balcanica'),
(203, 'Lingua e letteratura dell\'area asiatica'),
(204, 'Metodologie e tecniche della ricerca sociale'),
(205, 'Statistica sociale e demografica'),
(206, 'Informatica per la gestione d\'ufficio'),
(207, 'Economia e gestione delle risorse umane'),
(208, 'Tecnica della comunicazione e relazioni pubbliche');

-- --------------------------------------------------------

--
-- Struttura della tabella `messaggi`
--

CREATE TABLE `messaggi` (
  `idMessaggio` int NOT NULL,
  `idMittente` int NOT NULL,
  `idDestinatario` int NOT NULL,
  `testo` text NOT NULL,
  `dataInvio` datetime DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dump dei dati per la tabella `messaggi`
--

INSERT INTO `messaggi` (`idMessaggio`, `idMittente`, `idDestinatario`, `testo`, `dataInvio`) VALUES
(3, 1, 1, '1231231', '2026-03-20 11:33:48'),
(4, 1, 1, '12312312', '2026-03-20 11:33:50'),
(5, 1, 1, '12312312', '2026-03-20 11:33:51'),
(6, 4, 3, 'ti scopo', '2026-04-13 09:09:28'),
(7, 3, 4, 'no', '2026-04-21 10:57:57');

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
(2, 1, 'vichiosu1 ha commentato il tuo post in bacheca.', '2026-03-31 08:19:06', 0);

-- --------------------------------------------------------

--
-- Struttura della tabella `percorsi`
--

CREATE TABLE `percorsi` (
  `idPercorso` int NOT NULL,
  `idCategoria` int NOT NULL,
  `titolo` varchar(150) NOT NULL,
  `descrizione` text,
  `costoMedioMensile` decimal(10,2) DEFAULT NULL,
  `difficolta` int DEFAULT NULL,
  `citta` varchar(100) DEFAULT NULL
) ;

--
-- Dump dei dati per la tabella `percorsi`
--

INSERT INTO `percorsi` (`idPercorso`, `idCategoria`, `titolo`, `descrizione`, `costoMedioMensile`, `difficolta`, `citta`) VALUES
(1, 2, 'Laurea in Ingegneria Informatica', 'Corso di laurea triennale focalizzato su programmazione, reti e sistemi.', 350.00, 4, 'Milano'),
(2, 2, 'Laurea in Ingegneria Elettronica', 'Corso di laurea triennale su circuiti, sistemi elettronici e telecomunicazioni.', 350.00, 4, 'Torino'),
(3, 2, 'Laurea in Ingegneria Meccanica', 'Corso di laurea triennale su macchine, progettazione e materiali.', 350.00, 4, 'Bologna'),
(4, 2, 'Laurea in Ingegneria Elettrica', 'Corso di laurea triennale su impianti elettrici e sistemi di potenza.', 350.00, 4, 'Napoli'),
(5, 2, 'Laurea in Fisica', 'Corso di laurea triennale su meccanica, termodinamica e fisica moderna.', 300.00, 5, 'Roma'),
(6, 2, 'Laurea in Chimica', 'Corso di laurea triennale su chimica organica, inorganica e analitica.', 300.00, 4, 'Milano'),
(7, 2, 'Laurea in Biologia', 'Corso di laurea triennale su biologia cellulare, genetica ed ecologia.', 300.00, 3, 'Roma'),
(8, 2, 'Laurea in Matematica', 'Corso di laurea triennale su analisi, algebra e geometria.', 300.00, 5, 'Pisa'),
(9, 2, 'Laurea in Economia e Commercio', 'Corso di laurea triennale su economia aziendale, diritto e statistica.', 320.00, 3, 'Milano'),
(10, 2, 'Laurea in Giurisprudenza', 'Corso di laurea magistrale a ciclo unico su diritto civile, penale e amministrativo.', 320.00, 4, 'Roma'),
(11, 2, 'Laurea in Lettere', 'Corso di laurea triennale su letteratura italiana, latina e storia.', 280.00, 3, 'Firenze'),
(12, 2, 'Laurea in Filosofia', 'Corso di laurea triennale su storia della filosofia, logica ed etica.', 280.00, 3, 'Bologna'),
(13, 2, 'Laurea in Psicologia', 'Corso di laurea triennale su psicologia generale, sociale e clinica.', 300.00, 3, 'Padova'),
(14, 2, 'Laurea in Sociologia', 'Corso di laurea triennale su metodologie della ricerca sociale e antropologia.', 280.00, 3, 'Trento'),
(15, 2, 'Laurea in Scienze della Formazione', 'Corso di laurea triennale su pedagogia, psicologia e didattica.', 280.00, 2, 'Roma'),
(16, 2, 'Laurea in Architettura', 'Corso di laurea magistrale a ciclo unico su progettazione e storia dell\'architettura.', 380.00, 4, 'Milano'),
(17, 2, 'Laurea in Agraria', 'Corso di laurea triennale su agronomia, zootecnia e gestione aziendale agricola.', 300.00, 3, 'Bologna'),
(18, 2, 'Laurea in Scienze Politiche', 'Corso di laurea triennale su diritto, economia politica e sociologia.', 280.00, 3, 'Roma'),
(19, 2, 'Laurea in Informatica', 'Corso di laurea triennale su algoritmi, basi di dati e sviluppo software.', 320.00, 4, 'Milano'),
(20, 2, 'Laurea in Statistica', 'Corso di laurea triennale su statistica, matematica e informatica applicata.', 300.00, 4, 'Padova'),
(21, 2, 'Laurea in Lingue e Letterature Straniere', 'Corso di laurea triennale su lingua inglese, francese, tedesca e spagnola.', 280.00, 3, 'Venezia'),
(22, 2, 'Laurea in Scienze Naturali', 'Corso di laurea triennale su biologia, geologia ed ecologia.', 290.00, 3, 'Genova'),
(23, 2, 'Laurea in Geologia', 'Corso di laurea triennale su geologia, mineralogia e scienza della terra.', 290.00, 3, 'Napoli'),
(24, 2, 'Laurea in Biotecnologie', 'Corso di laurea triennale su biologia molecolare, microbiologia e biotecnologie.', 320.00, 4, 'Milano'),
(25, 2, 'Laurea in Medicina e Chirurgia', 'Corso di laurea magistrale a ciclo unico su anatomia, fisiologia e igiene.', 500.00, 5, 'Roma'),
(26, 2, 'Laurea in Economia Aziendale', 'Corso di laurea triennale su ragioneria, diritto e tecnica commerciale.', 320.00, 3, 'Bocconi'),
(27, 2, 'Laurea in Comunicazione', 'Corso di laurea triennale su marketing, psicologia della comunicazione e sociologia.', 290.00, 2, 'Milano'),
(28, 2, 'Laurea in Design', 'Corso di laurea triennale su progettazione artistica, fotografia e storia dell\'arte.', 400.00, 3, 'Milano'),
(29, 2, 'Laurea in Conservazione dei Beni Culturali', 'Corso di laurea triennale su storia dell\'arte, chimica e analisi dei materiali.', 290.00, 3, 'Firenze'),
(30, 2, 'Laurea in Musicologia', 'Corso di laurea triennale su storia della musica, armonia e paleografia musicale.', 280.00, 3, 'Bologna'),
(31, 1, 'ITS Tecnologie Informatiche e Software', 'Percorso biennale su informatica, sistemi automatici e informatica industriale.', 200.00, 3, 'Milano'),
(32, 1, 'ITS Meccatronica e Robotica', 'Percorso biennale su meccanica, elettronica e sistemi automatici.', 200.00, 3, 'Torino'),
(33, 1, 'ITS Efficienza Energetica', 'Percorso biennale su impianti elettrici, impianti termici e termotecnica.', 180.00, 3, 'Bologna'),
(34, 1, 'ITS Mobilità Sostenibile', 'Percorso biennale su logistica, tecnologie costruzioni aeronautiche e aerodinamica.', 190.00, 3, 'Roma'),
(35, 1, 'ITS Nuove Tecnologie per il Made in Italy - Moda', 'Percorso biennale su tecnologia tessile, confezione e progettazione tessile.', 180.00, 2, 'Firenze'),
(36, 1, 'ITS Agroalimentare', 'Percorso biennale su viticoltura, trasformazione prodotti agricoli e chimica agraria.', 170.00, 2, 'Verona'),
(37, 1, 'ITS Turismo e Ospitalità', 'Percorso biennale su tecnica turistica, amministrazione alberghiera e marketing.', 170.00, 2, 'Venezia'),
(38, 1, 'ITS Costruzioni e Infrastrutture', 'Percorso biennale su costruzioni, topografia ed estimo.', 180.00, 3, 'Milano'),
(39, 1, 'ITS Grafica e Comunicazione Visiva', 'Percorso biennale su tecnologia arti grafiche, grafica editoriale e fotografia.', 190.00, 2, 'Milano'),
(40, 1, 'ITS Nautica e Mare', 'Percorso biennale su navigazione nautica, teoria della nave e macchine marine.', 190.00, 3, 'Genova'),
(41, 1, 'ITS Elettronica e Automazione', 'Percorso biennale su elettronica, telecomunicazioni e disegno e progettazione elettronica.', 200.00, 3, 'Torino'),
(42, 1, 'ITS Aeronautica', 'Percorso biennale su strutture e sistemi di bordo, navigazione aerea e meteorologia aeronautica.', 200.00, 4, 'Roma'),
(43, 1, 'ITS Biotecnologie e Salute', 'Percorso biennale su microbiologia, biologia molecolare e biotecnologie.', 200.00, 4, 'Milano'),
(44, 1, 'ITS Gestione d\'Impresa', 'Percorso biennale su economia aziendale, informatica gestionale e statistica.', 180.00, 2, 'Bologna'),
(45, 1, 'ITS Cinema e Audiovisivo', 'Percorso biennale su ripresa e montaggio video, fotografia e tecnica della comunicazione.', 190.00, 2, 'Roma'),
(46, 3, 'Tecnico Programmatore Software', 'Percorso professionale per sviluppatori su informatica, sistemi automatici e basi di dati.', 0.00, 3, 'Milano'),
(47, 3, 'Tecnico Elettronico', 'Percorso professionale su elettronica, telecomunicazioni e impianti elettrici.', 0.00, 3, 'Torino'),
(48, 3, 'Tecnico Meccanico', 'Percorso professionale su meccanica, tecnologia meccanica e disegno meccanico.', 0.00, 3, 'Brescia'),
(49, 3, 'Contabile e Amministrativo', 'Percorso professionale su ragioneria, economia aziendale e diritto.', 0.00, 2, 'Milano'),
(50, 3, 'Cuoco Professionista', 'Percorso professionale su laboratorio di cucina, scienza degli alimenti e igiene.', 0.00, 2, 'Roma'),
(51, 3, 'Operatore Turistico', 'Percorso professionale su tecnica turistica, diritto turistico e lingua straniera.', 0.00, 2, 'Venezia'),
(52, 3, 'Grafico Pubblicitario', 'Percorso professionale su grafica editoriale, tecnologia arti grafiche e marketing.', 0.00, 2, 'Milano'),
(53, 3, 'Tecnico Agricolo', 'Percorso professionale su agronomia, genetica agraria e difesa delle piante.', 0.00, 2, 'Bari'),
(54, 3, 'Operatore Socio-Sanitario', 'Percorso professionale su igiene, anatomia e fisiologia e metodologie operative.', 0.00, 2, 'Roma'),
(55, 3, 'Tecnico di Laboratorio Chimico', 'Percorso professionale su chimica analitica, chimica organica e microbiologia.', 0.00, 3, 'Milano'),
(56, 3, 'Sarto e Modellista', 'Percorso professionale su confezione e modellismo, tecnologia tessile e disegno professionale.', 0.00, 2, 'Milano'),
(57, 3, 'Odontotecnico', 'Percorso professionale su modellazione odontotecnica, gnatologia e chimica dei materiali dentali.', 0.00, 3, 'Roma'),
(58, 3, 'Ottico Optometrista', 'Percorso professionale su ottica fisiopatologica, esercitazioni di optometria e fisica dell\'ottica.', 0.00, 3, 'Milano'),
(59, 3, 'Operatore di Sala e Ristorazione', 'Percorso professionale su laboratorio di sala e vendita, scienza degli alimenti e marketing.', 0.00, 1, 'Napoli'),
(60, 3, 'Tecnico Edile', 'Percorso professionale su costruzioni, topografia ed estimo.', 0.00, 3, 'Roma'),
(61, 3, 'Tecnico Navale', 'Percorso professionale su costruzioni navali, macchine marine e teoria della nave.', 0.00, 3, 'Genova'),
(62, 3, 'Tecnico Aeronautico', 'Percorso professionale su strutture di bordo, navigazione aerea e aerodinamica.', 0.00, 4, 'Roma'),
(63, 3, 'Viticoltore ed Enologo', 'Percorso professionale su viticoltura, trasformazione prodotti agricoli e chimica.', 0.00, 3, 'Verona'),
(64, 3, 'Fotografo e Videomaker', 'Percorso professionale su fotografia, ripresa e montaggio video e tecnica della comunicazione.', 0.00, 2, 'Milano'),
(65, 3, 'Musicista e Compositore', 'Percorso professionale su strumento principale, armonia e analisi e composizione assistita.', 0.00, 4, 'Milano'),
(66, 3, 'Insegnante di Sostegno', 'Percorso abilitante su pedagogia, psicologia applicata e metodologie operative.', 0.00, 3, 'Roma'),
(67, 3, 'Assistente Sociale', 'Percorso professionale su sociologia, diritto, psicologia sociale e metodologie operative.', 0.00, 3, 'Torino'),
(68, 3, 'HR Manager', 'Percorso professionale su economia e gestione delle risorse umane, diritto del lavoro e psicologia.', 0.00, 3, 'Milano'),
(69, 3, 'Esperto di Marketing Digitale', 'Percorso professionale su marketing, informatica gestionale e tecnica della comunicazione.', 0.00, 2, 'Milano'),
(70, 3, 'Logista e Trasportista', 'Percorso professionale su logistica dei trasporti, diritto e informatica gestionale.', 0.00, 2, 'Bologna'),
(71, 2, 'Laurea in Ingegneria Civile', 'Corso di laurea triennale su costruzioni, topografia e matematica applicata.', 350.00, 4, 'Milano'),
(72, 2, 'Laurea in Ingegneria Aerospaziale', 'Corso di laurea triennale su aerodinamica, strutture aeronautiche e fisica.', 380.00, 5, 'Roma'),
(73, 2, 'Laurea in Ingegneria Navale', 'Corso di laurea triennale su teoria della nave, macchine marine e costruzioni navali.', 350.00, 4, 'Genova'),
(74, 2, 'Laurea in Ingegneria delle Telecomunicazioni', 'Corso di laurea triennale su telecomunicazioni, elettronica e sistemi automatici.', 350.00, 4, 'Torino'),
(75, 2, 'Laurea in Scienze Agrarie', 'Corso di laurea triennale su agronomia, genetica agraria e zootecnia.', 290.00, 3, 'Bologna'),
(76, 2, 'Laurea in Medicina Veterinaria', 'Corso di laurea magistrale a ciclo unico su anatomia, microbiologia e zootecnia.', 400.00, 5, 'Torino'),
(77, 2, 'Laurea in Farmacia', 'Corso di laurea magistrale a ciclo unico su chimica organica, biologia e igiene.', 380.00, 5, 'Napoli'),
(78, 2, 'Laurea in Scienze Motorie', 'Corso di laurea triennale su anatomia, fisiologia e educazione fisica.', 280.00, 2, 'Roma'),
(79, 2, 'Laurea in Economia del Turismo', 'Corso di laurea triennale su economia aziendale, tecnica turistica e lingua straniera.', 300.00, 2, 'Venezia'),
(80, 2, 'Laurea in Ingegneria Gestionale', 'Corso di laurea triennale su matematica, statistica, economia aziendale e informatica.', 350.00, 4, 'Milano'),
(81, 2, 'Laurea in Scienze dell\'Educazione', 'Corso di laurea triennale su pedagogia, psicologia e sociologia.', 270.00, 2, 'Roma'),
(82, 2, 'Laurea in Astronomia', 'Corso di laurea triennale su fisica, matematica e scienza della terra.', 300.00, 5, 'Bologna'),
(83, 2, 'Laurea in Ingegneria Biomedica', 'Corso di laurea triennale su biologia, fisica, elettronica e anatomia.', 370.00, 5, 'Milano'),
(84, 2, 'Laurea in Scienze Ambientali', 'Corso di laurea triennale su ecologia, chimica ambientale e scienza della terra.', 290.00, 3, 'Venezia'),
(85, 2, 'Laurea in Relazioni Internazionali', 'Corso di laurea triennale su diritto, economia politica, storia e lingua straniera.', 300.00, 3, 'Roma'),
(86, 2, 'Laurea in Ingegneria Chimica', 'Corso di laurea triennale su chimica industriale, fisica e matematica.', 360.00, 5, 'Milano'),
(87, 2, 'Laurea in Ingegneria dei Materiali', 'Corso di laurea triennale su chimica, fisica e analisi dei materiali.', 350.00, 4, 'Torino'),
(88, 2, 'Laurea in Storia', 'Corso di laurea triennale su storia, filosofia e storia dell\'arte.', 270.00, 3, 'Firenze'),
(89, 2, 'Laurea in Arte e Spettacolo', 'Corso di laurea triennale su storia dell\'arte, scenografia e arte scenica.', 290.00, 3, 'Roma'),
(90, 2, 'Laurea in Scienze Infermieristiche', 'Corso di laurea triennale su anatomia, igiene, microbiologia e metodologie operative.', 300.00, 3, 'Milano'),
(91, 1, 'ITS Digital Marketing', 'Percorso biennale su marketing, informatica gestionale e psicologia della comunicazione.', 190.00, 2, 'Milano'),
(92, 1, 'ITS Energie Rinnovabili', 'Percorso biennale su fisica ambientale, impianti termici ed elettrotecnica.', 190.00, 3, 'Bari'),
(93, 1, 'ITS Logistica e Trasporti', 'Percorso biennale su logistica, diritto e informatica gestionale.', 180.00, 2, 'Bologna'),
(94, 1, 'ITS Ristorazione e Food Innovation', 'Percorso biennale su scienza degli alimenti, laboratorio di cucina e marketing.', 170.00, 2, 'Parma'),
(95, 1, 'ITS Sanità e Benessere', 'Percorso biennale su igiene, anatomia, microbiologia e metodologie operative.', 190.00, 3, 'Roma'),
(96, 1, 'ITS Sistemi Informativi Aziendali', 'Percorso biennale su informatica gestionale, economia aziendale e statistica.', 190.00, 3, 'Milano'),
(97, 1, 'ITS Design e Artigianato Digitale', 'Percorso biennale su progettazione artistica, design del prodotto e tecnologia arti grafiche.', 200.00, 3, 'Torino'),
(98, 1, 'ITS Automotive', 'Percorso biennale su meccanica, elettronica, sistemi automatici e progettazione meccanica.', 200.00, 3, 'Torino'),
(99, 1, 'ITS Industria 4.0', 'Percorso biennale su informatica industriale, sistemi automatici e organizzazione della produzione.', 210.00, 4, 'Milano'),
(100, 1, 'ITS Sicurezza Informatica', 'Percorso biennale su informatica, telecomunicazioni e sistemi automatici.', 200.00, 4, 'Milano'),
(101, 3, 'Tecnico Fiscale e Tributario', 'Percorso professionale su diritto, economia politica e ragioneria.', 0.00, 3, 'Roma'),
(102, 3, 'Agente Immobiliare', 'Percorso professionale su estimo, diritto e economia aziendale.', 0.00, 2, 'Milano'),
(103, 3, 'Tecnico della Sicurezza sul Lavoro', 'Percorso professionale su igiene, diritto e tecnica industriale.', 0.00, 3, 'Torino'),
(104, 3, 'Responsabile della Ristorazione', 'Percorso professionale su economia gestione azienda ristorativa, laboratorio di cucina e diritto.', 0.00, 3, 'Milano'),
(105, 3, 'Tecnico della Comunicazione', 'Percorso professionale su marketing, grafica editoriale e psicologia della forma.', 0.00, 2, 'Milano'),
(106, 3, 'Sommelier ed Esperto Enogastronomico', 'Percorso professionale su viticoltura, scienza degli alimenti e chimica.', 0.00, 2, 'Verona'),
(107, 3, 'Ricercatore Sociale', 'Percorso professionale su sociologia, statistica sociale e metodologie della ricerca.', 0.00, 4, 'Bologna'),
(108, 3, 'Animatore Culturale', 'Percorso professionale su pedagogia, sociologia e storia dell\'arte.', 0.00, 2, 'Roma'),
(109, 3, 'Tecnico Informatico di Rete', 'Percorso professionale su telecomunicazioni, informatica e sistemi automatici.', 0.00, 3, 'Milano'),
(110, 3, 'Pianificatore Urbano', 'Percorso professionale su costruzioni, topografia, estimo ed elementi di architettura.', 0.00, 4, 'Roma'),
(111, 1, 'Laurea in informatica', '123', 200.00, 4, 'Mestre'),
(112, 3, 'Lavoro come tecnico ', '123', 123.00, 3, 'Milano'),
(113, 3, 'Lucy cupcake', 'Lavoro in via aleardo', 0.00, 3, 'Mestre');

-- --------------------------------------------------------

--
-- Struttura della tabella `percorsiMaterie`
--

CREATE TABLE `percorsiMaterie` (
  `idPercorso` int NOT NULL,
  `idMateria` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dump dei dati per la tabella `percorsiMaterie`
--

INSERT INTO `percorsiMaterie` (`idPercorso`, `idMateria`) VALUES
(11, 1),
(11, 2),
(21, 4),
(21, 5),
(21, 6),
(21, 7),
(11, 9),
(12, 9),
(18, 9),
(85, 9),
(88, 9),
(12, 10),
(88, 10),
(12, 11),
(22, 12),
(15, 13),
(66, 13),
(81, 13),
(108, 13),
(13, 14),
(15, 14),
(27, 14),
(68, 14),
(81, 14),
(13, 15),
(14, 15),
(18, 15),
(27, 15),
(67, 15),
(81, 15),
(107, 15),
(108, 15),
(13, 16),
(14, 16),
(9, 17),
(10, 17),
(18, 17),
(26, 17),
(49, 17),
(67, 17),
(70, 17),
(85, 17),
(93, 17),
(101, 17),
(102, 17),
(103, 17),
(104, 17),
(9, 18),
(10, 18),
(18, 18),
(85, 18),
(101, 18),
(10, 19),
(15, 19),
(1, 22),
(3, 22),
(4, 22),
(5, 22),
(8, 22),
(19, 22),
(20, 22),
(31, 22),
(46, 22),
(71, 22),
(72, 22),
(80, 22),
(82, 22),
(86, 22),
(100, 22),
(109, 22),
(1, 23),
(2, 24),
(4, 24),
(5, 24),
(72, 24),
(82, 24),
(83, 24),
(86, 24),
(87, 24),
(5, 25),
(92, 25),
(6, 26),
(29, 26),
(63, 26),
(84, 26),
(87, 26),
(106, 26),
(36, 28),
(6, 29),
(6, 30),
(55, 30),
(77, 30),
(86, 31),
(6, 32),
(55, 32),
(7, 33),
(22, 33),
(7, 34),
(23, 34),
(24, 34),
(25, 34),
(43, 34),
(77, 34),
(83, 34),
(24, 35),
(25, 35),
(43, 35),
(55, 35),
(76, 35),
(90, 35),
(95, 35),
(22, 36),
(23, 36),
(25, 37),
(54, 37),
(76, 37),
(78, 37),
(83, 37),
(90, 37),
(95, 37),
(25, 38),
(50, 38),
(54, 38),
(77, 38),
(78, 38),
(90, 38),
(95, 38),
(103, 38),
(7, 39),
(22, 39),
(84, 39),
(9, 40),
(26, 40),
(44, 40),
(49, 40),
(79, 40),
(80, 40),
(96, 40),
(102, 40),
(26, 41),
(49, 41),
(101, 41),
(26, 42),
(103, 44),
(37, 45),
(51, 45),
(79, 45),
(37, 46),
(8, 48),
(9, 48),
(14, 48),
(20, 48),
(44, 48),
(80, 48),
(96, 48),
(1, 50),
(19, 50),
(31, 50),
(44, 50),
(46, 50),
(69, 50),
(70, 50),
(80, 50),
(91, 50),
(93, 50),
(96, 50),
(51, 52),
(79, 52),
(85, 52),
(3, 54),
(32, 54),
(48, 54),
(98, 54),
(3, 55),
(32, 55),
(48, 55),
(112, 55),
(3, 56),
(48, 56),
(3, 57),
(98, 57),
(2, 58),
(4, 58),
(33, 58),
(92, 58),
(2, 59),
(32, 59),
(41, 59),
(47, 59),
(74, 59),
(83, 59),
(98, 59),
(1, 60),
(32, 60),
(74, 60),
(98, 60),
(99, 60),
(100, 60),
(109, 60),
(4, 61),
(33, 61),
(47, 61),
(2, 62),
(41, 62),
(47, 62),
(74, 62),
(100, 62),
(109, 62),
(2, 63),
(112, 63),
(1, 64),
(19, 64),
(31, 64),
(46, 64),
(99, 64),
(16, 66),
(38, 66),
(60, 66),
(71, 66),
(110, 66),
(61, 67),
(73, 67),
(16, 69),
(27, 69),
(38, 69),
(60, 69),
(71, 69),
(110, 69),
(38, 70),
(60, 70),
(102, 70),
(110, 70),
(17, 71),
(53, 71),
(75, 71),
(17, 72),
(75, 72),
(76, 72),
(35, 75),
(56, 75),
(35, 77),
(56, 77),
(16, 81),
(28, 82),
(29, 82),
(88, 82),
(89, 82),
(108, 82),
(28, 85),
(97, 85),
(28, 87),
(39, 87),
(45, 87),
(64, 87),
(89, 88),
(16, 90),
(30, 92),
(30, 93),
(65, 93),
(65, 96),
(50, 98),
(59, 98),
(94, 98),
(106, 98),
(50, 99),
(94, 99),
(104, 99),
(59, 100),
(104, 103),
(51, 104),
(66, 105),
(54, 106),
(66, 106),
(90, 106),
(95, 106),
(57, 110),
(58, 111),
(58, 112),
(78, 113),
(110, 120),
(23, 124),
(82, 124),
(84, 124),
(33, 128),
(92, 128),
(112, 128),
(113, 129),
(41, 130),
(34, 131),
(72, 131),
(34, 132),
(62, 132),
(72, 132),
(42, 133),
(42, 134),
(42, 135),
(62, 135),
(40, 136),
(61, 136),
(73, 136),
(40, 137),
(61, 137),
(73, 137),
(40, 138),
(29, 141),
(87, 141),
(99, 142),
(36, 146),
(63, 146),
(106, 146),
(53, 147),
(53, 148),
(75, 148),
(17, 149),
(17, 150),
(36, 151),
(63, 151),
(67, 156),
(68, 157),
(57, 161),
(57, 162),
(45, 163),
(64, 163),
(45, 164),
(64, 164),
(39, 165),
(52, 165),
(105, 165),
(89, 169),
(30, 171),
(65, 173),
(62, 178),
(34, 180),
(70, 180),
(93, 180),
(39, 185),
(52, 185),
(91, 185),
(97, 185),
(105, 185),
(56, 187),
(35, 188),
(37, 190),
(52, 190),
(58, 190),
(59, 190),
(69, 190),
(91, 190),
(94, 190),
(105, 190),
(28, 196),
(97, 196),
(14, 204),
(107, 204),
(20, 205),
(107, 205),
(68, 207),
(69, 208);

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
-- Struttura della tabella `recensioni`
--

CREATE TABLE `recensioni` (
  `idRecensione` int NOT NULL,
  `idUtenteScrittore` int NOT NULL,
  `idUtenteRicevente` int NOT NULL,
  `voto` tinyint(1) NOT NULL,
  `commento` text,
  `dataRecensione` datetime DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dump dei dati per la tabella `recensioni`
--

INSERT INTO `recensioni` (`idRecensione`, `idUtenteScrittore`, `idUtenteRicevente`, `voto`, `commento`, `dataRecensione`) VALUES
(1, 3, 1, 6, 'br\r\navo', '2026-03-31 09:12:35'),
(2, 1, 3, 7, '1231231', '2026-03-31 09:25:50'),
(3, 1, 3, 3, 'barraneik', '2026-03-31 09:26:01'),
(4, 3, 1, 10, 'bravoi', '2026-03-31 09:45:37'),
(5, 3, 1, 8, '123123', '2026-04-07 11:39:47'),
(6, 3, 1, 10, '12312312312312', '2026-04-08 11:48:40'),
(7, 1, 3, 2, '12312313', '2026-04-09 09:11:42'),
(8, 4, 3, 8, 'perchè è aura', '2026-04-13 09:09:08'),
(9, 3, 1, 10, 'bravo\r\n', '2026-04-21 10:56:27');

-- --------------------------------------------------------

--
-- Struttura della tabella `risposte`
--

CREATE TABLE `risposte` (
  `idRisposta` int NOT NULL,
  `idAnnuncio` int NOT NULL,
  `idUtente` int NOT NULL,
  `testo` text NOT NULL,
  `dataRisposta` datetime DEFAULT CURRENT_TIMESTAMP,
  `utile` tinyint(1) DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dump dei dati per la tabella `risposte`
--

INSERT INTO `risposte` (`idRisposta`, `idAnnuncio`, `idUtente`, `testo`, `dataRisposta`, `utile`) VALUES
(4, 3, 1, '123', '2026-03-31 08:16:50', 0),
(5, 3, 3, '2323', '2026-03-31 08:19:06', 0);

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
(1, 'vichiosu', '$2y$10$GinpwQJ3KBATiy.3sxo6ze2fW.JSrT42PKadgAwFsKq1AfJArHsJC', 'admin', 'Tecnico', 18),
(2, 'vichiosu123', '$2y$10$BnHVjgDmFYYvcFT0vZL0Nuzqm1c3lGjaUYbxdNsa/J1gdCTbsyIQK', 'studente', 'Liceo', 0),
(3, 'vichiosu1', '$2y$10$.P7cSx31V9hDJXHw32QL6OK7juoZvSs9jn12RkYshr9u1lia6Kmk.', 'studente', 'Liceo', 6),
(4, 'Mattia', '$2y$10$CJHZDa1L3BoYct80wVDuqO7KEWnEJ8GooojAaHbaWnMDLot8g9G2G', 'mentore', 'Liceo', 0);

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
-- Indici per le tabelle `dettagliPercorsi`
--
ALTER TABLE `dettagliPercorsi`
  ADD PRIMARY KEY (`idDettaglio`),
  ADD KEY `idPercorso` (`idPercorso`);

--
-- Indici per le tabelle `materie`
--
ALTER TABLE `materie`
  ADD PRIMARY KEY (`idMateria`);

--
-- Indici per le tabelle `messaggi`
--
ALTER TABLE `messaggi`
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
-- Indici per le tabelle `percorsiMaterie`
--
ALTER TABLE `percorsiMaterie`
  ADD PRIMARY KEY (`idPercorso`,`idMateria`),
  ADD KEY `idMateria` (`idMateria`);

--
-- Indici per le tabelle `preferiti`
--
ALTER TABLE `preferiti`
  ADD PRIMARY KEY (`idUtente`,`idPercorso`),
  ADD KEY `idPercorso` (`idPercorso`);

--
-- Indici per le tabelle `recensioni`
--
ALTER TABLE `recensioni`
  ADD PRIMARY KEY (`idRecensione`),
  ADD KEY `idUtenteScrittore` (`idUtenteScrittore`),
  ADD KEY `idUtenteRicevente` (`idUtenteRicevente`);

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
  MODIFY `idAnnuncio` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT per la tabella `categorie`
--
ALTER TABLE `categorie`
  MODIFY `idCategoria` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT per la tabella `dettagliPercorsi`
--
ALTER TABLE `dettagliPercorsi`
  MODIFY `idDettaglio` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=114;

--
-- AUTO_INCREMENT per la tabella `materie`
--
ALTER TABLE `materie`
  MODIFY `idMateria` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=209;

--
-- AUTO_INCREMENT per la tabella `messaggi`
--
ALTER TABLE `messaggi`
  MODIFY `idMessaggio` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT per la tabella `notifiche`
--
ALTER TABLE `notifiche`
  MODIFY `idNotifica` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT per la tabella `percorsi`
--
ALTER TABLE `percorsi`
  MODIFY `idPercorso` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT per la tabella `recensioni`
--
ALTER TABLE `recensioni`
  MODIFY `idRecensione` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT per la tabella `risposte`
--
ALTER TABLE `risposte`
  MODIFY `idRisposta` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT per la tabella `utenti`
--
ALTER TABLE `utenti`
  MODIFY `idUtente` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- Limiti per le tabelle scaricate
--

--
-- Limiti per la tabella `annunci`
--
ALTER TABLE `annunci`
  ADD CONSTRAINT `annunci_ibfk_1` FOREIGN KEY (`idUtente`) REFERENCES `utenti` (`idUtente`) ON DELETE CASCADE;

--
-- Limiti per la tabella `dettagliPercorsi`
--
ALTER TABLE `dettagliPercorsi`
  ADD CONSTRAINT `dettagliPercorsi_ibfk_1` FOREIGN KEY (`idPercorso`) REFERENCES `percorsi` (`idPercorso`);

--
-- Limiti per la tabella `messaggi`
--
ALTER TABLE `messaggi`
  ADD CONSTRAINT `messaggi_ibfk_1` FOREIGN KEY (`idMittente`) REFERENCES `utenti` (`idUtente`) ON DELETE CASCADE,
  ADD CONSTRAINT `messaggi_ibfk_2` FOREIGN KEY (`idDestinatario`) REFERENCES `utenti` (`idUtente`) ON DELETE CASCADE;

--
-- Limiti per la tabella `notifiche`
--
ALTER TABLE `notifiche`
  ADD CONSTRAINT `notifiche_ibfk_1` FOREIGN KEY (`idUtente`) REFERENCES `utenti` (`idUtente`) ON DELETE CASCADE;

--
-- Limiti per la tabella `percorsi`
--
ALTER TABLE `percorsi`
  ADD CONSTRAINT `percorsi_ibfk_1` FOREIGN KEY (`idCategoria`) REFERENCES `categorie` (`idCategoria`) ON DELETE CASCADE;

--
-- Limiti per la tabella `percorsiMaterie`
--
ALTER TABLE `percorsiMaterie`
  ADD CONSTRAINT `percorsiMaterie_ibfk_1` FOREIGN KEY (`idPercorso`) REFERENCES `percorsi` (`idPercorso`) ON DELETE CASCADE,
  ADD CONSTRAINT `percorsiMaterie_ibfk_2` FOREIGN KEY (`idMateria`) REFERENCES `materie` (`idMateria`) ON DELETE CASCADE;

--
-- Limiti per la tabella `preferiti`
--
ALTER TABLE `preferiti`
  ADD CONSTRAINT `preferiti_ibfk_1` FOREIGN KEY (`idUtente`) REFERENCES `utenti` (`idUtente`) ON DELETE CASCADE,
  ADD CONSTRAINT `preferiti_ibfk_2` FOREIGN KEY (`idPercorso`) REFERENCES `percorsi` (`idPercorso`) ON DELETE CASCADE;

--
-- Limiti per la tabella `recensioni`
--
ALTER TABLE `recensioni`
  ADD CONSTRAINT `recensioni_ibfk_1` FOREIGN KEY (`idUtenteScrittore`) REFERENCES `utenti` (`idUtente`) ON DELETE CASCADE,
  ADD CONSTRAINT `recensioni_ibfk_2` FOREIGN KEY (`idUtenteRicevente`) REFERENCES `utenti` (`idUtente`) ON DELETE CASCADE;

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
