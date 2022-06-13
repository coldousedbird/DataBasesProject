CREATE SCHEMA IF NOT EXISTS `scheduledb`;
USE `scheduledb` ;

CREATE TABLE IF NOT EXISTS university
(
    id   		  INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `name` 		  VARCHAR(100) NOT NULL
);

CREATE TABLE IF NOT EXISTS building
(
    id            INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `name`         VARCHAR(100) NOT NULL,
    address       VARCHAR(100) NOT NULL,
    id_university INTEGER,
    FOREIGN KEY(id_university) REFERENCES university (id) ON DELETE SET NULL
);

CREATE TABLE IF NOT EXISTS cabinet
(
    id          INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    floor       SMALLINT NOT NULL,
    _number     SMALLINT NOT NULL,
    suffix      VARCHAR(10), -- 408а, 902б, 1402-1, 1402-2, 1402-3
    id_building INTEGER,
    FOREIGN KEY (id_building) REFERENCES building (id) ON DELETE SET NULL
);

CREATE TABLE IF NOT EXISTS faculty
(
    id            INT NOT NULL AUTO_INCREMENT PRIMARY KEY,    
    `name`          VARCHAR(100) NOT NULL,
    id_university INT,
    FOREIGN KEY (id_university) REFERENCES university (id) ON DELETE SET NULL
);

CREATE TABLE IF NOT EXISTS specialization
(
    id         INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `name`       VARCHAR(100) NOT NULL,
    id_faculty INTEGER,
    FOREIGN KEY (id_faculty) REFERENCES faculty (id) ON DELETE SET NULL
);


CREATE TABLE IF NOT EXISTS _subject
(
    id                INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `name`              VARCHAR(100) NOT NULL,
    course            SMALLINT     NOT NULL,
    semester          SMALLINT     NOT NULL,
    id_specialization INTEGER,
    FOREIGN KEY (id_specialization) REFERENCES specialization (id) ON DELETE SET NULL
);

CREATE TABLE IF NOT EXISTS kafedra
(
    id         INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `name`       VARCHAR(100) NOT NULL,
    `history`    TEXT,
    id_faculty INTEGER,
    FOREIGN KEY (id_faculty) REFERENCES faculty (id) ON DELETE SET NULL
);

CREATE TABLE IF NOT EXISTS academic_rank
(
    id   INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `name` VARCHAR(100) NOT NULL
);

CREATE TABLE IF NOT EXISTS academic_degree
(
    id   INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `name` VARCHAR(100) NOT NULL
);

CREATE TABLE IF NOT EXISTS educator_post
(
    id   INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `name` VARCHAR(100) NOT NULL
);

CREATE TABLE IF NOT EXISTS educator
(
    id                 INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    name_first         VARCHAR(100) NOT NULL,
    name_second        VARCHAR(100) NOT NULL,
    name_third         VARCHAR(100) NOT NULL,
    email              VARCHAR(100),
    phone              VARCHAR(100),
    skype              VARCHAR(100),
    discord            VARCHAR(100),
    id_academic_rank INTEGER,
    FOREIGN KEY (id_academic_rank) REFERENCES academic_rank (id) ON DELETE SET NULL,
    id_academic_degree INTEGER,
    FOREIGN KEY (id_academic_degree) REFERENCES academic_degree (id) ON DELETE SET NULL,
    id_educator_post INTEGER REFERENCES educator_post (id) ON DELETE SET NULL,
    id_kafedra INTEGER REFERENCES kafedra (id) ON DELETE SET NULL
);

CREATE TABLE IF NOT EXISTS edicator_can_subject
(
    id_edicator INTEGER,
    FOREIGN KEY (id_edicator) REFERENCES educator (id) ON DELETE CASCADE,
    id_subject  INTEGER,
    FOREIGN KEY (id_subject) REFERENCES _subject (id) ON DELETE CASCADE,
    PRIMARY KEY (id_edicator, id_subject)
);


CREATE TABLE IF NOT EXISTS lesson
(
    id             INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    _type          VARCHAR(35)                 NOT NULL,
    id_educator    INTEGER,
    FOREIGN KEY (id_educator) REFERENCES educator (id) ON DELETE SET NULL,
    id_subject     INTEGER,
    FOREIGN KEY (id_subject) REFERENCES _subject (id) ON DELETE SET NULL,
    id_cabinet     INTEGER,
    FOREIGN KEY (id_cabinet) REFERENCES cabinet (id) ON DELETE SET NULL,
    datetime_start DATETIME NOT NULL,
    datetime_end   DATETIME NOT NULL,
    distant_url    VARCHAR(255)                NULL,
    home_work      TEXT,
    commentary     TEXT
    -- , CHECK ( id_cabinet IS NOT NULL OR distant_url IS NOT NULL)
);

