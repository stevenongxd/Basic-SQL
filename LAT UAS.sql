GO
DROP DATABASE ClothicBoutique
GO
CREATE DATABASE ClothicBoutique
GO
USE ClothicBoutique

CREATE TABLE MsFabric (
	FabricID CHAR(5) PRIMARY KEY CHECK (FabricID LIKE 'FB[0-9][0-9][0-9]'),
	FabricName VARCHAR(50) CONSTRAINT FabricName CHECK (LEN(FabricName) BETWEEN 1 AND 50) NOT NULL,
	FabricQuality VARCHAR(50) CONSTRAINT FabricQuality CHECK (LEN(FabricQuality) BETWEEN 5 AND 50) NOT NULL,
	FabricQuantity INT,
	FabricPrice FLOAT,
)

DROP TABLE MsFabric

INSERT INTO MsFabric VALUES
('FB001', 'Knit', 'Exclusive', '900', '10.00'),
('FB003', 'Cotton Combed', 'Normal', '900', '10.50'),
('FB005', 'Cotton Combed', 'Exclusive', '900', '29.00')

SELECT * FROM MsFabric

-- 1
BEGIN TRANSACTION
UPDATE Msfabric SET FabricQuantity = FabricQuantity -100
FROM MsFabric
WHERE FabricName = 'Knit'
SELECT * FROM MsFabric
ROLLBACK