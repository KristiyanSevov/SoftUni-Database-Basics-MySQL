--Ex.1 DDL - Table Design
CREATE TABLE `status`(
id INT(11) UNSIGNED NOT NULL PRIMARY KEY,
label VARCHAR(30) NOT NULL);

CREATE TABLE departments(
id INT(11) UNSIGNED NOT NULL PRIMARY KEY,
name VARCHAR(50) NOT NULL);

CREATE TABLE categories(
id INT(11) UNSIGNED NOT NULL PRIMARY KEY,
name VARCHAR(50) NOT NULL,
department_id INT(11) UNSIGNED,
FOREIGN KEY (department_id) REFERENCES departments(id));

CREATE TABLE employees(
id INT(11) UNSIGNED NOT NULL PRIMARY KEY,
first_name VARCHAR(25),
last_name VARCHAR(25),
gender VARCHAR(1),
birthdate DATETIME,
age INT(11) UNSIGNED,
department_id INT(11) UNSIGNED NOT NULL,
FOREIGN KEY (department_id) REFERENCES departments(id));

CREATE TABLE users(
id INT(11) UNSIGNED NOT NULL PRIMARY KEY,
username VARCHAR(30) NOT NULL UNIQUE,
`password` VARCHAR(50) NOT NULL,
name VARCHAR(50),
gender VARCHAR(1),
birthdate DATETIME,
age INT(11) UNSIGNED,
email VARCHAR(50) NOT NULL);

CREATE TABLE reports(
id INT(11) UNSIGNED NOT NULL PRIMARY KEY,
category_id INT(11) UNSIGNED NOT NULL,
status_id INT(11) UNSIGNED NOT NULL,
open_date DATETIME,
close_date DATETIME,
description VARCHAR(200),
user_id INT(11) UNSIGNED NOT NULL,
employee_id INT(11) UNSIGNED,
FOREIGN KEY (category_id) REFERENCES categories(id),
FOREIGN KEY (status_id) REFERENCES `status`(id),
FOREIGN KEY (user_id) REFERENCES users(id),
FOREIGN KEY (employee_id) REFERENCES employees(id));

--Ex.2 Insert
INSERT INTO employees (first_name, last_name, gender, birthdate, department_id)
VALUES ('Marlo', 'O\'Malley', 'M', '1958-01-21', 1),
('Niki', 'Stanaghan', 'F', '1969-11-26', 4),
('Ayrton', 'Senna', 'M', '1960-03-21', 9),
('Ronnie', 'Peterson', 'M', '1944-02-14', 9),
('Giovanna', 'Amati', 'F', '1959-07-20', 5);

INSERT INTO reports (category_id, status_id, open_date, close_date, description, user_id, employee_id)
VALUES (1, 1, '2017-04-13', NULL, 'Stuck Road on Str.133', 6, 2),
(6, 3, '2015-09-05', '2015-12-06', 'Charity trail running', 3, 5),
(14, 2, '2015-09-07', NULL, 'Falling bricks on Str.58', 5, 2),
(4, 3, '2017-07-03', '2017-07-06', 'Cut off streetlight on Str.11', 1, 1);

--Ex.3 Update
UPDATE reports
SET status_id = 2
WHERE status_id = 1 AND category_id = 4;

--Ex.4 Delete
DELETE FROM reports
WHERE status_id = 4;

--Ex.5 Users by Age
SELECT username, age FROM users
ORDER BY age, username DESC;

--Ex.6 Unassigned Reports
SELECT description, open_date FROM reports
WHERE employee_id IS NULL
ORDER BY open_date, description;

--Ex.7 Employees and Reports
SELECT e.first_name, e.last_name, r.description, 
DATE_FORMAT(r.open_date, '%Y-%m-%d') AS open_date FROM employees AS e
JOIN reports AS r ON e.id = r.employee_id
ORDER BY r.employee_id, r.open_date, r.id;

--Ex.8 Most Reported Category
SELECT c.name, COUNT(r.id) as reports_number FROM categories as c 
JOIN reports as r ON c.id = r.category_id
GROUP BY c.name
ORDER BY reports_number, name;

--Ex.9 One Category Employees
SELECT c.name, COUNT(e.id) as employees_number FROM categories as c 
LEFT JOIN departments as d ON c.department_id = d.id
LEFT JOIN employees as e ON d.id = e.department_id
GROUP BY c.name
ORDER BY c.name;

--Ex.10 Birthday Report
SELECT DISTINCT c.name FROM reports as r 
JOIN users as u ON r.user_id = u.id
JOIN categories as c ON c.id = r.category_id
WHERE MONTH(r.open_date) = MONTH(u.birthdate) 
	AND DAY(r.open_date) = DAY(u.birthdate)
ORDER BY c.name;

