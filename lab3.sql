-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `mydb` DEFAULT CHARACTER SET utf8 ;
USE `mydb` ;

-- -----------------------------------------------------
-- Table `mydb`.`collectives`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`collectives` (
  `idCollective` INT NOT NULL AUTO_INCREMENT,
  `Name` VARCHAR(45) NULL DEFAULT NULL,
  `Description` MEDIUMTEXT NULL DEFAULT NULL,
  PRIMARY KEY (`idCollective`));


-- -----------------------------------------------------
-- Table `mydb`.`performers`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`performers` (
  `idPerformer` INT NOT NULL AUTO_INCREMENT,
  `Name` VARCHAR(45) NULL DEFAULT NULL,
  `Description` MEDIUMTEXT NULL DEFAULT NULL,
  PRIMARY KEY (`idPerformer`))
ENGINE = InnoDB
AUTO_INCREMENT = 3
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `mydb`.`collectives_has_performers`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`collectives_has_performers` (
  `Collectives_idCollective` INT NOT NULL,
  `Performers_idPerformer` INT NOT NULL,
  PRIMARY KEY (`Collectives_idCollective`, `Performers_idPerformer`),
  INDEX `fk_Collectives_has_Performers_Performers1_idx` (`Performers_idPerformer` ASC) VISIBLE,
  INDEX `fk_Collectives_has_Performers_Collectives1_idx` (`Collectives_idCollective` ASC) VISIBLE,
  CONSTRAINT `fk_Collectives_has_Performers_Collectives1`
    FOREIGN KEY (`Collectives_idCollective`)
    REFERENCES `mydb`.`collectives` (`idCollective`),
  CONSTRAINT `fk_Collectives_has_Performers_Performers1`
    FOREIGN KEY (`Performers_idPerformer`)
    REFERENCES `mydb`.`performers` (`idPerformer`));



-- -----------------------------------------------------
-- Table `mydb`.`releases`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`releases` (
  `idReleases` INT NOT NULL AUTO_INCREMENT,
  `Name` VARCHAR(45) NULL DEFAULT NULL,
  `Type` VARCHAR(45) NULL DEFAULT NULL,
  `Date` VARCHAR(45) NULL DEFAULT NULL,
  `Cover Art` BLOB NULL DEFAULT NULL,
  PRIMARY KEY (`idReleases`))
ENGINE = InnoDB
AUTO_INCREMENT = 6
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `mydb`.`collectives_has_releases`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`collectives_has_releases` (
  `Collectives_idCollective` INT NOT NULL,
  `Releases_idReleases` INT NOT NULL,
  PRIMARY KEY (`Collectives_idCollective`, `Releases_idReleases`),
  INDEX `fk_Collectives_has_Releases_Releases1_idx` (`Releases_idReleases` ASC) VISIBLE,
  INDEX `fk_Collectives_has_Releases_Collectives1_idx` (`Collectives_idCollective` ASC) VISIBLE,
  CONSTRAINT `fk_Collectives_has_Releases_Collectives1`
    FOREIGN KEY (`Collectives_idCollective`)
    REFERENCES `mydb`.`collectives` (`idCollective`),
  CONSTRAINT `fk_Collectives_has_Releases_Releases1`
    FOREIGN KEY (`Releases_idReleases`)
    REFERENCES `mydb`.`releases` (`idReleases`));



-- -----------------------------------------------------
-- Table `mydb`.`listeners`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`listeners` (
  `idListeners` INT NOT NULL AUTO_INCREMENT,
  `Nickname` VARCHAR(45) NULL DEFAULT NULL,
  PRIMARY KEY (`idListeners`));



-- -----------------------------------------------------
-- Table `mydb`.`post`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`post` (
  `idPost` INT NOT NULL AUTO_INCREMENT,
  `Text` LONGTEXT NULL DEFAULT NULL,
  `DateTime` DATETIME NULL DEFAULT NULL,
  `Listeners_idListeners` INT NOT NULL,
  PRIMARY KEY (`idPost`),
  INDEX `fk_Post_Listeners1_idx` (`Listeners_idListeners` ASC) VISIBLE,
  CONSTRAINT `fk_Post_Listeners1`
    FOREIGN KEY (`Listeners_idListeners`)
    REFERENCES `mydb`.`listeners` (`idListeners`));



-- -----------------------------------------------------
-- Table `mydb`.`comments`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`comments` (
  `idComments` INT NOT NULL AUTO_INCREMENT,
  `Text` LONGTEXT NULL DEFAULT NULL,
  `DateTime` DATETIME NULL DEFAULT NULL,
  `Post_idPost` INT NOT NULL,
  `Listeners_idListeners` INT NOT NULL,
  PRIMARY KEY (`idComments`),
  INDEX `fk_Comments_Post_idx` (`Post_idPost` ASC) VISIBLE,
  INDEX `fk_Comments_Listeners1_idx` (`Listeners_idListeners` ASC) VISIBLE,
  CONSTRAINT `fk_Comments_Listeners1`
    FOREIGN KEY (`Listeners_idListeners`)
    REFERENCES `mydb`.`listeners` (`idListeners`),
  CONSTRAINT `fk_Comments_Post`
    FOREIGN KEY (`Post_idPost`)
    REFERENCES `mydb`.`post` (`idPost`));



