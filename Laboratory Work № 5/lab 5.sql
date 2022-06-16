-- -----------------------------------------------------
-- Lab 5
-- -----------------------------------------------------
USE `mydb`;

-- DATA GENERATION

-- collectives generation
LOAD DATA INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\mydb collectives.csv' INTO TABLE collectives FIELDS 
TERMINATED BY ',' ENCLOSED BY ',' LINES TERMINATED BY '\n'
(Name,Description);
LOAD DATA INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\mydb collectives2.csv' INTO TABLE collectives FIELDS 
TERMINATED BY ',' ENCLOSED BY ',' LINES TERMINATED BY '\n'
(Name,Description);
SELECT * FROM collectives; -- generated id generated id from 11 to 3000

-- performers generation
LOAD DATA INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\mydb performers.csv' INTO TABLE performers FIELDS 
TERMINATED BY ',' ENCLOSED BY ',' LINES TERMINATED BY '\n'
(Name,Description);
LOAD DATA INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\mydb performers2.csv' INTO TABLE performers FIELDS 
TERMINATED BY ',' ENCLOSED BY ',' LINES TERMINATED BY '\n'
(Name,Description);
SELECT * FROM performers; -- generated id from 34 to 10056

-- genres generation
LOAD DATA INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\mydb genres.csv' INTO TABLE genres FIELDS 
TERMINATED BY ',' ENCLOSED BY ',' LINES TERMINATED BY '\n'
(Name,Description);
SELECT * FROM genres; -- generated id from 6 to 10005

-- listeners generation
LOAD DATA INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\mydb listeners.csv' INTO TABLE listeners FIELDS 
TERMINATED BY ',' ENCLOSED BY ',' LINES TERMINATED BY '\n'
(Nickname);
SELECT * FROM listeners; -- generated id from 5 to 10004

-- playlists generation
LOAD DATA INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\mydb playlists.csv' INTO TABLE playlists FIELDS 
TERMINATED BY ',' ENCLOSED BY ',' LINES TERMINATED BY '\n'
(Name, Description, Author_id);
SELECT * FROM playlists; -- generated id from 1 to 10000

-- releases generation
LOAD DATA INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\mydb releases.csv' INTO TABLE releases FIELDS 
TERMINATED BY ',' ENCLOSED BY ',' LINES TERMINATED BY '\n'
(Name, Type, Date);
SELECT * FROM releases; -- generated id from 11 to 3000 (id 10 missed somehow)

-- tracks generation
LOAD DATA INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\mydb tracks.csv' INTO TABLE tracks FIELDS 
TERMINATED BY ',' ENCLOSED BY ',' LINES TERMINATED BY '\n'
(Name, Duration, Releases_idReleases);
SELECT * FROM tracks; -- generated id from 77 to 10076 (75, 79 missed)

-- posts generation
LOAD DATA INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\mydb post.csv' INTO TABLE post FIELDS 
TERMINATED BY ',' ENCLOSED BY ',' LINES TERMINATED BY '\n'
(Text,DateTime,Listeners_idListeners);
SELECT * FROM post; -- generated id from 3 to 3002

-- comments generation
LOAD DATA INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\mock track\\mydb comment2 (9).csv' INTO TABLE comments FIELDS 
TERMINATED BY ',' ENCLOSED BY ',' LINES TERMINATED BY '\n'
(Text,DateTime,Post_idPost,Listeners_idListeners);
SELECT * FROM comments; -- generated id from 171 to 8394 (8-170 missed somewhere)

-- MANY TO MANY

-- releases_has_genres generation
LOAD DATA INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\mydb genresreleases.csv' INTO TABLE releases_has_genres FIELDS 
TERMINATED BY ',' ENCLOSED BY ',' LINES TERMINATED BY '\n'
(Releases_idReleases,Genres_idGenres);
SELECT * FROM releases_has_genres; -- 9997 lines generated

-- listeners_has_tracks generation
LOAD DATA INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\mydb listeners_has_tracks.csv' INTO TABLE listeners_has_tracks FIELDS 
TERMINATED BY ',' ENCLOSED BY ',' LINES TERMINATED BY '\n'
(Listeners_idListeners, Tracks_idTracks);
SELECT * FROM listeners_has_tracks; -- 10000 lines generated

