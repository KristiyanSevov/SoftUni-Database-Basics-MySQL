--Ex.1 DDL
CREATE TABLE deposit_types(
deposit_type_id INT PRIMARY KEY,
name VARCHAR(20));

CREATE TABLE deposits(
deposit_id INT PRIMARY KEY AUTO_INCREMENT,
amount DECIMAL(10,2),
start_date DATE,
end_date DATE,
deposit_type_id INT,
customer_id INT,
FOREIGN KEY (deposit_type_id) REFERENCES deposit_types(deposit_type_id),
FOREIGN KEY (customer_id) REFERENCES customers(customer_id));

CREATE TABLE employees_deposits(
employee_id INT,
deposit_id INT,
PRIMARY KEY (employee_id, deposit_id),
FOREIGN KEY (employee_id) REFERENCES employees(employee_id),
FOREIGN KEY (deposit_id) REFERENCES deposits(deposit_id));

CREATE TABLE credit_history(
credit_history_id INT PRIMARY KEY,
mark CHAR(1),
start_date DATE,
end_date DATE,
customer_id INT,
FOREIGN KEY (customer_id) REFERENCES customers(customer_id));

CREATE TABLE payments(
payment_id INT PRIMARY KEY,
`date` DATE,
amount DECIMAL(10,2),
loan_id INT,
FOREIGN KEY(loan_id) REFERENCES loans(loan_id));

CREATE TABLE users(
user_id INT PRIMARY KEY,
user_name VARCHAR(20),
`password` VARCHAR(20),
customer_id INT UNIQUE,
FOREIGN KEY(customer_id) REFERENCES customers(customer_id));

ALTER TABLE employees
ADD manager_id INT,
ADD FOREIGN KEY (manager_id) REFERENCES employees(employee_id);

--Ex.2 Inserts
INSERT INTO deposit_types
VALUES (1, 'Time Deposit'), (2, 'Call Deposit'), (3, 'Free Deposit');

INSERT INTO deposits (amount, start_date, end_date, deposit_type_id, customer_id)
SELECT IF(c.date_of_birth > DATE('1980-01-01'), 1000, 1500) + IF(c.gender = 'M', 100, 200),
DATE(NOW()), NULL, 
(CASE WHEN c.customer_id > 15 THEN 3
	ELSE IF(c.customer_id % 2 = 0, 2, 1) 
	END), c.customer_id FROM customers as c
ORDER BY c.customer_id LIMIT 19;

INSERT INTO employees_deposits
VALUES (15, 4), (20,15), (8,7), (4,8), (3,13), (3,8), (4,10), (10,1), (13,4), (14,9);

--Ex.3 Update
UPDATE employees
SET manager_id = 
	CASE WHEN employee_id BETWEEN 2 AND 10 THEN 1
	WHEN employee_id BETWEEN 12 AND 20 THEN 11
	WHEN employee_id BETWEEN 22 AND 30 THEN 21
	WHEN employee_id IN (11,21) THEN 1
	END;
	
--Ex.4 Delete
DELETE FROM employees_deposits
WHERE deposit_id = 9 OR employee_id = 3;

--Ex.5 Employees Salary
SELECT employee_id, hire_date, salary, branch_id FROM employees
WHERE salary > 2000 AND hire_date > DATE('2009-12-21');

--Ex.6 Customer Age
SELECT first_name, date_of_birth, 
FLOOR(DATEDIFF(DATE('2016-10-01'), date_of_birth) / 360) as age FROM customers
WHERE DATEDIFF(DATE('2016-10-01'), date_of_birth) / 360 BETWEEN 40 AND 50;

--Ex.7 Customer City
SELECT c.customer_id, c.first_name, c.last_name, c.gender, cit.city_name FROM customers as c 
JOIN cities as cit ON c.city_id = cit.city_id
WHERE (c.last_name LIKE 'Bu%' OR c.first_name LIKE '%a')
AND CHAR_LENGTH(cit.city_name) >= 8
ORDER BY c.customer_id;

