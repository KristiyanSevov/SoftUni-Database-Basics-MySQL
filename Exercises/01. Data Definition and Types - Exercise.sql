-- Ex.1 Create Tables
CREATE TABLE minions (
  id INT PRIMARY KEY,
  name VARCHAR(50),
  age INT);

CREATE TABLE towns(
  id INT PRIMARY KEY,
  name VARCHAR(50));
  
-- Ex.2 Alter Minions Table
ALTER TABLE minions
ADD town_id INT;

ALTER TABLE minions
ADD FOREIGN KEY (town_id) REFERENCES towns(id);

-- Ex.3 Insert Records in Both Tables
INSERT INTO towns
VALUES(1, 'Sofia'),
(2, 'Plovdiv'),
(3, 'Varna');

INSERT INTO minions
VALUES(1, 'Kevin', 22, 1),
(2, 'Bob', 15, 3),
(3, 'Steward', NULL, 2);

-- Ex.4 Truncate Table Minions
TRUNCATE minions;

-- Ex.5 Drop All Tables
DROP TABLE minions, towns;

-- Ex.6 Create Table People
CREATE TABLE people (
id INT PRIMARY KEY AUTO_INCREMENT,
name VARCHAR(200) NOT NULL,
picture MEDIUMBLOB,
height DOUBLE(3,2),
weight DOUBLE(5,2),
gender ENUM('m','f') NOT NULL,
birthdate DATE NOT NULL,
biography LONGTEXT);

INSERT INTO people(name, picture, height, weight, gender, birthdate, biography)
VALUES ('Pesho', 'ssss', 1.7, 65, 'm', '1991-12-23', 'bio'),
('Gosho', 'ssss', 1.8, 70, 'm', '1991-12-23', 'bio'),
('name', 'ssss', 1.2, 55, 'm', '1991-12-23', 'bio'),
('name2', 'ssss', 1.2, 55, 'm', '1991-12-23', 'bio'),
('name3', 'ssss', 1.2, 55, 'm', '1991-12-23', 'bio');

-- Ex.7 Create Table Users
CREATE TABLE users (
id INT PRIMARY KEY AUTO_INCREMENT,
username VARCHAR(30) NOT NULL UNIQUE,
`password` VARCHAR(26) NOT NULL,
profile_picture MEDIUMBLOB,
last_login_time TIMESTAMP,
is_deleted BIT);

INSERT INTO users(username, `password`, profile_picture, is_deleted)
VALUES('Pesho', 'pass', 'sss', true),
('Gosho', 'pass', 'sss', true),
('Stamat', 'pass', 'sss', false),
('Prakash', 'pass', 'sss', true),
('az', 'pass', 'sss', false);

-- Ex.8 Change Primary Key
ALTER TABLE users
MODIFY id INT NOT NULL;

ALTER TABLE users
DROP PRIMARY KEY;

ALTER TABLE users
ADD PRIMARY KEY (id, username);

ALTER TABLE users
MODIFY id INT NOT NULL AUTO_INCREMENT;

-- Ex.9 Set Default Value of a Field
ALTER TABLE users
MODIFY last_login_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP;

-- Ex.10 Set Unique Field
ALTER TABLE users
MODIFY id INT NOT NULL;

ALTER TABLE users
DROP PRIMARY KEY;

ALTER TABLE users
MODIFY id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
MODIFY username VARCHAR(30) NOT NULL UNIQUE;

-- Ex.11 Movies Database
CREATE TABLE directors(
id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
director_name VARCHAR(50) NOT NULL,
notes TEXT);

CREATE TABLE genres(
id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
genre_name VARCHAR(30) NOT NULL,
notes TEXT);

CREATE TABLE categories(
id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
category_name VARCHAR(30) NOT NULL,
notes TEXT);

CREATE TABLE movies(
id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
title VARCHAR(50) NOT NULL,
director_id INT NOT NULL,
copyright_year YEAR NOT NULL,
`length` TIME,
genre_id INT,
category_id INT,
rating INT,
notes TEXT);

INSERT INTO directors (director_name, notes)
VALUES ('Pesho', 'notes'),
('Gosho', 'notes'),
('name1', 'notes'),
('name2', 'notes'),
('name3', 'notes');

INSERT INTO genres (genre_name, notes)
VALUES ('comedy', 'notes'),
('horror', 'notes'),
('thriller', 'notes'),
('drama', 'notes'),
('musical', 'notes');

INSERT INTO categories(category_name, notes)
VALUES ('name', 'notes'),
('name2','notes'),
('name3', 'this is getting annoying'),
('name4', 'notes'),
('name5', 'notes');


INSERT INTO movies (title, director_id, copyright_year)
VALUES('first', 1, '1992'),
('second', 3, '1997'),
('some_movie', 2, '1991'),
('third', 1, '1992'),
('another_one', 1, '1995');

