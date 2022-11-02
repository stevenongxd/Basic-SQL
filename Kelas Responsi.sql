USE MedicineStore

--1
GO
CREATE VIEW [View Medicine]
AS
SELECT
MedicineID,
MedicineName,
MedicinePrice
FROM MsMedicine
WHERE MedicinePrice < 50000

--2
GO
CREATE VIEW [ViewStaff]
AS
SELECT
StaffID,
StaffName,
StaffGender,
StafffEmail
FROM MsStaff
WHERE StaffGender = 'Male'
AND YEAR(StaffDOB) = 2000
AND DATEPART(MONTH, StaffDOB) = 7

--3
SELECT
CustomerName
FROM MsCustomer mc
WHERE CustomerGender = 'Female'
AND mc.CustomerID IN (
	SELECT CustomerID
	FROM TransactionHeader
	)

--4
SELECT
StaffName,
[TransactionID] = 'Transaction ' + SUBSTRING(th.TransactionID, 3, 3),
MedicineID
FROM MsStaff ms
JOIN TransactionHeader th ON ms.StaffID = th.StaffID
JOIN TransactionDetail td ON th.TransactionID = td.TransactionID
WHERE MedicineID NOT IN (
	SELECT MedicineID
	FROM MsMedicine mm
	JOIN MsMedicineCategory mc ON mm.MedicineCategoryID = mc.MedicineCategoryID
	WHERE mc.CategoryName IN ('Tablet')
	)

--5
-- NO ALIAS SUBQUERY
SELECT
[Customer Name] = CONCAT('Mr.', CustomerName),
th.TransactionID,
[Total Transaction] = SUM(td.Qty * MedicinePrice)
FROM MsCustomer mc
JOIN TransactionHeader th ON mc.CustomerID = th.CustomerID
JOIN TransactionDetail td ON th.TransactionID = td.TransactionID
JOIN MsMedicine mm ON td.MedicineID = mm.MedicineID
WHERE CustomerGender = 'Male'
GROUP BY CustomerName, th.TransactionID
HAVING SUM(td.Qty * MedicinePrice) > (
	SELECT MAX(MedicinePrice)
	FROM MsMedicine mm
	JOIN MsManufacturer mf ON mm.ManufacturerID = mf.ManufacturerID  
	WHERE ManufacturerAddress LIKE 'Kebon%'
	)

-- ALIAS SUBQUERY
SELECT
CONCAT('Mr.', CustomerName) AS [Customer Name],
th.TransactionID,
SUM(td.Qty * MedicinePrice) AS [Total Transaction]
FROM MsCustomer mc
JOIN TransactionHeader th ON mc.CustomerID = th.CustomerID
JOIN TransactionDetail td ON th.TransactionID = td.TransactionID
JOIN MsMedicine mm ON td.MedicineID = mm.MedicineID,
    (
    SELECT MAX(MedicinePrice) AS [MaxPrice]
    FROM MsMedicine mm
    JOIN MsManufacturer mf ON mm.ManufacturerID = mf.ManufacturerID
    WHERE ManufacturerAddress LIKE 'Kebon%'
    ) AS sq1
WHERE CustomerGender = 'Male'
GROUP BY CustomerName, th.TransactionID, sq1.MaxPrice
HAVING SUM(td.Qty * MedicinePrice) > sq1.MaxPrice

--6
SELECT
[Customer Name] = LEFT(CustomerName, (CHARINDEX(' ', CustomerName))),
CustomerEmail
FROM MsCustomer mc
WHERE CustomerEmail LIKE '%@hotmail.com'
AND CustomerID NOT IN (
	SELECT CustomerID
	FROM TransactionHeader
	)

--7
SELECT DISTINCT
CustomerID,
CustomerName
FROM MsCustomer
WHERE EXISTS (
	SELECT 
	CustomerID
	FROM TransactionHeader
	WHERE TransactionHeader.CustomerID = MsCustomer.CustomerID
	GROUP BY CustomerID
	HAVING COUNT(*) > 2
	)

--8
SELECT
TransactionID,
CONVERT(VARCHAR, TransactionDate, 106) AS 'TransactionDate',
CustomerName,
StaffName
FROM TransactionHeader
JOIN MsCustomer ON TransactionHeader.CustomerID = MsCustomer.CustomerID
JOIN MsStaff ON TransactionHeader.StaffID = MsStaff.StaffID
WHERE DATEDIFF(MONTH, '2022-08-02', TransactionDate) > 3
UNION
SELECT
TransactionID,
CONVERT(VARCHAR, TransactionDate, 106) AS 'TransactionDate',
CustomerName,
StaffName
FROM TransactionHeader
JOIN MsCustomer ON TransactionHeader.CustomerID = MsCustomer.CustomerID
JOIN MsStaff ON TransactionHeader.StaffID = MsStaff.StaffID
WHERE DATEDIFF(MONTH, TransactionDate, '2022-08-02') > 3

--9
-- NO ALIAS SUBQUERY
SELECT
MedicineID,
MedicineName,
CategoryName
FROM MsMedicine mm
JOIN MsMedicineCategory mmc ON mm.MedicineCategoryID = mmc.MedicineCategoryID
WHERE CategoryName IN ('Capsule', 'Syrup')
UNION
SELECT
MedicineID,
MedicineName,
CategoryName
FROM MsMedicine mm
JOIN MsMedicineCategory mmc ON mm.MedicineCategoryID = mmc.MedicineCategoryID
JOIN MsManufacturer mf ON mm.ManufacturerID = mf.ManufacturerID
WHERE MedicinePrice > (
	SELECT AVG(MedicinePrice)
	FROM MsMedicine
	)
AND ManufacturerAddress LIKE '% %'

-- ALIAS SUBQUERY
SELECT
MedicineID,
MedicineName,
CategoryName
FROM MsMedicine mm
JOIN MsMedicineCategory mmc ON mm.MedicineCategoryID = mmc.MedicineCategoryID
WHERE CategoryName IN ('Capsule', 'Syrup')
UNION
SELECT
MedicineID,
MedicineName,
CategoryName
FROM MsMedicine mm
JOIN MsMedicineCategory mmc ON mm.MedicineCategoryID = mmc.MedicineCategoryID
JOIN MsManufacturer mf ON mm.ManufacturerID = mf.ManufacturerID,
(
	SELECT AVG(MedicinePrice) AS AvgPrice
	FROM MsMedicine
	) AS sq1
WHERE MedicinePrice > AvgPrice
AND ManufacturerAddress LIKE '% %'

--10
SELECT
TransactionID,
[Total Price] = SUM(Qty * MedicinePrice)
FROM TransactionDetail
JOIN MsMedicine ON TransactionDetail.MedicineID = MsMedicine.MedicineID
GROUP BY TransactionID
HAVING SUM(Qty * MedicinePrice) BETWEEN 50000 AND 80000