USE FishingMania 

--1
SELECT FishName, FishTypeName, FishPrice 
FROM MsFish 
JOIN MsFishType ON MsFish.FishTypeID = MsFishType.FishTypeID
WHERE FishPrice > 30

--2
SELECT FishName, FishTypeName
FROM MsFish 
JOIN MsFishType ON MsFish.FishTypeID = MsFishType.FishTypeID
WHERE FishName LIKE ('%fish')

--3
SELECT DISTINCT CustomerName, CustomerAddress 
FROM MsCustomer
JOIN TransactionHeader ON MsCustomer.CustomerID = TransactionHeader.CustomerID
WHERE YEAR (TransactionDate) = 2020 AND DATENAME (WEEKDAY, TransactionDate) NOT IN ('Saturday', 'Sunday')

--4
SELECT
[New TransactionID] = STUFF(th.TransactionID, 3, 0, '00'),
[Old TransactionID] = th.TransactionID,
CustomerName,
FishermanName
FROM MsCustomer mc
JOIN TransactionHeader th ON mc.CustomerID = th.CustomerID
JOIN MsFisherman mf ON th.FishermanID = mf.FishermanID
WHERE YEAR(th.TransactionDate) = '2020' AND FishermanGender = 'Female'

--5
SELECT 
th.TransactionID,
th.TransactionDate,
mf.FishName,
[FishExpiryEstimationDate] = CONVERT(VARCHAR, DATEADD(MONTH, 1, th.TransactionDate),6)
FROM TransactionHeader th
JOIN TransactionDetail td ON th.TransactionID = td.TransactionID
JOIN MsFish mf ON td.FishID = mf.FishID
WHERE YEAR(TransactionDate) = '2021'
ORDER BY TransactionDate ASC

--6
SELECT CustomerName,
[Status] = 'Q2 2020' 
FROM MsCustomer
WHERE YEAR(MsCustomer.CustomerDOB) = '2020'
AND DATENAME(QUARTER, MsCustomer.CustomerDOB) = 2
UNION
SELECT CustomerName,
[Status] = 'Q3 2020' 
FROM MsCustomer
WHERE YEAR(MsCustomer.CustomerDOB) = '2020'
AND DATENAME(QUARTER, MsCustomer.CustomerDOB) = 3

--7
SELECT
[Name] = 'Mr.' + FishermanName, FishermanAddress
FROM MsFisherman
WHERE FishermanGender LIKE 'Male' AND FishermanAddress LIKE '[0-9][0-9][0-9] %'
UNION
SELECT
[Name] = 'Ms/Mrs.' + FishermanName, FishermanAddress
FROM MsFisherman
WHERE FishermanGender LIKE 'Female' AND FishermanAddress LIKE '[0-9][0-9][0-9] %'

--8
SELECT
FishName,
FishTypeName,
[Price Tag] = UPPER(CONCAT(LEFT(FishTypeName, 2), '-', FishPrice))
FROM MsFish mf
JOIN MsFishType ft ON mf.FishTypeID = ft.FishTypeID
WHERE FishTypeName LIKE 'Bass'
UNION
SELECT
FishName,
FishTypeName,
[Price Tag] = UPPER(CONCAT(LEFT(FishTypeName, 2), '-', FishPrice))
FROM MsFish mf
JOIN MsFishType ft ON mf.FishTypeID = ft.FishTypeID
WHERE FishTypeName LIKE 'Grouper'

--9
SELECT CustomerName
FROM MsCustomer
JOIN TransactionHeader ON MsCustomer.CustomerID = TransactionHeader.CustomerID
WHERE YEAR(TransactionDate) = '2021'
EXCEPT
SELECT CustomerName
FROM MsCustomer
JOIN TransactionHeader ON MsCustomer.CustomerID = TransactionHeader.CustomerID
WHERE YEAR(TransactionDate) = '2020'

--10
SELECT
[BestSellerMarlin] = FishName
FROM MsFish mf
JOIN MsFishType ft ON mf.FishTypeID = ft.FishTypeID
JOIN TransactionDetail td ON mf.FishID = td.FishID
JOIN TransactionHeader th ON td.TransactionID = td.TransactionID
WHERE YEAR(TransactionDate) = '2020' AND FishTypeName = 'Marlin' AND Quantity > 10
INTERSECT
SELECT
[BestSellerMarlin] = FishName
FROM MsFish mf
JOIN MsFishType ft ON mf.FishTypeID = ft.FishTypeID
JOIN TransactionDetail td ON mf.FishID = td.FishID
JOIN TransactionHeader th ON td.TransactionID = td.TransactionID
WHERE YEAR(TransactionDate) = '2021' AND FishTypeName = 'Marlin' AND Quantity > 10