-- -----------------------------------------------------
-- Table `mydb`.`genres`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`genres` (
  `idGenres` INT NOT NULL AUTO_INCREMENT,
  `Name` VARCHAR(45) NULL DEFAULT NULL,
  `Description` MEDIUMTEXT NULL DEFAULT NULL,
  PRIMARY KEY (`idGenres`))
;


-- -----------------------------------------------------
-- Table `mydb`.`listeners_has_collectives`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`listeners_has_collectives` (
  `Listeners_idListeners` INT NOT NULL,
  `Collectives_idCollective` INT NOT NULL,
  PRIMARY KEY (`Listeners_idListeners`, `Collectives_idCollective`),
  INDEX `fk_Listeners_has_Collectives_Collectives1_idx` (`Collectives_idCollective` ASC) VISIBLE,
  INDEX `fk_Listeners_has_Collectives_Listeners1_idx` (`Listeners_idListeners` ASC) VISIBLE,
  CONSTRAINT `fk_Listeners_has_Collectives_Collectives1`
    FOREIGN KEY (`Collectives_idCollective`)
    REFERENCES `mydb`.`collectives` (`idCollective`),
  CONSTRAINT `fk_Listeners_has_Collectives_Listeners1`
    FOREIGN KEY (`Listeners_idListeners`)
    REFERENCES `mydb`.`listeners` (`idListeners`))
;


-- -----------------------------------------------------
-- Table `mydb`.`listeners_has_performers`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`listeners_has_performers` (
  `Listeners_idListeners` INT NOT NULL,
  `Performers_idPerformer` INT NOT NULL,
  PRIMARY KEY (`Listeners_idListeners`, `Performers_idPerformer`),
  INDEX `fk_Listeners_has_Performers_Performers1_idx` (`Performers_idPerformer` ASC) VISIBLE,
  INDEX `fk_Listeners_has_Performers_Listeners1_idx` (`Listeners_idListeners` ASC) VISIBLE,
  CONSTRAINT `fk_Listeners_has_Performers_Listeners1`
    FOREIGN KEY (`Listeners_idListeners`)
    REFERENCES `mydb`.`listeners` (`idListeners`),
  CONSTRAINT `fk_Listeners_has_Performers_Performers1`
    FOREIGN KEY (`Performers_idPerformer`)
    REFERENCES `mydb`.`performers` (`idPerformer`))
;


-- -----------------------------------------------------
-- Table `mydb`.`playlists`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`playlists` (
  `idPlaylists` INT NOT NULL AUTO_INCREMENT,
  `Name` VARCHAR(45) NULL DEFAULT NULL,
  `Description` MEDIUMTEXT NULL DEFAULT NULL,
  `Author_id` INT NOT NULL,
  PRIMARY KEY (`idPlaylists`),
  INDEX `fk_Playlists_Listeners1_idx` (`Author_id` ASC) VISIBLE,
  CONSTRAINT `fk_Playlists_Listeners1`
    FOREIGN KEY (`Author_id`)
    REFERENCES `mydb`.`listeners` (`idListeners`));



-- -----------------------------------------------------
-- Table `mydb`.`listeners_has_playlists`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`listeners_has_playlists` (
  `Listeners_idListeners` INT NOT NULL,
  `Playlists_idPlaylists` INT NOT NULL,
  PRIMARY KEY (`Listeners_idListeners`, `Playlists_idPlaylists`),
  INDEX `fk_Listeners_has_Playlists_Playlists1_idx` (`Playlists_idPlaylists` ASC) VISIBLE,
  INDEX `fk_Listeners_has_Playlists_Listeners1_idx` (`Listeners_idListeners` ASC) VISIBLE,
  CONSTRAINT `fk_Listeners_has_Playlists_Listeners1`
    FOREIGN KEY (`Listeners_idListeners`)
    REFERENCES `mydb`.`listeners` (`idListeners`),
  CONSTRAINT `fk_Listeners_has_Playlists_Playlists1`
    FOREIGN KEY (`Playlists_idPlaylists`)
    REFERENCES `mydb`.`playlists` (`idPlaylists`));



