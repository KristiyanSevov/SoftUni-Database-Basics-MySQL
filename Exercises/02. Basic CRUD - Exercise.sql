-- Ex.1 Find All Information About Departments
SELECT * FROM departments
ORDER BY department_id;

-- Ex.2 Find all Department Names
SELECT name FROM departments;

-- Ex.3 Find Salary of Each Employee
SELECT first_name, last_name, salary FROM employees
ORDER BY employee_id;

-- Ex.4 Find Full Name of Each Employee
SELECT first_name, middle_name, last_name FROM employees
ORDER BY employee_id;

-- Ex.5 Find Email Address of Each Employee
SELECT CONCAT(first_name, '.', last_name, '@softuni.bg') 
AS 'full_email_address' FROM employees

-- Ex.6 Find All Different Employee’s Salaries
SELECT DISTINCT salary FROM employees
ORDER BY employee_id;

-- Ex.7 Find all Information About Employees
SELECT * FROM employees
WHERE job_title = 'Sales Representative'
ORDER BY employee_id;

-- Ex.8 Find Names of All Employees by Salary in Range
SELECT first_name, last_name, job_title AS 'JobTitle' FROM employees
WHERE salary BETWEEN 20000 AND 30000
ORDER BY employee_id;

-- Ex.9 Find Names of All Employees
SELECT CONCAT(first_name, ' ', middle_name, ' ', last_name)
AS 'full_name' FROM employees
WHERE salary in (25000, 14000, 12500, 23600)
ORDER BY employee_id;

-- Ex.10 Find All Employees Without Manager
SELECT first_name, last_name FROM employees
WHERE manager_id IS NULL
ORDER BY employee_id;

-- Ex.11 Find All Employees with Salary More Than
SELECT first_name, last_name, salary FROM employees
WHERE salary > 50000
ORDER BY salary DESC;

-- Ex.12 Find 5 Best Paid Employees
SELECT first_name, last_name FROM employees
ORDER BY salary DESC
LIMIT 5;

-- Ex.13 Find All Employees Except Marketing
SELECT first_name, last_name FROM employees
WHERE department_id != 4;

-- Ex.14 Sort Employees Table
SELECT * FROM employees
ORDER BY salary DESC, first_name, last_name DESC, middle_name, employee_id;

-- Ex.15 Create View Employees with Salaries
CREATE VIEW `v_employees_salaries` AS 
SELECT first_name, last_name, salary FROM employees;

-- Ex.16 Create View Employees with Job Titles
CREATE VIEW `v_employees_job_titles` AS 
SELECT CONCAT(first_name, ' ', IFNULL(middle_name, ''), ' ', last_name), job_title 
FROM employees;

-- Ex.17 Distinct Job Titles
SELECT DISTINCT job_title as Job_title FROM employees;

-- Ex.18 Find First 10 Started Projects
SELECT * from projects
ORDER BY start_date, name, project_id
LIMIT 10;

-- Ex.19 Last 7 Hired Employees
SELECT first_name, last_name, hire_date FROM employees
ORDER BY hire_date DESC
LIMIT 7;

-- Ex.20 Increase Salaries
UPDATE employees
SET salary = salary * 1.12
WHERE department_id IN (1, 2, 4, 11);

SELECT salary from employees;

-- Ex.21 All Mountain Peaks
SELECT peak_name FROM peaks
ORDER BY peak_name;

-- Ex.22 Biggest Countries by Population
SELECT country_name, population FROM countries
WHERE continent_code = 'EU'
ORDER BY population DESC, country_name
LIMIT 30;

-- Ex.23 Countries and Currency (Euro / Not Euro)
SELECT country_name, country_code, 
IF(currency_code = 'EUR', 'Euro', 'Not Euro') AS 'currency' FROM countries
ORDER BY country_name

-- Ex.24 All Diablo Characters
SELECT name FROM characters
ORDER BY name;