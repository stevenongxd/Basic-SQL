USE FishingMania

INSERT INTO TransactionDetail VALUES
('TR014', 'FI014', 27),
('TR014', 'FI010', 2),
('TR015', 'FI005', 26),
('TR015', 'FI002', 21)

BEGIN TRANSACTION
INSERT INTO MsFish VALUES
('FI017', 'FT003', 'Red Mackerel',
CAST(ROUND((RAND() * 35) + 5, 1) AS NUMERIC(9,1))
)

SELECT * FROM MsFish

BEGIN TRANSACTION
DELETE
FROM MsFish
WHERE FishTypeID IN ('FT003', 'FT005')

ROLLBACK

BEGIN TRANSACTION
DELETE
FROM MsCustomer
WHERE CustomerGender IN ('Female')

ROLLBACK

BEGIN TRANSACTION
UPDATE MsFish SET FishPrice = FishPrice - 3
FROM MsFish
WHERE FishPrice BETWEEN 10 AND 12

SELECT * FROM MsFish

ROLLBACK

BEGIN TRANSACTION
UPDATE MsFish SET FishPrice = FishPrice + 2.5
FROM MsFish
WHERE FishTypeID IN ('FT001', 'FT002', '35')

SELECT * FROM MsFish

ROLLBACK

BEGIN TRANSACTION
SELECT * FROM MsCustomer
WHERE CustomerAddress IS NOT NULL
ORDER BY CustomerDOB ASC

SELECT * FROM MsCustomer

ROLLBACK

BEGIN TRANSACTION
UPDATE MsFisherman SET FishermanAddress = 'Address: ' + FishermanAddress
SELECT FishermanName, FishermanAddress FROM MsFisherman
WHERE FishermanGender IN ('Male')

SELECT FishermanName, FishermanAddress FROM MsFisherman

ROLLBACK

BEGIN TRANSACTION
SELECT FishName, '$' + CAST(FishPrice AS VARCHAR(15)) FishPrice FROM MsFish
WHERE FishPrice <= 10

ROLLBACK

BEGIN TRANSACTION
SELECT FishName, '$' + CAST(FLOOR(FishPrice) AS VARCHAR) DiscountPrice FROM MsFish
WHERE FishName IN ('Red Grouper')

ROLLBACK