-- -----------------------------------------------------
-- Schema flower shop
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS flowerDB;
USE flowerDB ;

CREATE TABLE IF NOT EXISTS orders (
	idOrders INT NOT NULL AUTO_INCREMENT,
	SellerName VARCHAR(45) NULL DEFAULT NULL,
	DateTime DATETIME NULL DEFAULT NULL,
	PRIMARY KEY (idOrders)
);

CREATE TABLE IF NOT EXISTS bouquets (
	idBouquets INT NOT NULL AUTO_INCREMENT,
	Name VARCHAR(45) NULL DEFAULT NULL,
	Description VARCHAR(100) NULL DEFAULT NULL,
	Complexity INT DEFAULT NULL,
    Price FLOAT DEFAULT NULL,
    PRIMARY KEY (idBouquets)
);

CREATE TABLE IF NOT EXISTS flowers (
	idFlowers INT NOT NULL AUTO_INCREMENT,
	Name VARCHAR(45) NULL DEFAULT NULL,
	Size INT NULL DEFAULT NULL,
	Color VARCHAR(50) DEFAULT NULL,
    Price FLOAT DEFAULT NULL,
    PRIMARY KEY (idFlowers)
);

CREATE TABLE IF NOT EXISTS Orders_have_Bouquets (
  idBouquets INT NOT NULL,
  idOrders INT NOT NULL,
  PRIMARY KEY (idBouquets, idOrders),
  INDEX idBouquetsInd (idBouquets ASC) VISIBLE,
  INDEX idOrdersInd   (idOrders ASC) VISIBLE,
  CONSTRAINT idBouquetsKey
    FOREIGN KEY (idBouquets)
    REFERENCES bouquets (idBouquets),
  CONSTRAINT idOrdersKey
    FOREIGN KEY (idOrders)
    REFERENCES orders (idOrders));
    
CREATE TABLE IF NOT EXISTS Bouquets_have_Flowers (
  idBouquets INT NOT NULL,
  idFlowers INT NOT NULL,
  PRIMARY KEY (idBouquets, idFlowers),
  INDEX idBouquetsInd (idBouquets ASC) VISIBLE,
  INDEX idFlowersInd   (idFlowers ASC) VISIBLE,
  CONSTRAINT idBouquetsKey2
    FOREIGN KEY (idBouquets)
    REFERENCES bouquets (idBouquets),
  CONSTRAINT idFlowersKey
    FOREIGN KEY (idFlowers)
    REFERENCES Flowers (idFlowers));
    
    
-- INSERTING DATA

INSERT INTO orders (SellerName, DateTime) VALUES 
('Diane', '2000-01-03 05:06'),
('Diane', '2000-01-12 08:59'),
('Diane', '2000-01-04 13:42'),
('Diane', '2000-01-02 14:50'),
('John',  '2000-01-09 19:00'),
('John',  '2000-02-25 15:00');

-- order for 2000-01-08
INSERT INTO orders (SellerName, DateTime) VALUES 
('Diane', '2000-01-08 05:06'),
('Diane', '2000-01-08 08:59'),
('Diane', '2000-01-08 13:42'),
('Diane', '2000-01-08 14:50'),
('John',  '2000-01-08 19:00'),
('Diane', '2000-01-08 05:06'),
('Diane', '2000-01-08 08:59'),
('Diane', '2000-01-08 13:42'),
('Diane', '2000-01-08 14:50'),
('John',  '2000-01-08 19:00'),
('John',  '2000-01-08 15:00');

INSERT INTO bouquets (Name, Description, Complexity, Price) VALUES 
('Tenderness', 'fgvsefd', 5, 50),
('Passion', 'fdgvsreg', 6, 50),
('Luxury', 'fzvdzvsfdzv', 9, 50),
('Rapture', 'dhydtby', 7, 50),
('Sadness', 'dsnbyhdff', 6, 50);

INSERT INTO flowers (Name, Size, Color, Price) VALUES 
('rose white', 4, 'white', 200),
('rose black', 4, 'black', 300),
('rose red', 4, 'red', 150),
('ehrysanthemum', 2, 'pink', 100),
('eustoma', 3, 'white', 200),
('lilies', 2, 'yellow', 150);

INSERT INTO orders_have_bouquets (idBouquets, idOrders) VALUES 
(2, 1),
(5, 2),
(4, 2),
(1, 3),
(3, 4),
(5, 4),
(1, 5),
(3, 6);

-- orders for 2000-01-08
INSERT INTO orders_have_bouquets (idBouquets, idOrders) VALUES 
(1, 7),
(5, 8),
(4, 8),
(4, 9),
(1, 10),
(3, 11),
(5, 11),
(5, 12),
(1, 13),
(2, 14),
(1, 15),
(5, 16),
(3, 17);

