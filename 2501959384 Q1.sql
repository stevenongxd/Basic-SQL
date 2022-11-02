USE BluejackSword

--1
BEGIN TRANSACTION
CREATE TABLE Staff(
StaffID CHAR(5) PRIMARY KEY CHECK (StaffID LIKE 'ST[0-9][0-9][0-9]'),
StaffName VARCHAR(20) NOT NULL,
StaffAddress VARCHAR(50) CHECK (StaffAddress LIKE '%Street') NOT NULL
)
SELECT * FROM Staff

ROLLBACK

--2
BEGIN TRANSACTION
ALTER TABLE Sword
ADD SwordCreatedDate DATE
ALTER TABLE Sword
ADD CONSTRAINT SwordDamage CHECK (SwordDamage BETWEEN 0 AND 120)

SELECT * FROM Sword

ROLLBACK

--3
BEGIN TRANSACTION
INSERT INTO Customer VALUES
('CU011', 'William Thanus', 'Male', 'William.thanus@gmail.com', '2 Hermina Park', '2020-12-15')
SELECT * FROM Customer
ROLLBACK

--4
BEGIN TRANSACTION
SELECT SwordID, SwordName, SwordDamage
FROM Sword
WHERE SwordDamage BETWEEN 50 AND 90
ROLLBACK

--5
SELECT * FROM Sword
BEGIN TRANSACTION
UPDATE Sword SET SwordDamage = SwordDamage + 10
FROM Sword, HeaderTransaction
WHERE DAY (TransactionDate) > 5
SELECT * FROM Sword
ROLLBACK