USE DDL_UTS

--A
BEGIN TRANSACTION
INSERT INTO BorrowerData VALUES
('MN838', 'Alexandra Westin', 'Sunter Karya', '2002-11-24', 'Alexwes@gmail.com', '81283366251')
SELECT * FROM BorrowerData
ROLLACK

--B
BEGIN TRANSACTION
UPDATE BorrowerData SET FullName = ('Alexandra Westina')
FROM BorrowerData
SELECT * FROM BorrowerData
ROLLBACK

--C
BEGIN TRANSACTION
Select * FROM BorrowerData
WHERE (FullName LIKE 'A%')
ROLLBACK