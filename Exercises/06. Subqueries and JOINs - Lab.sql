-- Ex.1 Managers
SELECT employee_id, CONCAT(e.first_name, ' ', e.last_name) as full_name, d.department_id, d.name FROM
employees as e JOIN departments as d ON e.employee_id = d.manager_id
ORDER BY employee_id LIMIT 5;

-- Ex.2 Towns and Addresses
SELECT a.town_id, t.name AS town_name, a.address_text FROM addresses as a
JOIN towns as t ON a.town_id=t.town_id
WHERE t.name in ('San Francisco', 'Sofia', 'Carnation')
ORDER BY town_id, address_id;

-- Ex.3 Employees Without Managers
SELECT employee_id, first_name, last_name, department_id, salary FROM employees
WHERE manager_id IS NULL;

-- Ex.4 High Salary
SELECT COUNT(employee_id) FROM employees
WHERE salary > (SELECT AVG(salary) FROM employees);