--Ex.8 Employee Accounts
SELECT e.employee_id, e.first_name, a.account_number FROM accounts as a 
JOIN employees_accounts as e_a ON a.account_id = e_a.account_id
JOIN employees as e ON e_a.employee_id = e.employee_id
WHERE a.start_date >= DATE('2013-01-01')
ORDER BY first_name DESC 
LIMIT 5;

--Ex.9 Count Cities
SELECT c.city_name, b.name, COUNT(e.employee_id) as employees_count
FROM employees as e 
JOIN branches as b ON e.branch_id = b.branch_id
JOIN cities as c ON b.city_id = c.city_id
GROUP BY c.city_name, b.name
HAVING employees_count >= 3;

--Ex.10 Loan Statistics
SELECT SUM(l.amount) as total_loan_amount, MAX(l.interest) as max_interest, 
MIN(e.salary) as min_employee_salary FROM loans as l
JOIN employees_loans as e_l ON l.loan_id = e_l.loan_id
JOIN employees as e ON e_l.employee_id = e.employee_id;

--Ex.11 Unite People
(SELECT e.first_name, c.city_name FROM employees as e 
JOIN branches as b ON e.branch_id = b.branch_id
JOIN cities as c ON b.city_id = c.city_id
LIMIT 3)

UNION

(SELECT cust.first_name, c.city_name FROM customers as cust
JOIN cities as c ON cust.city_id = c.city_id
LIMIT 3);

--Ex.12 Customers w/o Accounts
SELECT c.customer_id, c.height FROM customers as c 
LEFT JOIN accounts as a ON c.customer_id = a.customer_id
WHERE a.account_id IS NULL AND c.height BETWEEN 1.74 AND 2.04;

--Ex.13 Average Loans
SELECT c.customer_id, l.amount FROM loans as l 
JOIN customers as c ON l.customer_id = c.customer_id
WHERE l.amount > (SELECT AVG(l.amount) as average FROM loans as l 
	JOIN customers as c ON l.customer_id = c.customer_id
	WHERE c.gender = 'M')
ORDER BY c.last_name, c.customer_id
LIMIT 5;

--Ex.14 Oldest Account
SELECT c.customer_id, c.first_name, a.start_date FROM accounts as a 
JOIN customers as c ON a.customer_id = c.customer_id
ORDER BY start_date LIMIT 1;

--Ex.15 String Joiner
CREATE FUNCTION udf_concat_string(s1 VARCHAR(50), s2 VARCHAR(50))
RETURNS VARCHAR(50)
BEGIN
DECLARE result VARCHAR(50);
SET result = CONCAT(REVERSE(s1), REVERSE(s2));
RETURN result;
END;

--Ex.16 Unexpired Loans
CREATE PROCEDURE usp_customers_with_unexpired_loans(id INT)
BEGIN
SELECT c.customer_id, c.first_name,
l.loan_id FROM customers as c 
JOIN loans as l ON l.customer_id = c.customer_id
WHERE l.expiration_date IS NULL AND l.customer_id = id;
END;

--Ex.17 Take Loan
CREATE PROCEDURE usp_take_loan(id INT, loan_amount DECIMAL(20,4),
interest DECIMAL(20,4), start_date DATE)
BEGIN
START TRANSACTION;
	CASE WHEN loan_amount NOT BETWEEN 0.01 AND 100000
		THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Invalid Loan Amount';
		ROLLBACK;
	ELSE
		INSERT INTO loans (start_date, amount, interest, customer_id)
		VALUES (start_date, loan_amount, interest, id);
	END CASE;
COMMIT;
END;

--Ex.18 Hire Employee
CREATE TRIGGER my_trigger AFTER INSERT ON employees
FOR EACH ROW
BEGIN
UPDATE employees_loans
SET employee_id = employee_id + 1
WHERE employee_id = NEW.employee_id - 1;
END;

--Ex.19 Delete Trigger
CREATE TRIGGER my_trigger BEFORE DELETE ON accounts
FOR EACH ROW 
BEGIN
	DELETE FROM employees_accounts
	WHERE account_id = OLD.account_id;

	INSERT INTO account_logs 
	VALUES (OLD.account_id, OLD.account_number, OLD.start_date, OLD.customer_id);
END;
