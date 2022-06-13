-- -----------------------------------------------------
-- Lab 4
-- -----------------------------------------------------
USE `mydb` ;

-- Вставка некорректных данных
INSERT INTO collectives (Name, Description) VALUES 
('Punk FLOYD', 'famous punk band'),
('LUMP BUISQIT', 'rapcore band'),
('MR.BUNGLE', 'experiment perfomance band'),
('DEATH', 'deth metal pioneers'),
('band1', 'bad');

INSERT INTO releases (Name, Type, Date) VALUES
('Stampede of the Disco Elephants', 'Album', '2030.01.01'),
('SOME DEAFAULT NAME FOR ALBUM I DUNNO', 'Album', '2331.12.15'),
('SHINE ON YOUR CRAZY GOVERNMENT', 'Album', '1968.05.12'),
('The Raging Cuteness Of The Western Huskey', 'Album', '1968.05.12'),
('ANother album', 'Album', '2000.11.11');

INSERT INTO collectives_has_releases (Collectives_idCollective, Releases_idReleases) VALUES
(4, 8), -- punk floyd 
(5, 6), -- lump buisquit
(6, 9), -- bungle
(7, 9), -- incorrect, sentenced to disposal
(4, 5), -- same
(4, 6), -- same
(4, 7); -- same

SELECT * FROM releases;
SELECT * FROM collectives;
SELECT * FROM collectives_has_releases;

-- UPDATES ----------------------------------
-- 1
UPDATE releases 
SET Name = 'The Raging Wrath Of The Easter Bunny'
WHERE Name = 'The Raging Cuteness Of The Western Huskey';
-- 2
UPDATE releases 
SET Name = 'Shine On You Crazy Diamond', 
	Date = '1975.09.15'
WHERE Name = 'SHINE ON YOUR CRAZY GOVERNMENT';
-- 3
UPDATE collectives
SET Name = 'Pink Floyd',
	Description = 'Famous progressive rock band'
WHERE Name = 'Punk FLOYD';
-- 4
UPDATE collectives
SET Name = 'Mr. Bungle'
WHERE Name = 'MR.BUNGLE';
-- 5 
UPDATE collectives
SET Name = 'Limp Bizkit'
WHERE Name = 'LUMP BUISQIT';


-- DELETES --------------------------------------
-- 1
DELETE FROM collectives_has_releases
WHERE (Collectives_idCollective = 7 AND Releases_idReleases = 9) OR
	  (Collectives_idCollective = 4 AND Releases_idReleases = 5) OR
	  (Collectives_idCollective = 4 AND Releases_idReleases = 6) OR
	  (Collectives_idCollective = 4 AND Releases_idReleases = 7);
-- 2
DELETE FROM collectives
WHERE Name = 'DEATH';
-- 3
DELETE FROM releases
WHERE Name = 'SOME DEAFAULT NAME FOR ALBUM I DUNNO';
-- 4
DELETE FROM collectives
WHERE Name = 'band1';
-- 5
DELETE FROM releases 
WHERE Name = 'ANother album';

-- --------------------------------------

-- Справочные (оперативные запросы):
-- 1.	Показать «любимые» треки, релизы, исполнителей пользователя.
-- Исполнители и коллективы
SELECT collectives.Name FROM listeners_has_collectives INNER JOIN collectives
ON Collectives_idCollective = idCollective
WHERE Listeners_idListeners = 1
UNION
SELECT performers.Name FROM listeners_has_performers INNER JOIN performers
ON Performers_idPerformer = idPerformer
WHERE Listeners_idListeners = 1;

-- Треки
SELECT tracks.Name FROM listeners_has_tracks INNER JOIN tracks
ON idTracks = Tracks_idTracks
WHERE Listeners_idListeners = 1;

-- Релизы
SELECT releases.Name FROM listeners_has_releases INNER JOIN releases
ON Releases_idReleases = idReleases
WHERE Listeners_idListeners = 1;

-- 2.	Найти трек по части названия
SELECT idTracks, Name FROM tracks
WHERE Name LIKE "%patella%";

-- 3.	Просмотреть дату выпуска релиза
SELECT Date, Name FROM releases
WHERE Name = "Cavalcade";