-- Ex.12 Car Rental Database
CREATE TABLE `categories`(
id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
category VARCHAR(30) NOT NULL,
daily_rate DECIMAL(6,2) NOT NULL,
weekly_rate DECIMAL(6,2) NOT NULL,
monthly_rate DECIMAL(7,2) NOT NULL,
weekend_rate DECIMAL(6,2) NOT NULL);

CREATE TABLE cars(
id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
plate_number VARCHAR(20) NOT NULL UNIQUE,
make VARCHAR(30) NOT NULL,
model VARCHAR(30) NOT NULL,
car_year YEAR,
category_id INT NOT NULL,
doors INT,
picture MEDIUMBLOB,
car_condition TEXT,
available BIT NOT NULL);

CREATE TABLE employees(
id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
first_name VARCHAR(20) NOT NULL,
last_name VARCHAR(20) NOT NULL,
title VARCHAR(50) NOT NULL,
notes TEXT);

CREATE TABLE customers(
id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
driver_licence_number VARCHAR(30) NOT NULL,
full_name VARCHAR(50) NOT NULL,
address VARCHAR(100) NOT NULL,
city VARCHAR(30) NOT NULL,
zip_code VARCHAR(50) NOT NULL,
notes TEXT);

CREATE TABLE rental_orders(
id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
employee_id INT NOT NULL,
customer_id INT NOT NULL,
car_id INT NOT NULL,
car_condition VARCHAR(50),
tank_level INT,
kilometrage_start INT,
kilometrage_end INT,
total_kilometrage INT,
start_date DATE NOT NULL,
end_date DATE NOT NULL,
total_days INT,
rate_applied ENUM('daily_rate', 'weekly_rate', 'monthly_rate', 'weekend_rate') NOT NULL,
tax_rate DECIMAL(5, 2) NOT NULL,
order_status TEXT,
notes TEXT);

INSERT INTO `categories`(category, daily_rate, weekly_rate, monthly_rate, weekend_rate)
VALUES ('first', 3, 20, 70, 5),
('second', 4, 22, 80, 7),
('third', 5, 31, 115, 9);

INSERT INTO cars(plate_number, make, model, category_id, available)
VALUES ('SX555', 'Mercedes', 'S-class', 2, true),
('somenum', 'Mercedes', 'G-class', 2, false),
('anothernum', 'Mercedes', 'S-class', 2, false);

INSERT INTO employees(first_name, last_name, title)
VALUES ('Pesho', 'Peshov', 'Boss'),
('name', 'name', 'title'),
('name2', 'name2', 'title2');

INSERT INTO customers(driver_licence_number, full_name, address, city, zip_code)
VALUES (9393938, 'Pesho Peshov', 'address', 'sofia', 'code'),
(929393, 'Pesho Peshov', 'address', 'sofia', 'code'),
(939393438, 'Pesho Peshov', 'address', 'sofia', 'code');

INSERT INTO rental_orders(employee_id, customer_id, car_id, start_date, end_date, rate_applied, tax_rate)
VALUES (1, 2, 1, '2018-01-02', '2018-01-07', 'daily_rate', 0.2),
(1, 1, 2, '2018-01-02', '2018-01-09', 'weekly_rate', 0.2),
(1, 2, 3, '2018-01-02', '2018-02-02', 'monthly_rate', 0.2);

-- Ex.13 Hotel Database
CREATE TABLE employees(
id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
first_name VARCHAR(30) NOT NULL,
last_name VARCHAR(30) NOT NULL,
title VARCHAR(50) NOT NULL,
notes TEXT);

CREATE TABLE customers(
account_number BIGINT NOT NULL PRIMARY KEY,
first_name VARCHAR(30) NOT NULL,
last_name VARCHAR(30) NOT NULL,
phone_number VARCHAR(30) NOT NULL,
emergency_name VARCHAR(50),
emergency_number VARCHAR(50),
notes TEXT);

CREATE TABLE room_status(
room_status VARCHAR(30) NOT NULL PRIMARY KEY,
notes TEXT);

CREATE TABLE room_types(
room_type VARCHAR(30) NOT NULL PRIMARY KEY,
notes TEXT);

CREATE TABLE bed_types(
bed_type VARCHAR(30) NOT NULL PRIMARY KEY,
notes TEXT);

CREATE TABLE rooms(
room_number INT NOT NULL PRIMARY KEY,
room_type VARCHAR(30) NOT NULL,
bed_type VARCHAR(30) NOT NULL,
rate DECIMAL(6,2) NOT NULL,
room_status VARCHAR(30) NOT NULL,
notes TEXT);

CREATE TABLE payments(
id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
employee_id INT NOT NULL,
payment_date DATE NOT NULL,
account_number BIGINT NOT NULL,
first_date_occupied DATE NOT NULL,
last_date_occupied DATE NOT NULL,
total_days INT,
amount_charged DECIMAL(9,2) NOT NULL,
tax_rate DECIMAL(5,2) NOT NULL,
tax_amount DECIMAL(9,2),
payment_total DECIMAL(9, 2),
notes TEXT);

