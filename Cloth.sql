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

INSERT INTO MsFabric VALUES
('FB001', 'Knit', 'Exclusive', '900', '10.00'),
('FB003', 'Cotton Combed', 'Normal', '900', '10.50'),
('FB005', 'Cotton Combed', 'Exclusive', '900', '29.00')

CREATE TABLE MsDesign (
	ClothingID CHAR(5) PRIMARY KEY CHECK (ClothingID LIKE 'CL[0-9][0-9][0-9]'),
    FabricName2 VARCHAR(50) CONSTRAINT FabricName2 CHECK (LEN(FabricName2) BETWEEN 1 AND 50) NOT NULL,
	DesignerName VARCHAR(50) CONSTRAINT DesignerName CHECK (LEN(DesignerName) BETWEEN 1 AND 50) NOT NULL,
    FabricQuality2 VARCHAR(50) CONSTRAINT FabricQuality2 CHECK (LEN(FabricQuality2) BETWEEN 1 AND 50) NOT NULL,
    ClothName VARCHAR(50) CONSTRAINT ClothName CHECK (LEN(ClothName) BETWEEN 1 AND 50) NOT NULL,
	FabricQuantity2 INT,

)

INSERT INTO MsDesign VALUES
('CL001', 'Rayon Viscosa', 'Bruno Blevins', 'Good', 'DRESS 50049-im', '2'),
('CL002', 'Cotton Carded', 'Bruno Blevins', 'Good', 'BLOUSE Y3310 Blue-im', '2'),
('CL003', 'Cotton Carded', 'Bruno Blevins', 'Good', 'OUTER DC5095-im Orange', '2')

-- 1
BEGIN TRANSACTION
UPDATE Msfabric SET FabricQuantity = FabricQuantity -100
FROM MsFabric
WHERE FabricName = 'Knit'
SELECT * FROM MsFabric

UPDATE Msfabric SET FabricQuantity = FabricQuantity -200
FROM MsFabric
WHERE FabricName = 'Cotton Combed'
AND FabricQuality = 'Normal'
SELECT * FROM MsFabric

UPDATE Msfabric SET FabricQuantity = FabricQuantity -50
FROM MsFabric
WHERE FabricName = 'Cotton Combed'
AND FabricQuality = 'Exclusive'
SELECT * FROM MsFabric
ROLLBACK

--2
CREATE VIEW ViewActiveOrder
AS
SELECT
ClothingID,
DesignerName,
ClothName
FROM MsDesign