INSERT INTO bouquets_have_flowers (idBouquets, idFlowers) VALUES 
(1, 1),
(1, 4),
(1, 5),
(2, 4),
(2, 3),
(3, 3),
(3, 5),
(4, 1),
(4, 5),
(5, 2);

    
-- QUERYS

-- 1. Output all bouquets with given Complexity
SELECT Name, Complexity, Price FROM bouquets
WHERE Complexity = 6 AND Description Like "%ff%";

-- 2. Output TOP-5 of all flowers, sorted by size in bouquets with given complexity
SELECT flowers.Name, Size, flowers.Price, flowers.color FROM flowers
INNER JOIN bouquets_have_flowers ON flowers.idFlowers = bouquets_have_flowers.idFlowers
INNER JOIN bouquets ON bouquets.idBouquets = bouquets_have_flowers.idBouquets
WHERE Complexity = 5
ORDER BY Size DESC LIMIT 5;

-- 3. Output average complexity of bouquets, made by given seller BETWEEN 01.01.2000 AND 05.01.2000
SELECT orders.SellerName, AVG(bouquets.Complexity) as Average_complexity FROM orders
INNER JOIN orders_have_bouquets ON orders.idOrders = orders_have_bouquets.idOrders
INNER JOIN bouquets ON bouquets.idBouquets = orders_have_bouquets.idBouquets
WHERE orders.SellerName = "Diane" AND orders.DateTime BETWEEN "2000-01-01 00:00" AND "2000-01-05 23:59"
GROUP BY orders.SellerName;

-- 4. Sum Price of orders of given seller in 08.01.2000
SELECT sum_price.SellerName, SUM(sum_price.Price) as 'Sum for a day' FROM
	(SELECT orders.SellerName, orders.idOrders, SUM(flowers.Price) as Price FROM orders -- sum price of flowers for every order
	INNER JOIN orders_have_bouquets ON orders.idOrders = orders_have_bouquets.idOrders
	INNER JOIN bouquets ON bouquets.idBouquets = orders_have_bouquets.idBouquets
	INNER JOIN bouquets_have_flowers ON bouquets.idBouquets = bouquets_have_flowers.idFlowers
	INNER JOIN flowers ON flowers.idFlowers = bouquets_have_flowers.idBouquets
	WHERE SellerName = 'Diane' AND orders.DateTime BETWEEN "2000-01-08 00:00" AND "2000-01-08 23:59"
	GROUP BY orders.idOrders
	UNION ALL
	SELECT orders.SellerName, orders.idOrders, SUM(bouquets.Price) as Price FROM orders -- sum price of packing for every order
	INNER JOIN orders_have_bouquets ON orders.idOrders = orders_have_bouquets.idOrders
	INNER JOIN bouquets ON bouquets.idBouquets = orders_have_bouquets.idBouquets
	INNER JOIN bouquets_have_flowers ON bouquets.idBouquets = bouquets_have_flowers.idFlowers
	INNER JOIN flowers ON flowers.idFlowers = bouquets_have_flowers.idBouquets
	WHERE SellerName = 'Diane' AND orders.DateTime BETWEEN "2000-01-08 00:00" AND "2000-01-08 23:59"
	GROUP BY orders.idOrders) as sum_price
GROUP BY sum_price.SellerName;


SELECT orders.SellerName, orders.idOrders, SUM(flowers.Price) as Price FROM orders -- sum price of flowers for every order
	INNER JOIN orders_have_bouquets ON orders.idOrders = orders_have_bouquets.idOrders
	INNER JOIN bouquets ON bouquets.idBouquets = orders_have_bouquets.idBouquets
	INNER JOIN bouquets_have_flowers ON bouquets.idBouquets = bouquets_have_flowers.idFlowers
	INNER JOIN flowers ON flowers.idFlowers = bouquets_have_flowers.idBouquets
	WHERE SellerName = 'Diane' AND orders.DateTime BETWEEN "2000-01-08 00:00" AND "2000-01-08 23:59"
	GROUP BY orders.idOrders
	UNION ALL
	SELECT orders.SellerName, orders.idOrders, SUM(bouquets.Price) as Price FROM orders -- sum price of packing for every order
	INNER JOIN orders_have_bouquets ON orders.idOrders = orders_have_bouquets.idOrders
	INNER JOIN bouquets ON bouquets.idBouquets = orders_have_bouquets.idBouquets
	INNER JOIN bouquets_have_flowers ON bouquets.idBouquets = bouquets_have_flowers.idFlowers
	INNER JOIN flowers ON flowers.idFlowers = bouquets_have_flowers.idBouquets
	WHERE SellerName = 'Diane' AND orders.DateTime BETWEEN "2000-01-08 00:00" AND "2000-01-08 23:59"
	GROUP BY orders.idOrders;