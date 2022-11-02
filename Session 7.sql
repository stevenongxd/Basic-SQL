USE FishingMania

--1
SELECT
[Maximum Price] = MAX(FishPrice),
[Minimum Price] = MIN(FishPrice),
[Average Price] = ROUND(AVG(FishPrice), 1)
FROM MsFish

--2
SELECT 
FishTypeName, 
[Average Price] = CONCAT('$', ROUND(AVG(FishPrice), 1))
FROM MsFishType
JOIN  MsFish ON MsFishType.FishTypeID = MsFish.FishTypeID
GROUP BY FishTypeName

--3
SELECT 
FishermanName, 
[Number of Transaction] = COUNT(*)
FROM MsFisherman
JOIN TransactionHeader ON MsFisherman.FishermanID = TransactionHeader.FishermanID
WHERE LEFT(FishermanName, 1) NOT IN ('C', 'D')
GROUP BY FishermanName

--4
SELECT 
[Month] = MONTH(TransactionDate), 
[Total Transacton per Month] = COUNT(*)
FROM TransactionHeader
WHERE YEAR(TransactionDate) = 2020
GROUP BY MONTH(TransactionDate)

--5
SELECT 
FishTypeName, 
[Total Fish Variant] = COUNT(*) 
FROM MsFishType
JOIN MsFish ON MsFishType.FishTypeID = MsFishType.FishTypeID 
GROUP BY FishTypeName
ORDER BY [Total Fish Variant] DESC

--6
SELECT 
[Month] = MONTH(TransactionDate), 
[Total Monthly Revenue] = '$' + CAST(SUM(FishPrice * Quantity) AS varchar)
FROM TransactionHeader
JOIN TransactionDetail ON TransactionHeader.TransactionID = TransactionDetail.TransactionID
JOIN MsFish ON TransactionDetail.FishID = MsFish.FishID
WHERE YEAR(TransactionDate) = 2020
GROUP BY MONTH(TransactionDate)
HAVING SUM(FishPrice * Quantity) >= 600

--7
SELECT 
[ID] = REPLACE(ft.FishTypeID, 'FT', 'Fish Type '), 
FishTypeName, 
[Total Transaction Per Type] = CONCAT(COUNT(DISTINCT TransactionID), ' Transaction')	
FROM MsFishType ft
JOIN MsFish f ON f.FishTypeID = ft.FishTypeID
JOIN TransactionDetail td ON td.FishID = f.FishID
GROUP BY ft.FishTypeID, FishTypeName 
HAVING COUNT(*) > 4
ORDER BY [Total Transaction Per Type] ASC

--8
SELECT 
CustomerName,
[Year] = YEAR(TransactionDate),
FishTypeID,
[Total Yearly Spending Per Type] = SUM(FishPrice * Quantity)
FROM MsCustomer JOIN TransactionHeader th ON MsCustomer.CustomerID = th.CustomerID
JOIN TransactionDetail td ON th.TransactionID = td.TransactionID
JOIN MsFish ON td.FishID = MsFish.FishID
GROUP BY CustomerName, YEAR(TransactionDate), FishTypeID
HAVING SUM(FishPrice * Quantity) >= 500

--9
SELECT TOP(5)
FishName,
[Revenue] = SUM(FishPrice * Quantity)
FROM MsFish JOIN TransactionDetail td ON MsFish.FishID = td.FishID
GROUP BY FishName
ORDER BY [Revenue] DESC

--10
SELECT
TransactionDate,
CustomerName,
[Total Price] = SUM(FishPrice * Quantity)
FROM MsCustomer 
JOIN TransactionHeader th ON MsCustomer.CustomerID = th.CustomerID
JOIN TransactionDetail td ON th.TransactionID = td.TransactionID
JOIN MsFish ON td.FishID = MsFish.FishID
WHERE YEAR(TransactionDate) = 2020 AND MONTH(TransactionDate) = 6 AND DAY(TransactionDate) > 10
GROUP BY TransactionDate, CustomerName
ORDER BY [Total Price] DESC