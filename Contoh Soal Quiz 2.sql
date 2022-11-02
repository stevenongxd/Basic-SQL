USE MouseAN_Shop

--1
CREATE VIEW ViewCustomer
AS
SELECT *
FROM MsCustomer
WHERE CustomerName LIKE '% %'

--2
SELECT
CustomerID,
CustomerName
FROM MsCustomer mc
WHERE EXISTS (
	SELECT *
	FROM HeaderTransaction
	WHERE mc.CustomerID = HeaderTransaction.CustomerID
	AND DATENAME(MONTH, TransactionDate) = 'June'
)

--3
SELECT 
mc.CashierID,
mc.CashierName,
mc.CashierGender
FROM MsCashier mc
JOIN HeaderTransaction ht ON mc.CashierID = ht.CashierID
WHERE DATEDIFF(MONTH, TransactionDate, '2019-04-15') = 5
UNION
SELECT 
mc.CashierID,
mc.CashierName,
mc.CashierGender
FROM MsCashier mc
JOIN HeaderTransaction ht ON mc.CashierID = ht.CashierID
GROUP BY mc.CashierID, CashierName, CashierGender
HAVING COUNT(*) > 2

--4
SELECT
MouseName,
MousePrice = 'Rp. ' + CONVERT(VARCHAR, MousePrice),
[Total Sold] = SUM(dt.Quantity)
FROM MsMouse mm
JOIN DetailTransaction dt ON mm.MouseID = dt.MouseID
JOIN HeaderTransaction ht ON dt.TransactionID = ht.TransactionID
WHERE MouseStock <= 15 AND TransactionDate = '2018-10-15'
GROUP BY MouseName, MousePrice
ORDER BY [Total Sold] DESC

--5
SELECT
mc.CustomerID,
'LastName' = RIGHT(CustomerName, CHARINDEX(' ', REVERSE(CustomerName)) -1)
FROM MsCustomer mc
JOIN (
	SELECT
	ht.CustomerID,
	'Total Mouse Bought' = COUNT(*)
	FROM HeaderTransaction ht 
	JOIN DetailTransaction dt on ht.TransactionID = dt.TransactionID
	JOIN MsMouse mm ON mm.MouseID = dt.MouseID
	WHERE MouseName = 'K20-Basic'
	GROUP BY ht.CustomerID, ht.TransactionID
	) AS t1
ON mc.CustomerID = t1.CustomerID
ORDER BY LastName DESC