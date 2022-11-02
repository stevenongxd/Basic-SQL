DROP DATABASE MetroLand
GO
CREATE DATABASE MetroLand
GO
USE MetroLand

CREATE TABLE [MsCustomer] (
	CustomerID CHAR(5) PRIMARY KEY CHECK (CustomerID LIKE 'CS[0-9][0-9][0-9]'),
	CustomerName VARCHAR(50) CONSTRAINT checkCustomerName CHECK (LEN(CustomerName) BETWEEN 5 AND 50)  NOT NULL,
	CustomerEmail VARCHAR(50) CONSTRAINT checkCustomerEmail CHECK (CustomerEmail LIKE '%@gmail.com') NOT NULL,
	CustomerAddress VARCHAR (50) CONSTRAINT checkStaffAddress NOT NULL,
	CustomerPhone VARCHAR(50) NOT NULL
)

INSERT INTO MsCustomer VALUES
('CS001', 'Steven Ong', 'song123@gmail.com', 'Sunter', '0812930284'),
('CS002', 'Aldo Kalalo', 'aldokk@gmail.com', 'Kemayoran','0812543983'),
('CS003', 'Citra', 'citra@gmail.com', 'Kemanggisan', '0812213430')

CREATE TABLE [MsStaff](
	StaffID CHAR(5) PRIMARY KEY CHECK (StaffID LIKE 'ST[0-9][0-9][0-9]'),
	StaffName VARCHAR(50) CONSTRAINT checkStaffName CHECK (LEN(StaffName) BETWEEN 5 AND 50) NOT NULL,
	StaffEmail VARCHAR(50) CONSTRAINT checkStaffEmail CHECK (StaffEmail LIKE '%@metroland.com') NOT NULL,
	StaffAddress VARCHAR(50) CONSTRAINT checkStaffAddress NOT NULL,
	StaffPhone VARCHAR(50) NOT NULL
)
INSERT INTO MsStaff VALUES
('ST001', 'Dihyan', 'dihyan@metroland.com', 'Paradise Timur', '0812568796'),
('ST002', 'Abigail', 'abigail@metroland.com', 'Bekasi', '0812214354'),
('ST003', 'Bunga', 'bunga@metroland.com', 'Bandung', '08125754723')

CREATE TABLE [MsSupplier](
	SupplierID CHAR(5) PRIMARY KEY CHECK (SupplierID LIKE 'SP[0-9][0-9][0-9]'),
	SupplierName VARCHAR(50) CONSTRAINT checkSupplierName CHECK (LEN(SupplierName) BETWEEN 5 AND 50) NOT NULL,
	SupplierAddress VARCHAR(50) CONSTRAINT checkSupplierAddress NOT NULL,
	SupplierEmail VARCHAR(50) CONSTRAINT checkSupplierEmail CHECK (SupplierEmail LIKE '%@gmail.com') NOT NULL,
	SupplierPrice INT NOT NULL
)
INSERT INTO MsSupplier VALUES
('SP001', 'Santa Workshop', 'Jakarta', 'santa.workshop@gmail.com', '5'),
('SP002', 'Surya Jaya Store', 'Bandung', 'jaya.surya@gmail.com', '10'),
('SP003', 'OurToys Workshop', 'Medan', 'ot.workshop@gmail.com', '2')

CREATE TABLE [TransactionHeader] (
	TransactionID CHAR(5) PRIMARY KEY CHECK (TransactionID LIKE 'TS[0-9][0-9][0-9]'),
	CustomerID CHAR(5) FOREIGN KEY REFERENCES MsCustomer(CustomerID) ON UPDATE CASCADE ON DELETE CASCADE NOT NULL,
	StaffID CHAR(5) FOREIGN KEY REFERENCES MsStaff(StaffID) ON UPDATE CASCADE ON DELETE CASCADE NOT NULL,
	TransactionDate DATE NOT NULL
)

INSERT INTO TransactionHeader VALUES
('TS001', 'CS001', 'ST001', '2022-01-11'),
('TS002', 'CS002', 'ST002', '2022-02-22'),
('TS003', 'CS003', 'ST003', '2022-03-30')

CREATE TABLE [MsToyType] (
	ToyTypeID CHAR(5) PRIMARY KEY CHECK (ToyTypeID LIKE 'TP[0-9][0-9][0-9]'),
	ToyTypeName VARCHAR(50) CONSTRAINT CheckToyTypeName CHECK (LEN(ToyTypeName) BETWEEN 5 AND 50) NOT NULL,
)

INSERT INTO MsToyType VALUES
('TP001', 'Puzzle'),
('TP002', 'Economy'),
('TP003', 'Puzzle')

CREATE TABLE [MsToy] (
	ToyID CHAR(5) PRIMARY KEY CHECK (ToyID LIKE 'TY[0-9][0-9][0-9]'),
	ToyTypeID CHAR(5) FOREIGN KEY REFERENCES MsToyType(ToyTypeID) ON UPDATE CASCADE ON DELETE CASCADE NOT NULL,
	SupplierID CHAR(5) FOREIGN KEY REFERENCES MsSupplier(SupplierID) ON UPDATE CASCADE ON DELETE CASCADE NOT NULL,
	ToyName VARCHAR(50) CONSTRAINT CheckToyName CHECK (LEN(ToyName) BETWEEN 5 AND 50) NOT NULL,
	ToyPrice INT NOT NULL
)

INSERT INTO MsToy VALUES
('TY001', 'TP001', 'SP001', 'Legos', 10),
('TY002', 'TP002', 'SP002', 'Monopoly', 20),
('TY003', 'TP003', 'SP003', 'Gundam', 5)

CREATE TABLE [TransactionDetail] (
	TransactionID CHAR(5) FOREIGN KEY REFERENCES TransactionHeader(TransactionID) ON UPDATE CASCADE ON DELETE CASCADE NOT NULL,
	ToyID CHAR(5) FOREIGN KEY REFERENCES MsToy(ToyID) ON UPDATE CASCADE ON DELETE CASCADE NOT NULL,
	Quantity INT NOT NULL,
	PRIMARY KEY(TransactionID, ToyID)
)

INSERT INTO TransactionDetail VALUES
('TS001', 'TY001', 90),
('TS002', 'TY002', 80),
('TS003', 'TY003', 70)

--6
SELECT
TransactionDate,
[Quantity Sold] = Quantity,
[Purchase Price] = CONCAT('$', (SupplierPrice)),
[Sales Price] = CONCAT('$', (ToyPrice)),
[Profit For Each Type] = CONCAT('$',(ToyPrice * Quantity) -  SupplierPrice),
[Profitability Percentage] = ((ToyPrice * Quantity) -  SupplierPrice) / 100
FROM TransactionDetail TD
JOIN TransactionHeader TH ON TD.TransactionID = TH.TransactionID
JOIN MsToy MT ON TD.ToyID = MT.ToyID
JOIN MsToyType TT ON MT.ToyTypeID = TT.ToyTypeID
JOIN MsSupplier MS ON MT.SupplierID = MS.SupplierID
ORDER BY [Profit For Each Type] ASC

--7
SELECT
ToyName
FROM MsToy MT
JOIN TransactionDetail TD ON TD.ToyID = MT.ToyID
JOIN TransactionHeader TH ON TH.TransactionID = TD.TransactionID
WHERE Quantity IN (
	SELECT Quantity
	FROM TransactionDetail
	WHERE Quantity = 0
	AND YEAR(TransactionDate) > 2022 
)

--8
CREATE VIEW CustomerPromotion
AS
SELECT
CustomerName,
CustomerPhone
FROM MsCustomer
WHERE CustomerID = 'CS001'