CREATE TABLE IF NOT EXISTS `group`
(
    id                INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    _number           SMALLINT NOT NULL,
    cource            SMALLINT NOT NULL,
    id_specialization INTEGER,
    FOREIGN KEY (id_specialization) REFERENCES specialization (id) ON DELETE SET NULL
);

CREATE TABLE IF NOT EXISTS sub_group
(
    id       INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `name`     VARCHAR(100) NOT NULL,
    id__group INTEGER,
    FOREIGN KEY (id__group) REFERENCES `group` (id) ON DELETE SET NULL
);

CREATE TABLE IF NOT EXISTS sub_groups_to_lessons
(
    id_sub_group INTEGER,
    FOREIGN KEY (id_sub_group) REFERENCES sub_group (id) ON DELETE CASCADE,
    id_lessons  INTEGER,
    FOREIGN KEY (id_lessons) REFERENCES lesson (id) ON DELETE CASCADE,
    PRIMARY KEY (id_sub_group, id_lessons)
);

CREATE TABLE IF NOT EXISTS student
(
    id              INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    name_first      VARCHAR(100) NOT NULL,
    name_second     VARCHAR(100) NOT NULL,
    name_third      VARCHAR(100) NOT NULL,
    record_book_num INTEGER      NOT NULL
);

CREATE TABLE IF NOT EXISTS students_to_sub_groups
(
    id_student  INTEGER,
    FOREIGN KEY (id_student) REFERENCES student (id) ON DELETE CASCADE,
    id_sub_group INTEGER,
    FOREIGN KEY (id_sub_group) REFERENCES sub_group (id) ON DELETE CASCADE,
    PRIMARY KEY (id_student, id_sub_group)
);

CREATE TABLE IF NOT EXISTS attendance
(
    id         INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    points     SMALLINT,
    id_student INTEGER,
    FOREIGN KEY (id_student) REFERENCES student (id) ON DELETE SET NULL,
    id_lesson  INTEGER,
    FOREIGN KEY (id_lesson) REFERENCES lesson (id) ON DELETE SET NULL
);



-- ! INSERTS

INSERT INTO university (`name`)
    VALUES ('ВолгГТУ'),
           ('ВолГУ');

INSERT INTO building (id_university, `name`, address)
    VALUES (1, 'ГУК', 'г. Волгоград, Ленина 28'),
           (1, 'А', 'г. Волгоград, Советская улица, 31'),
           (1, 'Б', 'г. Волгоград, Советская улица, 29'),
           (1, 'В', 'г. Волгоград, Ленина 28А'),
           (1, 'Т', 'г. Волгоград, ул. Дегтярева, 2');

INSERT INTO cabinet (floor, _number, suffix, id_building)
    VALUES (3, 320, NULL, 1),
           (3, 323, NULL, 1),
           (4, 408, 'а', 1),
           (4, 410, 'а', 1),
           (4, 405, NULL, 2),
           (6, 605, NULL, 2),
           (12, 1201, NULL, 4),
           (14, 1402, '-1', 4),
           (14, 1402, '-3', 4),
           (8, 801, NULL, 4),
           (9, 902, 'а', 4),
           (9, 902, 'б', 4);

INSERT INTO academic_rank (`name`)
    VALUES ('Доцент'),
           ('Профессор');

INSERT INTO academic_degree (`name`)
    VALUES ('Кандидат технических наук'),
           ('Кандидат физико-математических наук'),
           ('Кандидат филологических наук'),
           ('Доктор технических наук');

INSERT INTO educator_post (`name`)
    VALUES ('Преподаватель'),
           ('Заведующий кафедрой ');

INSERT INTO faculty (`name`, id_university)
    VALUES ('ФАСТиВ', 1),
           ('ФАТ', 1),
           ('ФТКМ', 1),
           ('ФТПП', 1),
           ('ФЭУ', 1),
           ('ФЭиВТ', 1),
           ('ХТФ', 1),
           ('ФЭиУ', 1);

