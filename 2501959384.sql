USE BluejackSword

--1
GO
CREATE VIEW ViewMaleSwordProducer
AS
SELECT
SwordProducerName = CONCAT('Mr. ', SwordProducerName),
SwordProducerAddress
FROM SwordProducer
WHERE SwordProducerGender = 'Male'

--2
SELECT
CustomerName,
CustomerGender,
CustomerAddress
FROM Customer c
WHERE EXISTS (
	SELECT CustomerID
	FROM HeaderTransaction ht
	WHERE c.CustomerID = ht.CustomerID
	AND MONTH(TransactionDate) = 01
	)

--3
SELECT
c.CustomerID,
CustomerName,
CustomerDOB = CONVERT(varchar, CustomerDOB, 107),
[Total Transaction] = c.CustomerID
FROM Customer c
JOIN HeaderTransaction ht ON c.CustomerID = ht.CustomerID
WHERE TransactionID > 1
UNION
SELECT
c.CustomerID,
CustomerName,
CustomerDOB = CONVERT(varchar, CustomerDOB, 107),
[Total Transaction] = TransactionID
FROM Customer c
JOIN HeaderTransaction ht ON c.CustomerID = ht.CustomerID
WHERE DATENAME(MONTH, TransactionDate) = 'June'

--4
SELECT
ht.TransactionID,
TransactionDate = CONVERT(varchar, TransactionDate, 101),
[Total Quantity] = CAST(SUM(dt.TransactionID * Qty) AS INT)
FROM HeaderTransaction ht
JOIN DetailTransaction dt ON ht.TransactionID = dt.TransactionID
JOIN Sword s ON dt.SwordID = s.SwordID
WHERE SwordDamage > 50
AND DATENAME(YEAR, ht.TransactionDate) = 2020
GROUP BY ht.TransactionDate, ht.TransactionID

--5
SELECT
CONCAT (' Element', swordElementName) AS 'Sword Element',
SwordDamage
FROM Sword s
JOIN SwordElement se ON s.SwordElementID = se.SwordElementID
JOIN DetailTransaction dt ON s.SwordID = dt.TransactionID
JOIN HeaderTransaction ht ON dt.TransactionID = ht.TransactionID,
	(
	SELECT AVG(SwordDamage) AS SwordDamage1
	FROM Sword
	) AS sq1
WHERE SwordDamage >= sq1.SwordDamage1
AND DAY(TransactionDate) BETWEEN 5 AND 20
