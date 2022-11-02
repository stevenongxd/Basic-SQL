--1
CREATE VIEW ViewFemaleCoupon
AS
SELECT
CustomerName,
[Coupon] = STUFF(CustomerID, 1, 2, '#')
FROM MsCustomer
WHERE CustomerGender = 'Female'
AND YEAR(CustomerDOB) = 2020

--2
CREATE VIEW ViewCustomerMembership
AS
SELECT
[Name] = CustomerName,
[Gender] = CustomerGender,
[Email] = SUBSTRING(CustomerEmail,1 ,CHARINDEX('@', CustomerEmail)) + 'fmania.com',
[Address] = CustomerAddress
FROM MsCustomer
WHERE CustomerAddress LIKE '[0-9][0-9] %'

--3
CREATE VIEW ViewTuna
AS
SELECT
FishName,
ft.FishTypeName,
[Price] = '$' + CAST(FishPrice AS varchar)
FROM MsFish mf
JOIN MsFishType ft ON mf.FishTypeID = ft.FishTypeID
WHERE FishPrice BETWEEN 12 AND 16
AND FishTypeName = 'Tuna'

--4
CREATE VIEW ViewCustomerTransaction
AS
SELECT
mc.CustomerName,
[NumberOfTransaction] = COUNT(*)
FROM MsCustomer mc
JOIN TransactionHeader th ON mc.CustomerID = th.CustomerID
WHERE CustomerGender = 'Male'
GROUP BY CustomerName

--5
CREATE VIEW ViewMostExpensiveTransaction
AS
SELECT TOP (3)
th.TransactionID,
mc.CustomerName,
th.TransactionDate,
[Money Spent] = SUM(FishPrice * Quantity)
FROM MsCustomer mc 
JOIN TransactionHeader th ON mc.CustomerID = th.CustomerID
JOIN TransactionDetail td ON th.TransactionID = td.TransactionID
JOIN MsFish mf ON td.FishID = mf.FishID
GROUP BY th.TransactionID, mc.CustomerName, th.TransactionDate
ORDER BY SUM(FishPrice * Quantity) DESC

--6
CREATE VIEW ViewYearlyIncomePerTypeIn2020
AS
SELECT
[Year] = YEAR(TransactionDate),
FishTypeName,
[Income] = SUM(FishPrice * Quantity)
FROM TransactionHeader th
JOIN TransactionDetail td ON th.TransactionID = td.TransactionID
JOIN MsFish mf ON td.FishID = mf.FishID
JOIN MsFishType ft ON mf.FishTypeID = ft.FishTypeID
WHERE YEAR(TransactionDate) = 2020
GROUP BY YEAR(TransactionDate), FishTypeName

--7
CREATE VIEW ViewNonGrouperTransaction
AS
SELECT
CustomerName,
[NumberOfTransaction] = COUNT(*)
FROM MsCustomer mc
JOIN TransactionHeader th ON mc.CustomerID = th.CustomerID
WHERE TransactionID NOT IN (
	SELECT TransactionID
	FROM TransactionDetail td
	JOIN MsFish mf ON td.FishID = mf.FishID
	JOIN MsFishType ft ON mf.FishTypeID = ft.FishTypeID
	WHERE FishTypeName = 'Grouper'
	)
GROUP BY CustomerName

--8
CREATE VIEW ViewVIPCustomer
AS
SELECT
CustomerName,
SUM(FishPrice * Quantity) AS MoneySpent
FROM MsCustomer mc 
JOIN TransactionHeader th ON mc.CustomerID = th.CustomerID
JOIN TransactionDetail td ON th.TransactionID = td.TransactionID
JOIN MsFish mf ON td.FishID = mf.FishID
GROUP BY CustomerName
HAVING SUM(FishPrice * Quantity) > (
	SELECT
	[Rata] = AVG(y.MoneySpent)
	FROM (
		SELECT
		CustomerName,
		SUM(FishPrice * Quantity) AS MoneySpent
		FROM MsCustomer mc 
		JOIN TransactionHeader th ON mc.CustomerID = th.CustomerID
		JOIN TransactionDetail td ON th.TransactionID = td.TransactionID
		JOIN MsFish mf ON td.FishID = mf.FishID
		GROUP BY CustomerName
	) y
)

--9
CREATE VIEW ViewFavoriteFishType
AS
SELECT
FishTypeName,
COUNT(DISTINCT TransactionID) AS TotalTransaction
FROM TransactionDetail td
JOIN MsFish mf ON td.FishID = mf.FishID
JOIN MsFishType ft ON mf.FishTypeID = ft.FishTypeID
GROUP BY FishTypeName
HAVING COUNT(DISTINCT TransactionID) > (
	
	SELECT AVG(sq1.TotalTransaction)
	FROM (
		SELECT
		COUNT(DISTINCT TransactionID) AS TotalTransaction
		FROM TransactionDetail td
		JOIN MsFish mf ON td.FishID = mf.FishID
		JOIN MsFishType ft ON mf.FishTypeID = ft.FishTypeID
		GROUP BY FishTypeName
	)sq1
)
--10
DROP VIEW ViewYearlyIncomePerTypeIn2020