INSERT INTO kafedra (`name`, `history`, id_faculty)
    VALUES ('Высшая математика', 'Была создана в 1930 г. Первым заведующим был Николай Александрович Лебедев, который заведовал кафедрой более 20 лет.', 6),
           ('Вычислительная техника', 'Была создана в 1984 г.', 6),
           ('ПОАС', 'Кафедра «Программное обеспечение автоматизированных систем» открыта 1 июля 2006 г.', 6),
           ('САПРиПК', 'САПРиПК) – структурное подразделение Волгоградского государственного технического университета, входящего в состав факультета Электроники и вычислительной техники.', 6),
           ('Физика', 'История кафедры физики начинается с момента организации Тракторостроительного института 31 мая 1930 г., а ее первым руководителем был преподаватель физики рабфака Синеоков.', 6),
           ('ЭВМ и системы', 'Кафедра «ЭВМ и системы» образована в 1989 г.', 6),
           ('Электротехника', 'Кафедра «Электротехника» одна из старейших в университете. Первоначально учебный процесс по электротехническим дисциплинам обеспечивала кафедра «Энергетика», основанная в 1932 году.', 6),
           ('Иностранные языки', 'Кафедра «Иностранные языки» – ровесница самого вуза: приказ об ее открытии от 18 мая 1930 года имеет второй номер', 8);

INSERT INTO specialization (`name`, id_faculty)
    VALUES ('ИВТ', 6),
           ('ПРИН', 6),
           ('ЭР', 5),
           ('ЭМ', 5),
           ('АТ', 2);

INSERT INTO _subject (`name`, course, semester, id_specialization)
    VALUES ('Физика', 2, 2, 1),
           ('Основы программирования', 2, 1, 1),
           ('Базы данных', 2, 2, 1),
           ('Архитектура ВС', 2, 1, 1),
           ('Английский яз.', 2, 2, 1),
           ('Моделирование систем', 2, 2, 1);

INSERT INTO `group` (_number, cource, id_specialization)
    VALUES (60, 3, 1),
           (60, 2, 1),
           (61, 2, 1),
           (62, 2, 1),
           (60, 1, 1),
           (61, 1, 1);

INSERT INTO sub_group (`name`, id__group)
    VALUES ('FULL', 2),
           ('П/Г 1', 2),
           ('П/Г 2', 2),
           ('Английский Новоженина', 2),
           ('Английский Ионкина', 2),
           ('Физика Грецов', 2),
           ('Физика Харланов', 2),
           ('FULL', 1),
           ('П/Г 1', 1),
           ('П/Г 2', 1);

INSERT INTO student (name_first, name_second, name_third, record_book_num)
    VALUES ('Бессонов', 'Антон', 'Тимофеевич', 68346574),
           ('Киселев', 'Дмитрий', 'Антонович', 35403283),
           ('Латышев', 'Максим', 'Георгиевич', 51812819),
           ('Черкасова', 'Ева', 'Дмитриевна', 37210299),
           ('Кузнецов', 'Михаил', 'Тимофеевич', 39181017),
           ('Субботина', 'Алёна', 'Артёмовна', 43809895),
           ('Суслова', 'Ольга', 'Владимировна', 42903024),
           ('Зубова', 'Василиса', 'Михайловна', 73096648),
           ('Зайцев', 'Ярослав', 'Родионович', 69313276),
           ('Вавилова', 'Анна', 'Павловна', 79934291);

INSERT INTO educator (name_first, name_second, name_third, email, phone, skype, discord, id_academic_rank, id_academic_degree, id_educator_post, id_kafedra)
    VALUES ('Игорь', 'Поляков', 'Вячеславович', 'piv21841969@mail.ru', '79238217231', 'piv21841969', 'piv21841969#6210', 1, 2, 1, 5),
           ('Евгений', 'Громов', 'Геннадьевич', 'geg17281987@gmail.com', '79376955380', 'geg17281987', 'geg17281987#2381', 1, 1, 1, 3),
           ('Александр', 'Соколов', 'Александрович', 'alexander.sokolov.it@gmail.com', '79063823812', 'sashkacosmonaut', 'SashkaCosmonaut#9772', 1, 1, 1, 4),
           ('Андрей', 'Андреев', 'Евгеньевич', 'andan2005@yandex.ru', '79328312932', 'andan2005', 'andan2005#2123', 1, 1, 2, 6),
           ('Екатерина', 'Ионкина', 'Юрьевна', 'eiu85031975@inbox.ru', '79418239123', 'eiu85031975', 'eiu85031975#9231', 1, 3, 1, 8),
           ('Фоменков', 'Сергей', 'Алексеевич', 'saf@vstu.ru', '79292381273', 'saf238159', NULL, 2, 4, 1, 4),
           ('Грецов', 'Максим', 'Владимирович', NULL, '79238723821', 'mvg030768', NULL, 1, 2, 1, 5);

