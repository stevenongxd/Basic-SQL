INSERT INTO 
TransactionDetail
VALUES ('TR014', 'FI014', 27),
('TR014', 'FI010', 2),
('TR015', 'FI005', 26),
('TR015', 'FI002', 21)

INSERT INTO
TransactionDetail(FishID, Quantity, TransactionID)
VALUES ('FI001', 1, 'TR016')

SELECT * 
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'TransactionDetails'

SELECT CAST(ROUND((RAND() * 35) + 5, 1) AS NUMERIC(9,1))

BEGIN TRANSACTION
INSERT INTO MsFish
VALUES ('FI017', 'FT003', 'Red Mackarel',
	ROUND((RAND() * 35) + 5, 1)
)

ROLLBACK

COMMIT

SELECT * 
FROM MsFish

BEGIN TRANSACTION
DELETE
FROM MsFish
WHERE FishTypeID IN ('FT003', 'FT005')

UPDATE MsFish
SET FishPrice = FishPrice - 3
WHERE FishPrice >= 10 AND FishPrice <=12

BEGIN TRANSACTION
UPDATE MsFish
SET FishPrice = FishPrice -3
WHERE FishPrice BETWEEN 10 AND 12

SELECT *
FROM MsFish

ROLLBACK

SELECT *
FROM MsFish

SELECT CustomerID, CustomerName, CustomerGender, CustomerAddress, CustomerDOB, CustomerEmail
FROM MsCustomer
WHERE CustomerAddress IS NOT NULL
ORDER BY CustomerDOB ASC