--Ex.11 Users per Employee
SELECT CONCAT(e.first_name, ' ', e.last_name) as name, 
COUNT(DISTINCT r.user_id) as users_count
FROM employees as e
LEFT JOIN reports AS r ON e.id = r.employee_id
GROUP BY e.id
ORDER BY users_count DESC, name;

--Ex.12 Emergency Patrol
SELECT r.open_date, r.description, u.email FROM reports as r
JOIN categories as c ON r.category_id = c.id
JOIN departments as d ON c.department_id = d.id
JOIN users as u ON r.user_id = u.id
WHERE r.close_date IS NULL
	AND CHAR_LENGTH(r.description) > 20
	AND r.description LIKE '%str%'
	AND d.name IN ('Infrastructure', 'Emergency', 'Roads Maintenance')
ORDER BY r.open_date, u.email, r.id;

--Ex.13 Numbers Coincidence
SELECT DISTINCT u.username FROM reports as r 
JOIN users as u ON r.user_id = u.id
WHERE LEFT(u.username, 1) = r.category_id OR RIGHT(u.username, 1) = r.category_id
ORDER BY u.username;

--Ex.14 Open/Closed Statistics
SELECT CONCAT(first_name, ' ', last_name) as name,
CONCAT(
	CAST(COUNT(IF(YEAR(r.close_date) = 2016, 1, NULL)) AS CHAR(10)),
	'/',
	CAST(COUNT(IF(YEAR(r.open_date) = 2016, 1, NULL)) AS CHAR(10))
) as closed_open_reports 
FROM employees as e 
JOIN reports as r ON e.id = r.employee_id 
WHERE YEAR(r.close_date) = 2016 OR YEAR(r.open_date) = 2016
GROUP BY name
ORDER BY name;

--Ex.15 Average Closing Time
SELECT d.name, IFNULL(FLOOR(AVG(DATEDIFF(close_date, open_date))), 'no info') as average_duration
FROM reports as r
JOIN categories as c on r.category_id = c.id
JOIN departments as d on c.department_id = d.id
GROUP BY d.name
ORDER BY d.name;

--Ex.16 Most Reported Category
SELECT  d.name, c.name as category_name,
ROUND(
   (COUNT(r.id) / (SELECT COUNT(r.id) FROM reports as r
                   JOIN categories as c ON r.category_id = c.id
                   WHERE c.department_id = d.id)) * 100 
, 0) AS percentage FROM reports as r
JOIN categories as c ON r.category_id = c.id
JOIN departments as d ON c.department_id = d.id
GROUP BY c.name
ORDER BY d.name, c.name, percentage;

--Ex.17 Get Reports
CREATE FUNCTION udf_get_reports_count(employee_id INT, status_id INT)
RETURNS INT
BEGIN
	DECLARE r_count INT;
	SET r_count := (SELECT COUNT(r.id) FROM reports as r
	WHERE employee_id = r.employee_id AND status_id = r.status_id);
	RETURN r_count;
END;

--Ex.18 Assign Employee
CREATE PROCEDURE usp_assign_employee_to_report(employee_id INT, report_id INT)
BEGIN
	START TRANSACTION;
	IF (SELECT department_id FROM employees WHERE id = employee_id) != 
		(SELECT c.department_id FROM categories as c JOIN reports as r
		ON r.category_id = c.id 
		WHERE r.id = report_id)
	THEN 
		SIGNAL SQLSTATE '45000' 
		SET MESSAGE_TEXT = 'Employee doesn\'t belong to the appropriate department!';
		ROLLBACK;
	ELSE
		UPDATE reports as r
		SET r.employee_id = employee_id
		WHERE r.id = report_id;
	END IF;
	COMMIT;
END;

--Ex.19 Close Reports
CREATE TRIGGER tr_closed_report
BEFORE UPDATE ON reports
FOR EACH ROW
BEGIN 
	IF(old.close_date IS NULL AND new.close_date IS NOT NULL)
	THEN SET new.status_id = 3;
END IF;
END;

--Ex.20 Categories Revision
SELECT c.name AS category_name, COUNT(r.id) AS reports_number,
(CASE WHEN 
	(SELECT COUNT(id) FROM reports as r 
	WHERE r.status_id = 1 AND c.id = r.category_id) > 
	(SELECT COUNT(id) FROM reports as r 
	WHERE r.status_id = 2 AND c.id = r.category_id) 
 THEN
	'waiting'
WHEN
	(SELECT COUNT(id) FROM reports as r 
	WHERE r.status_id = 1 AND c.id = r.category_id) <
	(SELECT COUNT(id) FROM reports as r 
	WHERE r.status_id = 2 AND c.id = r.category_id) 
 THEN
	'in progress'
ELSE 
	'equal'
END) AS main_status
FROM categories as c JOIN reports as r ON c.id = r.category_id
WHERE r.status_id IN (1, 2)
GROUP BY c.name;
