USE Nasabah

CREATE TABLE Peminjaman (
	NoNasabah CHAR(5) PRIMARY KEY CHECK (NoNasabah LIKE 'L-[0-9][0-9][0-9]'),
	NamaNasabah VARCHAR(50) NOT NULL,
	NamaCabang VARCHAR(10) NOT NULL,
	Jumlah INT NOT NULL,
);
SELECT * FROM Peminjaman

INSERT INTO Peminjaman VALUES 
('L-001', 'Anggi', 'Peunayong', '3000'),
('L-002', 'Priyanto', 'PekanBada', '4500'),
('L-003', 'Susillo', 'Lamdingin', '7000')

SELECT * FROM Peminjaman
WHERE Jumlah > 4000