-- listeners_has_releases generation
LOAD DATA INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\mydb listeners_has_releases.csv' INTO TABLE listeners_has_releases FIELDS 
TERMINATED BY ',' ENCLOSED BY ',' LINES TERMINATED BY '\n'
(Listeners_idListeners, Releases_idReleases);
SELECT * FROM listeners_has_releases; -- 10000 lines generated

-- listeners_has_collectives generation
LOAD DATA INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\mydb listeners_has_collectives.csv' INTO TABLE listeners_has_collectives FIELDS 
TERMINATED BY ',' ENCLOSED BY ',' LINES TERMINATED BY '\n'
(Listeners_idListeners, Collectives_idCollective);
SELECT * FROM listeners_has_collectives; -- 3000 lines generated

-- listeners_has_performers generation
LOAD DATA INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\mydb listeners_has_performers.csv' INTO TABLE listeners_has_performers FIELDS 
TERMINATED BY ',' ENCLOSED BY ',' LINES TERMINATED BY '\n'
(Listeners_idListeners, Performers_idPerformer);
SELECT * FROM listeners_has_performers; -- 9991 lines generated

-- collectives_has_performers generation
LOAD DATA INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\mydb collectives_has_performers.csv' INTO TABLE collectives_has_performers FIELDS 
TERMINATED BY ',' ENCLOSED BY ',' LINES TERMINATED BY '\n'
(Collectives_idCollective, Performers_idPerformer, EnterDate, QuitDate);
SELECT * FROM collectives_has_performers; -- 10000 lines generated

-- collectives_has_releases generation
LOAD DATA INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\mydb collectives_has_releases.csv' INTO TABLE collectives_has_releases FIELDS 
TERMINATED BY ',' ENCLOSED BY ',' LINES TERMINATED BY '\n'
(Collectives_idCollective, Releases_idReleases);
SELECT * FROM collectives_has_releases; -- 9993 lines generated

-- performers_has_releases generation NOT DONE YET
LOAD DATA INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\mydb listeners_has_tracks.csv' INTO TABLE listeners_has_tracks FIELDS 
TERMINATED BY ',' ENCLOSED BY ',' LINES TERMINATED BY '\n'
(performers_idPerformers, Releases_idReleases);
SELECT * FROM listeners_has_tracks; -- 10000 lines generated


-- INDEXES 			
-- Drop index IndexName ON TableName;

-- 1. Показать «любимые» треки
-- 2. Найти трек по части названия
CREATE INDEX TracksName ON Tracks(Name);
 
-- 3. Просмотреть дату выпуска релиза
CREATE INDEX ReleasesName ON releases(Name);

-- 4. Показать количество слушателей коллектива
CREATE INDEX CollectivesName ON collectives(Name);

-- 5. Вывести все посты и их комментарии за заданный промежуток времени и приджойнить авторов
CREATE INDEX PostDateTime ON Post(DateTime);
CREATE INDEX CommentDateTime ON Comments(DateTime);

-- 6. Для всех коллективов вывести всех участников, через group concat, которые на текущий момент состоят в группе
CREATE INDEX collectives_has_performers_quit ON collectives_has_performers(QuitDate);



-- PROCEDURES
-- 1 Output All user's posts and comments
DELIMITER $$
CREATE PROCEDURE users_posts_n_comments(IN idListener INT)
BEGIN
  SELECT "Post" as "", listeners.Nickname, post.text, post.DateTime, post.idPost as idPost FROM post
  INNER JOIN listeners ON listeners.idListeners = post.Listeners_idListeners
  WHERE listeners.idListeners = idListener
  UNION
  SELECT "Comment", listeners.Nickname, comments.text, comments.DateTime, comments.Post_idPost as idPost FROM comments
  INNER JOIN listeners ON listeners.idListeners = comments.Listeners_idListeners
  WHERE listeners.idListeners = idListener
  ORDER BY idPost, DateTime;
END $$
DELIMITER ;
CALL users_posts_n_comments(2);



