-- Ex.1 Create Tables
CREATE TABLE employees(
id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
first_name VARCHAR(50) NOT NULL,
last_name VARCHAR(50) NOT NULL);

CREATE TABLE categories(
id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
name VARCHAR(50) NOT NULL);

CREATE TABLE products(
id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
name VARCHAR(50) NOT NULL,
category_id INT);

-- Ex.2 Insert Data in Tables
INSERT INTO employees (first_name, last_name)
VALUES ('Pesho', 'Peshov'),
('Gosho', 'Goshov'),
('name', 'name');

-- Ex.3 Alter Table
ALTER TABLE employees
ADD middle_name VARCHAR(30);

-- Ex.4 Adding Constraints
ALTER TABLE products
ADD FOREIGN KEY (category_id) REFERENCES categories(id);

-- Ex.5 Modifying Columns
ALTER TABLE employees
MODIFY middle_name VARCHAR(100);