-- 4.	Просмотреть длительность трека
SELECT Name, Duration FROM tracks
WHERE Name = 'Aftermath';

-- 5.	Показать длительность релиза
SELECT releases.Name, SEC_TO_TIME(SUM(TIME_TO_SEC(Duration))) as Duration FROM releases 
INNER JOIN tracks ON Releases_idReleases = idReleases
WHERE idReleases = 3;

-- Аналитические запросы:
-- 1.	Показать топ-3 наиболее популярных (добавленных) треков на релизе
  -- создание таблицы со статистикой добавления треков
  CREATE TABLE IF NOT EXISTS `mydb`.`Number_of_tracks_adds` (
  `idTrack` INT NOT NULL,
  `Adds` INT NULL DEFAULT NULL,
  PRIMARY KEY (`idTrack`));
  -- заполнение статистики
  INSERT INTO Number_of_tracks_adds (idTrack, Adds) 
  SELECT Tracks_idTracks, COUNT(Listeners_idListeners) AS Adds FROM listeners_has_tracks
  GROUP BY Tracks_idTracks;
  -- вывод топ 3 по альбому №2 (The Chariot - "The Fiancee")
  SELECT tracks.Name, Number_of_tracks_adds.Adds FROM Number_of_tracks_adds 
  INNER JOIN tracks
  ON tracks.Releases_idReleases = 2 AND tracks.idTracks = Number_of_tracks_adds.idTrack
  ORDER BY Adds DESC LIMIT 3;

-- 2.	Показать релизы, выпущенные за некоторый заданный период времени (70-ые годы)
SELECT Name, Date FROM releases
WHERE Date BETWEEN "1970/01/01" AND "1980.01.01";

-- 3.	Определить исполнителя и релиз по треку
SELECT tracks.Name, releases.Name, collectives.Name FROM tracks
INNER JOIN releases ON releases.idReleases = tracks.Releases_idReleases
INNER JOIN collectives_has_releases ON collectives_has_releases.Releases_idReleases = releases.idReleases
INNER JOIN collectives	ON collectives.idCollective = collectives_has_releases.Collectives_idCollective
WHERE tracks.Name = "Tangerine";

-- 4.	Показать количество слушателей исполнителя/релиза/трека
-- количество слушателей коллектива
  SELECT collectives.Name, COUNT(listeners_has_collectives.Listeners_idListeners) AS Adds FROM listeners_has_collectives
  JOIN collectives ON listeners_has_collectives.Collectives_idCollective = collectives.idCollective
  WHERE collectives.Name = "black midi" 
  GROUP BY Collectives_idCollective;
-- количество слушателей релиза
  SELECT releases.Name, COUNT(listeners_has_releases.Listeners_idListeners) AS Adds FROM listeners_has_releases
  JOIN releases ON listeners_has_releases.Releases_idReleases = releases.idReleases
  WHERE releases.Name = "Led Zeppelin III"
  GROUP BY Releases_idReleases;
-- количество слушателей трека
  SELECT tracks.Name, COUNT(listeners_has_tracks.Listeners_idListeners) AS Adds FROM listeners_has_tracks
  JOIN tracks ON listeners_has_tracks.Tracks_idTracks = tracks.idTracks
  WHERE tracks.Name = "They Faced Each Other" 
  GROUP BY Tracks_idTracks;

-- 5.	Показать топ-3 самых популярных треков жанра
  SELECT tracks.Name, number_of_tracks_adds.Adds FROM tracks 
  INNER JOIN releases ON releases.idReleases = tracks.Releases_idReleases
  INNER JOIN releases_has_genres ON releases_has_genres.Releases_idReleases = releases.idReleases
  INNER JOIN genres ON genres.idGenres = releases_has_genres.Genres_idGenres
  INNER JOIN number_of_tracks_adds ON number_of_tracks_adds.idTrack = tracks.idTracks
  WHERE genres.Name = "Metalcore"
  ORDER BY Adds DESC LIMIT 3;

-- DISTINCT
  SELECT DISTINCT name FROM releases;