-- -----------------------------------------------------
-- Table `mydb`.`listeners_has_releases`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`listeners_has_releases` (
  `Listeners_idListeners` INT NOT NULL,
  `Releases_idReleases` INT NOT NULL,
  PRIMARY KEY (`Listeners_idListeners`, `Releases_idReleases`),
  INDEX `fk_Listeners_has_Releases_Releases1_idx` (`Releases_idReleases` ASC) VISIBLE,
  INDEX `fk_Listeners_has_Releases_Listeners1_idx` (`Listeners_idListeners` ASC) VISIBLE,
  CONSTRAINT `fk_Listeners_has_Releases_Listeners1`
    FOREIGN KEY (`Listeners_idListeners`)
    REFERENCES `mydb`.`listeners` (`idListeners`),
  CONSTRAINT `fk_Listeners_has_Releases_Releases1`
    FOREIGN KEY (`Releases_idReleases`)
    REFERENCES `mydb`.`releases` (`idReleases`));



-- -----------------------------------------------------
-- Table `mydb`.`tracks`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`tracks` (
  `idTracks` INT NOT NULL AUTO_INCREMENT,
  `Name` TINYTEXT NULL DEFAULT NULL,
  `Duration` TIME NULL DEFAULT NULL,
  `Releases_idReleases` INT NOT NULL,
  PRIMARY KEY (`idTracks`),
  INDEX `fk_Tracks_Releases1_idx` (`Releases_idReleases` ASC) VISIBLE,
  CONSTRAINT `fk_Tracks_Releases1`
    FOREIGN KEY (`Releases_idReleases`)
    REFERENCES `mydb`.`releases` (`idReleases`))
ENGINE = InnoDB
AUTO_INCREMENT = 32
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `mydb`.`listeners_has_tracks`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`listeners_has_tracks` (
  `Listeners_idListeners` INT NOT NULL,
  `Tracks_idTracks` INT NOT NULL,
  PRIMARY KEY (`Listeners_idListeners`, `Tracks_idTracks`),
  INDEX `fk_Listeners_has_Tracks_Tracks1_idx` (`Tracks_idTracks` ASC) VISIBLE,
  INDEX `fk_Listeners_has_Tracks_Listeners1_idx` (`Listeners_idListeners` ASC) VISIBLE,
  CONSTRAINT `fk_Listeners_has_Tracks_Listeners1`
    FOREIGN KEY (`Listeners_idListeners`)
    REFERENCES `mydb`.`listeners` (`idListeners`),
  CONSTRAINT `fk_Listeners_has_Tracks_Tracks1`
    FOREIGN KEY (`Tracks_idTracks`)
    REFERENCES `mydb`.`tracks` (`idTracks`));



-- -----------------------------------------------------
-- Table `mydb`.`media`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`media` (
  `idMedia` INT NOT NULL AUTO_INCREMENT,
  `Name` VARCHAR(45) NULL DEFAULT NULL,
  `Link` MEDIUMTEXT NULL DEFAULT NULL,
  `Collectives_idCollective` INT,
  `Performers_idPerformer` INT,
  PRIMARY KEY (`idMedia`),
  CONSTRAINT `fk_Media_Collectives1`
    FOREIGN KEY (`Collectives_idCollective`)
    REFERENCES `mydb`.`collectives` (`idCollective`),
  CONSTRAINT `fk_Media_Performers1`
    FOREIGN KEY (`Performers_idPerformer`)
    REFERENCES `mydb`.`performers` (`idPerformer`));



-- -----------------------------------------------------
-- Table `mydb`.`playlists_has_tracks`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`playlists_has_tracks` (
  `Playlists_idPlaylists` INT NOT NULL,
  `Tracks_idTracks` INT NOT NULL,
  PRIMARY KEY (`Playlists_idPlaylists`, `Tracks_idTracks`),
  INDEX `fk_Playlists_has_Tracks_Tracks1_idx` (`Tracks_idTracks` ASC) VISIBLE,
  INDEX `fk_Playlists_has_Tracks_Playlists1_idx` (`Playlists_idPlaylists` ASC) VISIBLE,
  CONSTRAINT `fk_Playlists_has_Tracks_Playlists1`
    FOREIGN KEY (`Playlists_idPlaylists`)
    REFERENCES `mydb`.`playlists` (`idPlaylists`),
  CONSTRAINT `fk_Playlists_has_Tracks_Tracks1`
    FOREIGN KEY (`Tracks_idTracks`)
    REFERENCES `mydb`.`tracks` (`idTracks`))
;


-- -----------------------------------------------------
-- Table `mydb`.`releases_has_genres`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`releases_has_genres` (
  `Releases_idReleases` INT NOT NULL,
  `Genres_idGenres` INT NOT NULL,
  PRIMARY KEY (`Releases_idReleases`, `Genres_idGenres`),
  CONSTRAINT `fk_Releases_has_Genres_Genres1`
    FOREIGN KEY (`Genres_idGenres`)
    REFERENCES `mydb`.`genres` (`idGenres`),
  CONSTRAINT `fk_Releases_has_Genres_Releases1`
    FOREIGN KEY (`Releases_idReleases`)
    REFERENCES `mydb`.`releases` (`idReleases`))
