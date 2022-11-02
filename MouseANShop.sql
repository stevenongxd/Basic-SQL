USE MouseAN_Shop

--1
BEGIN TRANSACTION
CREATE TABLE MsTypeMouse(
TypeID CHAR(5) PRIMARY KEY CHECK (TypeID LIKE 'TY[0-9][0-9][0-9]') NOT NULL,
TypeName VARCHAR(20) CHECK (TypeName LIKE 'Mouse') NOT NULL,
TypeDescription VARCHAR(255) NOT NULL
)
SELECT * FROM MsTypeMouse

ROLLBACK

--2
BEGIN TRANSACTION
ALTER TABLE MsCashier
ADD CashierEmail VARCHAR(20)
ALTER TABLE MsCashier
ADD CONSTRAINT CashierEmail CHECK (CashierEmail LIKE '%.com')

SELECT * FROM MsCashier

ROLLBACK

--3
BEGIN TRANSACTION
INSERT INTO MsCustomer VALUES
('CU011', 'Stefanus Geory Michael', 'Male', '57, King Cobra Street', '08980418508')

SELECT * FROM MsCustomer

--COMMIT

ROLLBACK

--4
BEGIN TRANSACTION
SELECT CustomerName, CustomerAddress, CustomerGender FROM MsCustomer
WHERE CustomerName LIKE 'A%'

SELECT * FROM MsCustomer

ROLLBACK