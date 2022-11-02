USE Weapon_Store

--1
BEGIN TRANSACTION
CREATE TABLE shop(
shop_id CHAR (5) PRIMARY KEY CHECK (shop_id LIKE 'SH[0-9][0-9][0-9]') NOT NULL,
shop_name VARCHAR (255) NOT NULL,
shop_address VARCHAR (255) CHECK (shop_address LIKE '%Street') NOT NULL,
)
SELECT * FROM shop
ROLLBACK

--2
BEGIN TRANSACTION
ALTER TABLE weapon
ADD weapon_maker VARCHAR (255)
ALTER TABLE weapon
ADD CONSTRAINT valweapon_price CHECK (weapon_price > 1000000)
SELECT * FROM weapon
ROLLBACK

--3
BEGIN TRANSACTION
INSERT INTO customer VALUES
('CU006', 'Edward Santoso', 'Jalan Kelapa no 5', '081389945136')
SELECT * FROM customer
ROLLBACK

--4
BEGIN TRANSACTION
SELECT weapon_name, weapon_price, year_production FROM weapon
WHERE year_production BETWEEN 2000 AND 2010
ROLLBACK

--5
BEGIN TRANSACTION
select * from staff
DELETE staff
FROM staff, purchase_header
WHERE staff.staff_id = purchase_header.transaction_date AND MONTH (transaction_date) = 12
SELECT * FROM staff
ROLLBACK