;


-- -----------------------------------------------------
-- Table `mydb`.`releases_has_performers`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`releases_has_performers` (
  `Releases_idReleases` INT NOT NULL,
  `Performers_idPerformer` INT NOT NULL,
  PRIMARY KEY (`Releases_idReleases`, `Performers_idPerformer`),
  CONSTRAINT `fk_Releases_has_Performers_Performers1`
    FOREIGN KEY (`Performers_idPerformer`)
    REFERENCES `mydb`.`performers` (`idPerformer`),
  CONSTRAINT `fk_Releases_has_Performers_Releases1`
    FOREIGN KEY (`Releases_idReleases`)
    REFERENCES `mydb`.`releases` (`idReleases`));
    
INSERT INTO collectives (Name, Description) VALUES 
('The Chariot ', 'american metalcore band from Douglassville, Georgia'),
('Led Zeppelin', 'Classic british rock-band'),
('black midi', 'Experimental british rock band');

INSERT INTO performers (Name, Description) VALUES
('Emma Ruth Randle','folk rock singer'),
('Tricky','british trip-hop pioneer');

INSERT INTO releases (Name, Type, Date) VALUES
('Orpheus looking back','EP', '2022.03.25'),
('The Fiancee', 'Album', '2007.04.03'),
('Cavalcade', 'Album', '2021.05.28'),
('Maxinquaye', 'Album', '1995.02.20'),
('Led Zeppelin III', 'Album', '1970.10.05');


INSERT INTO tracks (Name, Duration, Releases_idReleases) VALUES
('Gilded Cage', '00:02:36', 6),
('Pump Organ Song', '00:03:14', 6),
('St. Non', '00:02:51', 6),

('Overcome', '00:04:28', 9),
('Ponderosa', '00:03:30', 9),
('Black Steel', '00:05:39', 9),
('Hell Is Round The Corner', '00:03:46', 9),
('Pumpkin', '00:04:30', 9),
('Aftermath', '00:07:37', 9),
('Abbaon Fat Tracks', '00:04:26', 9),
("Brand New You're Retro", '00:02:54', 9),
('Suffocated Love', '00:04:52', 9),
("You Don't", '00:04:39', 9),
("Strugglin'", '00:06:38', 9),
('Feed Me', '00:04:02', 9),

('Back To Back', '00:01:33', 7),
('They Faced Each Other', '00:02:01', 7),
('They Drew Their Swords', '00:02:31', 7),
('And Shot Each Other', '00:04:00', 7),
('The Deaf Policeman', '00:02:43', 7),
('Heard This Noise', '00:02:44', 7),
('Then Came To Kill', '00:05:00', 7),
('The Two Dead Boys', '00:02:36', 7),
('Forgive Me Nashville', '00:03:11', 7),
('The Trumpet', '00:03:17', 7),

('Immigrant Song', '00:02:26', 10),
('Friends', '00:03:55', 10),
('Celebration Day', '00:03:29', 10),
("Since I've Been Loving You", '00:07:25', 10),
('Out On The Tiles', '00:04:04', 10),
('Gallows Pole', '00:04:58', 10),
('Tangerine', '00:03:12', 10),
("That's The Way", '00:05:38', 10),
('Bron-Y-Aur Stomp', '00:04:20', 10),
('Hats Off To (Roy) Harper', '00:03:41', 10),

('John L', '00:05:13', 8),
('Marlene Dietrich', '00:02:53', 8),
('Chondromalacia Patella', '00:04:49', 8),
('Slow', '00:05:37', 8),
('Diamond Stuff', '00:06:20', 8),
('Dethroned', '00:05:02', 8),
('Hogwash and Balderdash', '00:02:32', 8),
('Ascending Forth', '00:09:53', 8);

INSERT INTO genres (Name, Description) VALUES 
('Classic Rock', 'Primarly commercially successful blues-rock and hard-rock'),
('Metalcore', 'Style, which combines hardcore punk and extreme metal'),
('Trip-hop', 'a fusion of hip-hop and electronic music'),
('Experimental', 'diverse music styles, which push wisting boundaries and genres definitions'),
('folk rock', 'a hybrid of fol and rock music');

/*
INSERT INTO media (Name, Link, Collectives_idCollective, Performers_idPerformer) VALUES
('','','',''),
('','','',''),
('','','',''),
('','','',''),
('','','',''),
('','','',''),
('','','','');
*/

INSERT INTO listeners (Nickname) VALUES 
('GigachadMagnificent'),
('TheGreatFloppa'),
('SlowpockVirgin'),
('SomeOtherGuy');