-- 2 output all authors of track (both collectives and performers)
DELIMITER $$
CREATE PROCEDURE tracks_authors(IN track_name VARCHAR(100))
BEGIN
    SELECT tracks.Name, performers.Name FROM tracks
    INNER JOIN performers_has_releases ON performers_has_releases.Releases_idReleases = tracks.Releases_idReleases
    INNER JOIN performers ON performers.idPerformer = performers_has_releases.performers_idPerformers
    WHERE tracks.Name = track_name
    UNION ALL
    SELECT tracks.Name, collectives.Name FROM tracks
    INNER JOIN collectives_has_releases ON collectives_has_releases.Releases_idReleases = tracks.Releases_idReleases
    INNER JOIN collectives ON collectives.idCollective = collectives_has_releases.Collectives_idCollective
    WHERE tracks.Name = track_name;
END $$
DELIMITER ;
DROP PROCEDURE tracks_authors;
CALL tracks_authors('Back To Back');

-- 3 OUTPUT TOP-N
DELIMITER $$
CREATE PROCEDURE top(IN tableName VARCHAR(50), N int)
BEGIN
    IF (tableName = 'genres') THEN 
			(SELECT * FROM genres_adds
			ORDER BY Adds DESC LIMIT N);
	end if;
	IF (tableName = 'tracks') THEN 
			(SELECT * FROM tracks_adds
			ORDER BY Adds DESC LIMIT N);
	end if;
	IF (tableName = 'releases') THEN 
			(SELECT * FROM releases_adds
			ORDER BY Adds DESC LIMIT N);
	end if;
END $$
DELIMITER ;

CALL top ('releases', 5);

-- FUNCTIONS
-- 1 Counts release's whole duration
delimiter $$
CREATE FUNCTION release_duration( ReleaseName VARCHAR (45) )
RETURNS TIME
DETERMINISTIC
BEGIN
    RETURN (SELECT SEC_TO_TIME(SUM(TIME_TO_SEC(Duration))) as Duration FROM releases
    INNER JOIN tracks ON tracks.Releases_idReleases = releases.idReleases
	WHERE releases.Name = ReleaseName
    );
end $$
delimiter ;

SELECT release_duration('The Fiancee');

-- 2 Counts num of tracks in release
delimiter $$
CREATE FUNCTION release_num_of_tracks( ReleaseName VARCHAR (45) )
RETURNS INT
DETERMINISTIC
BEGIN
    RETURN (SELECT COUNT(*) as Num_Of_Tracks FROM releases
    INNER JOIN tracks ON tracks.Releases_idReleases = releases.idReleases
	WHERE releases.Name = ReleaseName
    );
end $$
delimiter ;
SELECT release_num_of_tracks('The Fiancee');

-- 3
delimiter $$
CREATE FUNCTION current_members_in_collective( collective_name VARCHAR (100) )
RETURNS INT 
DETERMINISTIC
BEGIN
    RETURN (
    SELECT COUNT(*) FROM collectives_has_performers
    INNER JOIN collectives ON collectives.idCollective = collectives_has_performers.Collectives_idCollective
    WHERE collectives.Name = collective_name AND collectives_has_performers.QuitDate = 0
    );
end $$
delimiter ;
DROP FUNCTION track_find;
SELECT current_members_in_collective('black midi');
SELECT current_members_in_collective('The Pink Floyd');
SELECT current_members_in_collective('Norma Jean');

-- VIEW
-- 1 number of genres adds
CREATE VIEW genres_adds AS
SELECT genres.name, COUNT(listeners_has_releases.Listeners_idListeners) as Adds FROM genres
INNER JOIN releases_has_genres ON releases_has_genres.Genres_idGenres = genres.idGenres
INNER JOIN releases ON releases.idReleases = releases_has_genres.Releases_idReleases
INNER JOIN listeners_has_releases ON listeners_has_releases.Releases_idReleases = releases.idReleases
GROUP BY genres.name;
SELECT * FROM genres_adds;

-- 2 number of tracks adds
CREATE VIEW tracks_adds AS
SELECT tracks.Name, COUNT(Listeners_idListeners) as Adds FROM tracks
INNER JOIN listeners_has_tracks ON listeners_has_tracks.Tracks_idTracks = tracks.idTracks
GROUP BY tracks.Name;
SELECT * FROM tracks_adds;

-- 3 number of releases adds
CREATE VIEW releases_adds AS
SELECT releases.Name, COUNT(listeners_has_releases.Listeners_idListeners) as Adds FROM releases
INNER JOIN listeners_has_releases ON listeners_has_releases.Releases_idReleases = releases.idReleases
GROUP BY releases.Name;
SELECT * FROM releases_adds;


