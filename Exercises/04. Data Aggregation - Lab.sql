-- Ex.1 Departments Info
SELECT department_id, COUNT(first_name) AS 'Number of employees' FROM employees
GROUP BY department_id
ORDER BY department_id, COUNT(id);

-- Ex.2 Average Salary
SELECT department_id, ROUND(AVG(salary),2) AS 'Average Salary' FROM employees
GROUP BY department_id
ORDER BY department_id, COUNT(id);

-- Ex.3 Minimum Salary
SELECT department_id, ROUND(MIN(salary), 2) AS 'Min Salary' FROM employees
GROUP BY department_id
HAVING MIN(salary) > 800;

-- Ex.4 Appetizers Count
SELECT COUNT(category_id) FROM products
WHERE category_id = 2 AND price > 8;

-- Ex.5 Menu Prices
SELECT category_id, ROUND(AVG(price), 2) AS 'Average Price',
ROUND(MIN(price), 2) AS 'Cheapest Product', ROUND(MAX(price), 2)
AS 'Most Expensive Product' FROM products
GROUP BY category_id;