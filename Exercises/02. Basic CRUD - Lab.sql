-- Ex.1 Select Employee Information
SELECT id, first_name, last_name, job_title FROM employees
ORDER BY id;

-- Ex.2 Select Employees with Filter
SELECT id, CONCAT(first_name, ' ', last_name), job_title, salary FROM employees
WHERE salary > 1000 
ORDER BY id;

-- Ex.3 Update Salary and Select
UPDATE employees
SET salary = salary * 1.1
WHERE job_title = 'Therapist';

SELECT salary FROM employees
ORDER BY salary;

-- Ex.4 Top Paid Employee
SELECT * FROM employees
ORDER BY salary DESC
LIMIT 1;

-- Ex.5 Select Employees by Multiple Filters
SELECT * FROM employees
WHERE department_id = 4 AND salary >= 1600
ORDER BY id;

-- Ex.6 Delete from Table
DELETE FROM employees
WHERE department_id = 2 OR department_id = 1;

SELECT * from employees ORDER BY id;
