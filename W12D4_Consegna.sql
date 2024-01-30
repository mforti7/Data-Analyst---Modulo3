CREATE DATABASE W12D4_Consegna;
USE W12D4_Consegna;


-- TASK 2: Implementazione tabella Product
CREATE TABLE Product (
    ProductID INT,
    ProductName NVARCHAR(50),
    ProductCategory NVARCHAR(50),
	Sold BIT
	CONSTRAINT PK_ProductID PRIMARY KEY (ProductID)
);

-- TASK 2: Implementazione tabella Region
CREATE TABLE Region (
    RegionID INT,
    RegionName NVARCHAR(50),
    CountryName NVARCHAR(50)
	CONSTRAINT PK_RegionID PRIMARY KEY (RegionID)
);

-- TASK 2: Implementazione tabella Sales
CREATE TABLE Sales (
    SalesID INT,
    ProductID INT,
    RegionID INT,
    OrderDate DATE,
    OrderQuantity INT,
    UnitPrice DECIMAL(10, 2),
    SalesAmount DECIMAL(10, 2),
    FOREIGN KEY (ProductID) REFERENCES Product(ProductID),
    FOREIGN KEY (RegionID) REFERENCES Region(RegionID)
);


-- TASK 3: Popolamento tabella Product
INSERT INTO Product (ProductID, ProductName, ProductCategory, Sold) 
VALUES 
(1, 'Puzzle', 'Toys', 1),
(2, 'Skates', 'Sport', 1),
(3, 'Bicycle', 'Sport', 1),
(4, 'Lego', 'Toys', 0),
(5, 'Soccer ball', 'Sport', 0);

-- TASK 3: Popolamento tabella Region
INSERT INTO Region (RegionID, RegionName, CountryName)
VALUES 
(1, 'SouthEurope', 'Italy'),
(2, 'WestEurope', 'Germany'),
(3, 'NorthAmerica', 'USA'),
(4, 'SouthAmerica', 'Brazil'),
(5, 'Asia', 'China');

-- TASK 3: Popolamento tabella Sales
INSERT INTO Sales (SalesID, ProductID, RegionID, OrderDate, OrderQuantity, UnitPrice, SalesAmount)
VALUES 
(1, 1, 1, '2018-04-22', 2, 10.00, 20.00),
(2, 2, 1, '2019-01-05', 1, 75.00, 75.00),
(3, 3, 5, '2019-06-07', 1, 100.00, 100.00),
(4, 2, 4, '2020-02-17', 3, 75.00, 225.00),
(5, 3, 4, '2020-11-08', 5, 100.00, 500.00),
(6, 4, NULL, NULL, NULL, 15.00, NULL),
(7, 1, 1, '2021-05-19', 1, 10.00, 10.00),
(8, 5, NULL, NULL, NULL, 20.00, NULL),
(9, 1, 2, '2021-09-07', 3, 10.00, 30.00),
(10, 2, 3, '2021-12-02', 4, 75.00, 300.00);

SELECT * FROM Product
SELECT * FROM Region
SELECT * FROM Sales


/* TASK 4.1:	Verificare che i campi definiti come PK siano univoci. In altre parole, scrivi una query per 
				determinare l’univocità dei valori di ciascuna PK (una query per tabella implementata). */
SELECT COUNT(*), ProductID
FROM Product
GROUP BY ProductID
HAVING COUNT(*)>1

SELECT COUNT(*), RegionID
FROM Region
GROUP BY RegionID
HAVING COUNT(*)>1

SELECT COUNT(*), SalesID
FROM Sales
GROUP BY SalesID
HAVING COUNT(*)>1

/* TASK 4.2:	Esporre l’elenco delle transazioni indicando nel result set il codice documento, la data, il nome del prodotto, 
				la categoria del prodotto, il nome dello stato, il nome della regione di vendita e un campo booleano valorizzato 
				in base alla condizione che siano passati più di 180 giorni dalla data vendita o meno (>180 -> True, <= 180 -> False) */
SELECT s.SalesID, s.OrderDate, p.ProductName, p.ProductCategory, r.CountryName, r.RegionName,
		CASE 
			WHEN DATEDIFF(DAY, s.OrderDate, GETDATE()) > 180 THEN 'True'
			ELSE 'False'
		END AS MoreThan180
FROM Sales AS s
INNER JOIN Product AS p
ON s.ProductID = p.ProductID
INNER JOIN Region AS r
ON s.RegionID = r.RegionID

-- TASK 4.3: Esporre l’elenco dei soli prodotti venduti e per ognuno di questi il fatturato totale per anno
SELECT p.ProductID, p.ProductName, p.ProductCategory, YEAR(s.OrderDate) AS Anno, SUM(s.SalesAmount) AS Fatturato
FROM Sales AS s
INNER JOIN Product AS p
ON s.ProductID = p.ProductID
WHERE p.Sold = 1
GROUP BY p.ProductID, p.ProductName, p.ProductCategory, YEAR(s.OrderDate)

-- TASK 4.4: Esporre il fatturato totale per stato per anno. Ordina il risultato per data e per fatturato decrescente
SELECT r.CountryName, YEAR(s.OrderDate) AS Anno, SUM(s.SalesAmount) AS Fatturato
FROM Sales AS s
INNER JOIN Region AS r
ON s.RegionID = r.RegionID
GROUP BY r.CountryName, YEAR(s.OrderDate), s.SalesAmount
ORDER BY YEAR(s.OrderDate), SUM(s.SalesAmount) DESC

-- TASK 4.5: Rispondere alla seguente domanda: qual è la categoria di articoli maggiormente richiesta dal mercato?
SELECT p.ProductCategory, COUNT(s.ProductID) AS TotalSales
FROM Product AS p
INNER JOIN Sales AS s 
ON p.ProductID = s.ProductID
GROUP BY p.ProductCategory
ORDER BY COUNT(s.ProductID) DESC

-- TASK 4.6: Rispondere alla seguente domanda: quali sono, se ci sono, i prodotti invenduti? Proponi due approcci risolutivi differenti
SELECT p.ProductID, p.ProductName, p.ProductCategory
FROM Product AS p
WHERE Sold = 0

SELECT p.ProductID, p.ProductName, p.ProductCategory
FROM Product AS p
LEFT JOIN Sales AS s 
ON p.ProductID = s.ProductID
WHERE s.SalesAmount IS NULL;

-- TASK 4.7: Esporre l’elenco dei prodotti con la rispettiva ultima data di vendita (la data di vendita più recente)
SELECT p.ProductID, p.ProductName, s1.OrderDate
FROM Sales AS s1
INNER JOIN Product AS p
ON s1.ProductID = p.ProductID
WHERE s1.OrderDate = (
		SELECT MAX(OrderDate)
		FROM Sales AS s2
		WHERE s1.ProductID = s2.ProductID)
ORDER BY ProductID

-- TASK 4.8: Creare una vista sui prodotti in modo tale da esporre una “versione denormalizzata” delle informazioni utili (codice prodotto, nome prodotto, nome categoria)
CREATE VIEW ProductInfo AS
SELECT	p.ProductID, p.ProductName, p.ProductCategory
FROM Product AS p;

SELECT * FROM ProductInfo

-- TASK 4.9: Creare una vista per restituire una versione “denormalizzata” delle informazioni geografiche
CREATE VIEW RegionInfo AS
SELECT	r.RegionID, r.RegionName, r.CountryName
FROM Region AS r

SELECT * FROM RegionInfo

--------------------
SELECT * FROM Sales
SELECT * FROM Product
SELECT * FROM Region

