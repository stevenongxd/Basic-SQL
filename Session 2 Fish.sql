CREATE DATABASE Fish

USE Fish

CREATE TABLE MsCustomer(
CustomerID CHAR(5) PRIMARY KEY CHECK(CustomerID LIKE 'CU[0-9][0-9][0-9]'),
CustomerName VARCHAR(50) NOT NULL,
CustomerGender VARCHAR(10) NOT NULL,
CustomerAddress VARCHAR(50) NOT NULL,
CustomerEmail VARCHAR(50) NOT NULL,
CustomerDOB DATE NOT NULL,
)

SELECT * FROM MsCustomer

CREATE TABLE MsFisherman(
FishermanID CHAR(5) PRIMARY KEY CHECK (FishermanID LIKE 'FS[0-9][0-9][0-9]'),
FishermanName VARCHAR(50) NOT NULL,
FishermanGender VARCHAR(10) NOT NULL,
FishermanAddress VARCHAR(50) NOT NULL
)

SELECT * FROM MsFisherman

CREATE TABLE MsFishType(
FishTypeID CHAR(5) PRIMARY KEY CHECK (FishTypeID LIKE 'FT[0-9][0-9][0-9]'),
FishTypeName VARCHAR(50) NOT NULL
)

SELECT * FROM MsFishType

CREATE TABLE MsFish(
FishID CHAR(5) PRIMARY KEY CHECK (FishID LIKE 'FI[0-9][0-9][0-9]'),
FishTypeID CHAR(5) REFERENCES MsFishType(FishTypeID) ON DELETE CASCADE ON UPDATE CASCADE,
FishName VARCHAR(50) NOT NULL,
FishPrice INT NOT NULL
)

SELECT * FROM MsFish

CREATE TABLE TransactionHeader(
TransactionID CHAR(5) PRIMARY KEY CHECK (TransactionID LIKE 'TR[0-9][0-9][0-9]'),
FishermanID CHAR(5)  REFERENCES MsFisherman(FishermanID) ON DELETE CASCADE ON UPDATE CASCADE,
CustomerID CHAR(5) REFERENCES MsCustomer(CustomerID) ON DELETE CASCADE ON UPDATE CASCADE,
TransactionDate DATE NOT NULL
)

SELECT * FROM TransactionHeader

CREATE TABLE TransactionDetail(
TransactionID CHAR(5) REFERENCES TransactionHeader(TransactionID) ON DELETE CASCADE ON UPDATE CASCADE,
FishID CHAR(5) REFERENCES MsFish(FishID) ON DELETE CASCADE ON UPDATE CASCADE,
Quantity INT NOT NULL
PRIMARY KEY(TransactionID, FishID)
)

DROP TABLE TransactionDetail

CREATE TABLE TransactionDetail(
TransactionID CHAR(5) NOT NULL REFERENCES TransactionHeader(TransactionID) ON DELETE CASCADE ON UPDATE CASCADE,
FishID CHAR(5) NOT NULL REFERENCES MsFish(FishID) ON DELETE CASCADE ON UPDATE CASCADE,
Quantity INT NOT NULL
)

SELECT * FROM TransactionDetail

ALTER TABLE TransactionDetail
ADD PRIMARY KEY(TransactionID, FishID)

ALTER TABLE MsCustomer
WITH NOCHECK ADD CONSTRAINT ValidasiEmail CHECK(CustomerEmail LIKE '%.com')

ALTER TABLE MsCustomer
DROP CONSTRAINT ValidasiEmail

ALTER TABLE MsFish
ADD FishAge INT

ALTER TABLE MsFish
DROP COLUMN FishAge

CREATE INDEX FishermanIndex ON MsFisherman(FishermanName ASC)