CREATE TABLE occupancies(
id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
employee_id INT NOT NULL,
date_occupied DATE NOT NULL,
account_number BIGINT NOT NULL,
room_number INT NOT NULL,
rate_applied DECIMAL(6,2) NOT NULL,
phone_charge DECIMAL(6,2),
notes TEXT);

INSERT INTO employees (first_name, last_name, title)
VALUES ('Pesho', 'Peshov', 'Boss'),
('Gosho', 'Goshov', 'Director'),
('name', 'name', 'title');

INSERT INTO customers (account_number, first_name, last_name, phone_number)
VALUES (1, 'Pesho', 'Petrov', '112-2-2313-2'),
(2, 'Gosho', 'Petrov', '112-2-2912'),
(3, 'Atanas', 'Petrov', '112-113-2');

INSERT INTO room_status(room_status)
VALUES ('free'), ('occupied'), ('cleaning');

INSERT INTO room_types(room_type)
VALUES('small'), ('normal'), ('apartment');

INSERT INTO bed_types(bed_type)
VALUES('single'), ('twin'), ('king-size');

INSERT INTO rooms(room_number, room_type, bed_type, rate, room_status)
VALUES(1, 'small', 'single', 50, 'free'),
(2, 'apartment', 'king-size', 100, 'cleaning'),
(3, 'normal', 'twin', 70, 'occupied');

INSERT INTO payments(employee_id, payment_date, account_number,
first_date_occupied, last_date_occupied, total_days, amount_charged,
tax_rate)
VALUES (1, '2018-01-10', 2, '2018-01-02', '2018-01-10', 8, 300, 0.2),
(1, '2018-01-09', 2, '2018-01-02', '2018-01-09', 7, 270, 0.2),
(1, '2018-01-08', 2, '2018-01-02', '2018-01-08', 6, 240, 0.2);

INSERT INTO occupancies(employee_id, date_occupied, account_number, 
room_number, rate_applied)
VALUES(2, '2018-01-02', 2, 3, 20),
(2, '2018-01-03', 2, 3, 30),
(2, '2018-01-05', 2, 1, 20);

-- Ex.14 Create SoftUni Database
CREATE TABLE towns(
id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
name VARCHAR(30) NOT NULL);

CREATE TABLE addresses(
id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
address_text TEXT NOT NULL,
town_id INT NOT NULL,
FOREIGN KEY(town_id) REFERENCES towns(id));

CREATE TABLE departments(
id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
name VARCHAR(50) NOT NULL);

CREATE TABLE employees(
id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
first_name VARCHAR(20) NOT NULL,
middle_name VARCHAR(20),
last_name VARCHAR(30) NOT NULL,
job_title VARCHAR(50) NOT NULL,
department_id INT NOT NULL,
hire_date DATE NOT NULL,
salary DECIMAL(9,2) NOT NULL,
address_id INT NOT NULL,
FOREIGN KEY (department_id) REFERENCES departments(id),
FOREIGN KEY (address_id) REFERENCES addresses(id));

-- Ex.15 Basic Insert
INSERT INTO towns(name)
VALUES ('Sofia'), ('Plovdiv'), ('Varna'), ('Burgas');

INSERT INTO departments(name)
VALUES ('Engineering'), ('Sales'), ('Marketing'), ('Software Development'),
('Quality Assurance');

INSERT INTO employees(first_name, middle_name, last_name, job_title, department_id, hire_date, salary)
VALUES ('Ivan', 'Ivanov', 'Ivanov', '.NET Developer', 4, '2013-02-01', 3500.00),
('Petar', 'Petrov', 'Petrov', 'Senior Engineer', 1, '2004-03-02', 4000.00),
('Maria', 'Petrova', 'Ivanova', 'Intern', 5, '2016-08-28', 525.25),
('Georgi', 'Terziev', 'Ivanov', 'CEO', 2, '2007-12-09', 3000.00),
('Peter', 'Pan', 'Pan', 'Intern', 3, '2016-08-28', 599.88);

-- Ex.16 Basic Select All Fields
SELECT * FROM towns;
SELECT * FROM departments;
SELECT * FROM employees;

-- Ex.17 Basic Select All Fields and Order Them
SELECT * FROM towns ORDER BY name;
SELECT * FROM departments ORDER BY name;
SELECT * FROM employees ORDER BY salary DESC;

-- Ex.18 Basic Select Some Fields
SELECT name FROM towns ORDER BY name;
SELECT name FROM departments ORDER BY name;
SELECT first_name, last_name, job_title, salary FROM employees ORDER BY salary DESC;

-- Ex.19 Increase Employees Salary
UPDATE employees
SET salary = salary + salary*0.1;

SELECT salary FROM employees;

-- Ex.20 Decrease Tax Rate
UPDATE payments
SET tax_rate = tax_rate - tax_rate*0.03;

SELECT tax_rate FROM payments;

-- Ex.21 Delete All Records
TRUNCATE TABLE occupancies;