-- table number_of_release_tracks_adds
CREATE TABLE number_of_album_tracks_adds LIKE number_of_tracks_adds;
ALTER TABLE number_of_album_tracks_adds RENAME COLUMN idTrack to idReleases;
RENAME TABLE number_of_album_tracks_adds TO number_of_release_tracks_adds;
-- insert into
INSERT INTO number_of_release_tracks_adds(idReleases, Adds) 
(select releases.idReleases, SUM(number_of_tracks_adds.Adds) FROM number_of_tracks_adds
inner join tracks on tracks.idTracks = number_of_tracks_adds.idTrack
inner join releases on releases.idReleases = tracks.Releases_idReleases
GROUP BY idReleases);


-- LIKE 2
  SELECT name FROM tracks WHERE name LIKE '%trump%';
-- LIKE 3 + UNION
  SELECT name FROM tracks WHERE name LIKE '%the%'
  UNION
  SELECT name FROM releases WHERE name LIKE '%the%'
  UNION
  SELECT name FROM collectives WHERE name LIKE '%the%'
  UNION
  SELECT name FROM performers WHERE name LIKE '%the%';
-- LIKE 4 + OR 
  SELECT name FROM tracks WHERE name LIKE '%(%' OR '%)%';

  
-- MODIFICATION
-- 1. Вывести все посты и их комментарии за заданный промежуток времени и приджойнить авторов
  INSERT INTO post (Text, DateTime, Listeners_idListeners) VALUES
  ("orphantwin - Future Classic (EP) [2022]	#chaotic_metalcore | #USA Новый проект Кори Брэндана, вокалиста Norma Jean!", "2022-06-06 20:05", 1),
  ("ByoNoiseGenerator	#technical_brutal_death_metal | #jazzgrind | #Russia", "2022.06.11 19:05", 1);
  INSERT INTO comments (Text, DateTime, Post_idPost, Listeners_idListeners) VALUES
  ("Жаль не скогин(	Но послушать надо тоже))", "2022.06.06 22:50", 1, 2),
  ("А Hundred Suns всё интересно?", "2022.06.07 09:14", 1, 3),
  ("Жара!", "2022.06.09 10:00", 1, 2),
  ("ура химия", "2022.06.11 19:15", 1, 2),
  ("То чувство, когда был на концерте с этой фотографии", "2022.06.11 20:24", 2, 2),
  ("До сих пор мечтаю попасть на выступление этой группы и познакомиться с участниками,в частности с драмером. Это уровень нашей сцены, лицо страны.", "2022.06.12 6:30", 2, 3),
  ("Рома отличный человек", "2022.06.12 8:28", 2, 4);
  
  SELECT "Post" as "", listeners.Nickname, post.text, post.DateTime, post.idPost as idPost FROM post
  INNER JOIN listeners ON listeners.idListeners = post.Listeners_idListeners
  UNION
  SELECT "Comment", listeners.Nickname, comments.text, comments.DateTime, comments.Post_idPost as idPost FROM comments
  INNER JOIN listeners ON listeners.idListeners = comments.Listeners_idListeners
  ORDER BY idPost, DateTime;
  
  
-- 2. Топ 3 жанра через релизы по количеству лайков
  SELECT genres.name, COUNT(listeners_has_releases.Listeners_idListeners) as Adds FROM genres
  INNER JOIN releases_has_genres ON releases_has_genres.Genres_idGenres = genres.idGenres
  INNER JOIN releases ON releases.idReleases = releases_has_genres.Releases_idReleases
  INNER JOIN listeners_has_releases ON listeners_has_releases.Releases_idReleases = releases.idReleases
  GROUP BY genres.name
  ORDER BY Adds DESC LIMIT 3;
  
