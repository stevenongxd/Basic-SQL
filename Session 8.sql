USE FishingMania

--1
SELECT
FishermanID,
FishermanName
FROM MsFisherman
WHERE FishermanID IN ('FS001', 'FS003', 'FS011')

--2
SELECT
FishName,
FishPrice
FROM MsFish
JOIN MsFishType ON MsFish.FishTypeID = MsFishType.FishTypeID
WHERE FishTypeName NOT IN ('Marlin', 'Grouper', 'Bass')

--3
-- SUBQUERY METHOD
SELECT CustomerName, CustomerEmail
FROM MsCustomer
WHERE CustomerGender = 'Male' AND CustomerID NOT IN (
	SELECT DISTINCT 
	CustomerID 
	FROM TransactionHeader
	)

-- JOIN METHOD
SELECT
CustomerName,
CustomerEmail
FROM MsCustomer
LEFT JOIN TransactionHeader ON MsCustomer.CustomerID = TransactionHeader.CustomerID
WHERE CustomerGender = 'Male' AND TransactionHeader.CustomerID IS NULL

--4
-- SUBQUERY METHOD 2 JOIN
SELECT
FishTypeName,
FishName,
FishPrice
FROM MsFishType ft
JOIN MsFish mf ON ft.FishTypeID = mf.FishTypeID
JOIN TransactionDetail td on mf.FishID = td.FishID
WHERE TransactionID IN (
	SELECT TransactionID 
	FROM TransactionHeader 
	WHERE DATENAME(QUARTER, TransactionDate) = 2 
	AND YEAR(TransactionDate) = 2020
	AND TransactionHeader.CustomerID IN (
		SELECT CustomerID
		FROM MsCustomer
		WHERE CustomerGender = 'Female'
	)
)

-- SUBQUERY METHOD 3 JOIN
SELECT
FishTypeName,
FishName,
FishPrice
FROM MsFishType ft
JOIN MsFish mf ON ft.FishTypeID = mf.FishTypeID
JOIN TransactionDetail td on mf.FishID = td.FishID
JOIN TransactionHeader th on td.TransactionID = td.TransactionID
WHERE DATENAME(QUARTER, TransactionDate) = 2 
AND YEAR(TransactionDate) = 2020
AND CustomerID IN (
	SELECT CustomerID
	FROM MsCustomer
	WHERE CustomerGender = 'Female'
	)

-- FULL SUBQUERY
SELECT
FishTypeName,
FishName,
FishPrice
FROM MsFishType ft
JOIN MsFish mf ON ft.FishTypeID = mf.FishTypeID
WHERE FishID IN (
	SELECT FishID
	FROM TransactionDetail
	WHERE TransactionID IN (
		SELECT TransactionID
		FROM TransactionHeader
		WHERE DATENAME(QUARTER, TransactionDate) = 2 
		AND YEAR(TransactionDate) = 2020
		AND CustomerID IN (
			SELECT CustomerID
			FROM MsCustomer
			WHERE CustomerGender = 'Female'
			)
		)
	)

--5
SELECT
CustomerName,
CONVERT(VARCHAR, TransactionDate, 106) AS 'Transaction Date'
FROM MsCustomer
JOIN TransactionHeader ON MsCustomer.CustomerID = TransactionHeader.CustomerID
WHERE EXISTS (
	SELECT *
	FROM TransactionDetail
	JOIN MsFish ON TransactionDetail.FishID = MsFish.FishID
	WHERE FishPrice > 35 
	AND TransactionDetail.TransactionID = TransactionHeader.TransactionID
	)

--6
SELECT
CustomerName,
CustomerGender,
CustomerEmail
FROM MsCustomer
WHERE CustomerID IN (
	SELECT CustomerID 
	FROM TransactionHeader
	JOIN MsFisherman mf2 ON TransactionHeader.FishermanID = mf2.FishermanID
	WHERE FishermanGender = 'Female'
	AND EXISTS (
		SELECT *
		FROM MsFisherman mf3
		WHERE LEFT(FishermanName, 1) = 'L' 
		OR LEFT(FishermanName, 1) = 'R'
		AND mf3.FishermanID = mf2.FishermanID
		)
	)

--7
SELECT
mc.CustomerID,
mc.CustomerName
FROM MsCustomer mc
WHERE mc.CustomerID IN (
	SELECT CustomerID
	FROM MsCustomer
	WHERE CustomerGender = 'Male'
	AND NOT EXISTS (
		SELECT FishTypeName
		FROM MsFishType
		WHERE FishTypeName = 'Tuna'
		)
	)

--8
-- ALIAS SUBQUERY
SELECT
FishName,
FishTypeName,
FishPrice
FROM MsFish
JOIN MsFishType ON MsFish.FishTypeID = MsFishType.FishTypeID,
(SELECT 'AverageFishPrice' = AVG(FishPrice) FROM MsFish ) AS [Virtual Table]
WHERE FishPrice > AverageFishPrice

-- SUBQUERY
SELECT
FishName,
FishTypeName,
FishPrice
FROM MsFish
JOIN MsFishType ON MsFish.FishTypeID = MsFishType.FishTypeID
WHERE FishPrice > (
	SELECT AVG(FishPrice)
	FROM MsFish
	)

--9
SELECT
mf.FishName,
mf.FishPrice
FROM MsFish mf
WHERE mf.FishID IN (
	SELECT mf2.FishID
	FROM MsFish mf2, (
	SELECT
		[Highest Price] = MAX(mf3.FishPrice),
		[Lowest Price] = MIN(mf3.FishPrice)
		FROM MsFish mf3
		) AS subquery
	WHERE mf2.FishPrice = subquery.[Highest Price] 
	OR mf2.FishPrice = subquery.[Lowest Price]
	)

--10
SELECT
CustomerName,
CustomerEmail,
[Fish Type Variant] = COUNT(*)
FROM MsCustomer mc
JOIN TransactionHeader th ON mc.CustomerID = th.CustomerID
JOIN TransactionDetail td ON th.TransactionID = td.TransactionID
JOIN MsFish mf ON td.FishID = mf.FishID
JOIN MsFishType ft ON mf.FishTypeID = ft.FishTypeID, (
	SELECT 
	FishTypeName 
	FROM MsFishType
	WHERE COUNT(td.FishID) 
	)