-- TRIGGER

delimiter $$
CREATE TRIGGER if_release_by_collective_than_release_by_all_members
AFTER INSERT
ON collectives_has_releases
FOR EACH ROW
BEGIN
	INSERT INTO performers_has_releases (performers_idPerformers, Releases_idReleases)
	(
    SELECT collectives_has_performers.Performers_idPerformer, new.Releases_idReleases 
	FROM collectives_has_performers
	LEFT JOIN releases ON new.Releases_idReleases = releases.idReleases
	WHERE
	new.Collectives_idCollective = collectives_has_performers.Collectives_idCollective
	and ((collectives_has_performers.QuitDate = 0 AND releases.Date BETWEEN collectives_has_performers.EnterDate AND current_date())
	OR releases.Date BETWEEN collectives_has_performers.EnterDate AND collectives_has_performers.QuitDate)
    );
END $$
delimiter ;


DROP TRIGGER if_release_by_collective_than_release_by_all_members;

INSERT INTO releases (Name, Type, Date) VALUES
("One Wing", "Album", "2012-08-12");

INSERT INTO collectives_has_releases (Collectives_idCollective, Releases_idReleases) VALUES
(1, 16394);
DELETE FROM collectives_has_releases
WHERE Collectives_idCollective = 1 AND Releases_idReleases = 16394;




-- Modification
-- 1. Триггер - когда слушатель добавляет (лайкает) трек, пусть автоматом лайкает его релиз этого трека
delimiter $$
CREATE TRIGGER if_like_track_then_like_release
AFTER INSERT
ON listeners_has_tracks
FOR EACH ROW
BEGIN 
INSERT INTO listeners_has_releases (Listeners_idListeners, Releases_idReleases)
(
	SELECT new.Listeners_idListeners, new.Tracks_idTracks FROM tracks
    WHERE tracks.idTracks = new.Tracks_idTracks
);
END$$
delimiter $$;


DROP TRIGGER if_like_track_then_like_release;

DELETE FROM listeners_has_releases
WHERE Listeners_idListeners = 1 AND Releases_idReleases = 2;
DELETE FROM listeners_has_releases
WHERE Listeners_idListeners = 1 AND Releases_idReleases = 3;

INSERT INTO listeners_has_tracks(Listeners_idListeners, Tracks_idTracks) VALUES
(1, 67);

-- 2. Процедура: 
--    принимает: ListenersID 
--    возвращает: количество лайков этого пользователя (4 параметра: треки, релизы, коллективы + перформеры, плейлисты) 
DELIMITER $$
CREATE PROCEDURE listeners_likes(
IN ListenerID INT,
OUT tracks_likes INT,
OUT releases_likes INT,
OUT collectives_likes INT,
OUT performers_likes INT
)
BEGIN
	SELECT COUNT(*) as Num FROM listeners_has_tracks 
    WHERE listeners_has_tracks.Listeners_idListeners = ListenerID
    INTO tracks_likes;
	SELECT COUNT(*) as Num FROM listeners_has_releases
    WHERE listeners_has_releases.Listeners_idListeners = ListenerID
    INTO releases_likes;
	SELECT COUNT(*) as Num FROM listeners_has_collectives
    WHERE listeners_has_collectives.Listeners_idListeners = ListenerID
    INTO collectives_likes;
	SELECT COUNT(*) as Num FROM listeners_has_performers
    WHERE listeners_has_performers.Listeners_idListeners = ListenerID
    INTO performers_likes;
END $$
DELIMITER ;

SET @tracks_likes := 0,
	@releases_likes := 0,
	@collectives_likes := 0,
	@performers_likes := 0;
CALL listeners_likes(3, @tracks_likes, @releases_likes, @collectives_likes, @performers_likes);
SELECT @tracks_likes, @releases_likes, @collectives_likes, @performers_likes;


-- 3. Составной индекс использовать в запросе, выводящем названия релизов заданного типа, выпущенные в промежутке между некоторыми датами
-- CREATE INDEX 
SELECT * FROM releases
WHERE Type = 'Album' AND Date BETWEEN "1970-01-01" AND "1980-01-01";

CREATE INDEX type_n_date ON releases(Type, Date);