-- 3. Для всех коллективов вывести всех участников, через group concat, которые на текущий момент состоят в группе
  INSERT INTO collectives (Name, Description) VALUES
  ('Norma Jean', 'Metalcore, post-hardcore'),
  ("The '68", 'Punk rock, noise rock');
  
  INSERT INTO performers (Name, Description) VALUES
  -- Chariot
  ('Josh Scogin', "vocals"), 
  ('Stephen Harrison', "rhythm guitar, backing vocals, bass"),
  ('David Kennedy', 'drums'), 
  ('Brandon Henderson', 'guitar, backing vocals,bass '), 
  -- Norma Jean
  ('Cory Brandan', ''),
  ('Grayson Stewart', ''),
  ('Matt Marquez', ''),
  ('Phillip Farris', ''),
  ('Clay Crenshaw', ''),
  ('Josh Scogin', ''),
  ('Scottie H. Henry', ''),
  ('Jeff Hickey', ''),
  ('Chris John Day', ''),
  ('Josh Swofford', ''),
  ('Josh Doolittle', ''),
  ('Jake Schultz', ''),
  -- black midi
  ('Geordie Greep', 'lead vocals, guitar, bass'),
  ('Cameron Picton', 'lead vocals, bass, synths, samples, guitar'),
  ('Morgan Simpson', 'drums'),
  ('Matt Kwasniewski-Kelvin', 'guitar'),
  
  ('Nikko Yamada', 'drums'),
  ('Michael McClellan', 'drums'),
  
  ('Syd Barrett', 'lead and rhythm guitars, vocals'),
  ('David Gilmour', 'lead and rhythm guitars, vocals, bass, keyboards, synthesisers'),
  ('Roger Waters', 'bass, vocals, rhythm guitar, synthesisers'),
  ('Richard Wright', 'keyboards, piano, organ, synthesisers, vocals'),
  ('Nick Mason', 'drums, percussion, vocals'),
  
  ('Robert Plant', 'lead vocals, harmonica'),
  ('Jimmy Page', 'guitars, theremin, live backing vocals, production'),
  ('John Paul Jones', 'bass, keyboards, occasional backing vocals'),
  ('John Bonham', 'drums, percussion, occasional backing vocals');

  
  INSERT INTO collectives_has_performers (Collectives_idCollective, Performers_idPerformer, EnterDate, QuitDate) VALUES
  (1, 3, 2003, 2013),
  (1, 4, 2009, 2013),
  (1, 5, 2008, 2013),
  (1, 6, 2011, 2013),
  (2, 30, 1968, 1980),
  (2, 31, 1968, 1980),
  (2, 32, 1968, 1980),
  (2, 33, 1968, 1980),
  (3, 19, 2017, 0),
  (3, 20, 2017, 0),
  (3, 21, 2017, 0),
  (3, 22, 2017, 2020),
  (4, 25, 1965, 1968),
  (4, 26, 1965, 2015),
  (4, 27, 1965, 1985),
  (4, 28, 1965, 2007),
  (4, 29, 1967, 2015),
  (9, 9, 2004, 2019),
  (9, 10, 2018, 0),
  (9, 11, 2015, 0),
  (9, 12, 2010, 0),
  (9, 13, 2019, 0),
  (9, 14, 1997, 2011),
  (9, 15, 2011, 2019),
  (9, 16, 1997, 2015),
  (9, 17, 1997, 2000),
  (9, 18, 2000, 2002),
  (9, 19, 2022, 2012),
  (9, 3, 1997, 2002),
  
  (10, 3, 2013, 0),
  (10, 23, 2017, 0),
  (10, 24, 2013, 2017);

  SELECT collectives.idCollective as "id", "Collective" as "", collectives.Name, collectives.Description FROM collectives
  INNER JOIN collectives_has_performers ON collectives_has_performers.Collectives_idCollective = collectives.idCollective
  WHERE collectives_has_performers.QuitDate = 0
  UNION
  SELECT collectives_has_performers.Collectives_idCollective as "id", "Members" as "", performers.Name, performers.Description FROM performers
  INNER JOIN collectives_has_performers ON collectives_has_performers.Performers_idPerformer = performers.idPerformer
  WHERE collectives_has_performers.QuitDate = 0
  ORDER BY 1, 2;
  
  -- using GROUP_CONCAT
  SELECT collectives.Name, GROUP_CONCAT(performers.Name) as "Members" FROM collectives -- 
  INNER JOIN collectives_has_performers ON collectives_has_performers.Collectives_idCollective = collectives.idCollective
  INNER JOIN performers ON collectives_has_performers.Performers_idPerformer = performers.idPerformer
  WHERE collectives_has_performers.QuitDate = 0
  GROUP BY collectives.Name;






