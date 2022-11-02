USE FishingMania

--1
SELECT * FROM MsFishType

--2
BEGIN TRANSACTION
SELECT FishName, [Announcement] = CONCAT('Price: $', FishPrice/2, ' Just For Today!') 
FROM MsFish
WHERE FishName LIKE '%Tuna%'

ROLLBACK

--3
BEGIN TRANSACTION
SELECT 
TransactionID, 
[Day] = DAY(TransactionDate), 
[Name] = UPPER(CustomerName)
FROM TransactionHeader, MsCustomer
WHERE TransactionHeader.CustomerID = MsCustomer.CustomerID AND DATEDIFF(DAY, TransactionDate, '2020-06-23') BETWEEN 0 AND 10

ROLLBACK

--4
BEGIN TRANSACTION
SELECT CustomerName, 
[Address] = LOWER(CustomerAddress)
FROM MsCustomer
WHERE CustomerAddress LIKE '[0-9][0-9] %'

ROLLBACK

--5
BEGIN TRANSACTION
SELECT CustomerName, 
TransactionDate, 
[DayOfWeek] = LEFT(DATENAME(WEEKDAY, TransactionDate), 3)
FROM MsCustomer, TransactionHeader
WHERE MsCustomer.CustomerID = TransactionHeader.CustomerID
AND YEAR(TransactionDate) = 2020
AND MONTH(TransactionDate) = 6

ROLLBACK

--6
BEGIN TRANSACTION
SELECT TransactionID,
[LastName] = SUBSTRING(FishermanName, CHARINDEX(' ', FishermanName) + 1, LEN(FishermanName)),
TransactionDate
FROM TransactionHeader, MsFisherman
WHERE TransactionHeader.FishermanID = MsFisherman.FishermanID
AND DATEPART(QUARTER, TransactionDate) = 3

ROLLBACK

--7
BEGIN TRANSACTION
SELECT CustomerName,
[Email] = STUFF(CustomerEmail, CHARINDEX('@', CustomerEmail), LEN(CustomerEmail) + 1, 'fmania.com')
FROM MsCustomer
WHERE CustomerID IN('CU001', 'CU005', 'CU008')

ROLLBACK

--8