INSERT INTO lesson (_type, id_educator, id_subject, id_cabinet, datetime_start, datetime_end, distant_url, home_work, commentary)
    VALUES ('seminar', 5, 5, 3, '2022.03.22 11:50', '2022.03.22 13:20', NULL, 'Unit 6 ex. 6', NULL),
           ('lab', 3, 3, 9, '2022.03.23 8:30', '2022.03.23 11:40', NULL, 'Complete lab 3', NULL),
           ('lecture', 3, 3, NULL, '2022.03.25 17:00', '2022.03.25 18:30', 'https://discord.com', NULL, 'отмечаемся в eos https://eos2.vstu.ru'),
           ('lab', 2, 2, 11, '2022.04.05 8:30', '2022.04.05 11:40', NULL, 'complete lab 4', NULL),
           ('practice', 6, 6, 10, '2022.04.06 11:50', '2022.04.06 13:20', NULL, 'unit 4', NULL),
           ('practice', 1, 1, 7, '2022.04.08 10:10', '2022.04.08 11:40', NULL, 'chill', NULL),
           ('lab', 7, 1, 2, '2022.04.14 8:30', '2022.04.14 10:00', NULL, 'lab report', NULL);

INSERT INTO attendance (points, id_student, id_lesson)
    VALUES (8, 1, 2),
           (2, 4, 1),
           (7, 3, 2),
           (5, 8, 3),
           (NULL, 7, 3),
           (7, 9, 2),
           (NULL, 2, 3),
           (7, 9, 3),
           (4, 5, 1),
           (1, 6, 2);

INSERT INTO edicator_can_subject (id_edicator, id_subject)
    VALUES (1, 1),
           (2, 2),
           (3, 3),
           (4, 4),
           (5, 5),
           (6, 6);

INSERT INTO students_to_sub_groups (id_student, id_sub_group)
    VALUES (1, 1),
           (1, 2),
           (1, 4),
           (1, 6),
           (2, 1),
           (2, 3),
           (2, 4),
           (2, 6),
           (3, 1),
           (3, 2),
           (3, 5),
           (3, 6),
           (4, 1),
           (4, 3),
           (4, 4),
           (4, 6),
           (5, 8),
           (5, 9),
           (6, 8),
           (6, 9),
           (7, 8),
           (7, 9),
           (8, 8),
           (8, 10),
           (9, 8),
           (9, 9),
           (10, 8),
           (10, 10);

INSERT INTO sub_groups_to_lessons (id_sub_group, id_lessons)
    VALUES (5, 1),
           (2, 4),
           (6, 7),
           (1, 2),
           (1, 3),
           (8, 3),
           (1, 6);
           
           
RENAME TABLE edicator_can_subject TO educator_can_subject;
ALTER TABLE educator_can_subject RENAME COLUMN id_edicator TO id_educator;
RENAME TABLE _subject to `subject`;
           
-- ! MODIFICATION
-- 1. Create table educator + kafedra + post
-- 2. add atribute stavka + check 
-- 3. Only one profile subject for educator
-- 4. ???
-- 5. Profit!

CREATE TABLE IF NOT EXISTS educator_on_kafedra_on_post
(
	id_educator INTEGER,
    id_kafedra INTEGER,
    id_educator_post INTEGER,
    
    FOREIGN KEY (id_educator) REFERENCES educator (id) ON DELETE CASCADE,
    FOREIGN KEY (id_kafedra) REFERENCES kafedra (id) ON DELETE CASCADE,
    FOREIGN KEY (id_educator_post) REFERENCES educator_post (id),
        
    PRIMARY KEY (id_educator, id_kafedra)
);

ALTER TABLE educator_on_kafedra_on_post
ADD COLUMN stavka  DOUBLE NOT NULL DEFAULT 1 CHECK (stavka > 0 AND stavka <= 2);

ALTER TABLE educator_on_kafedra_on_post
DROP PRIMARY KEY,
ADD PRIMARY KEY (id_educator, id_kafedra, id_educator_post);

ALTER TABLE educator DROP COLUMN id_educator_post;
ALTER TABLE educator DROP COLUMN id_kafedra;

DROP TABLE IF EXISTS educator_can_subject;

ALTER TABLE educator 
ADD COLUMN id_profile_subject INTEGER REFERENCES educator_post (id) ON DELETE SET NULL;

ALTER TABLE educator
DROP COLUMN id_profile_subject,
ADD COLUMN id_profile_subject INTEGER, 
ADD FOREIGN KEY (id_profile_subject) REFERENCES `subject` (id) ON DELETE SET NULL;

show create table educator;
-- ! MODIFICATION END



















