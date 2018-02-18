-- Ex.1 Employee Address
SELECT e.employee_id, e.job_title, e.address_id, ad.address_text 
FROM employees as e JOIN addresses as ad ON e.address_id = ad.address_id
ORDER BY e.address_id LIMIT 5;

-- Ex.2 Addresses with Towns
SELECT e.first_name, e.last_name, t.name as town, ad.address_text 
FROM employees as e 
JOIN addresses as ad ON e.address_id = ad.address_id
JOIN towns as t ON ad.town_id = t.town_id
ORDER BY e.first_name, e.last_name LIMIT 5;

-- Ex.3 Sales Employee
SELECT e.employee_id, e.first_name, e.last_name, d.name as department_name
FROM employees as e 
JOIN departments as d ON e.department_id = d.department_id
WHERE d.name = 'Sales'
ORDER BY e.employee_id DESC;

-- Ex.4 Employee Departments
SELECT e.employee_id, e.first_name, e.salary, d.name as department_name
FROM employees as e 
JOIN departments as d ON e.department_id = d.department_id
WHERE e.salary > 15000
ORDER BY d.department_id DESC LIMIT 5;

-- Ex.5 Employees Without Project
SELECT e.employee_id, e.first_name
FROM employees as e 
LEFT JOIN employees_projects as e_p ON e.employee_id = e_p.employee_id
LEFT JOIN projects as p ON e_p.project_id = p.project_id
WHERE p.project_id IS NULL
ORDER BY e.employee_id DESC LIMIT 3;

-- Ex.6	Employees Hired After
SELECT e.first_name, e.last_name, e.hire_date, d.name as dept_name FROM employees as e
JOIN departments as d ON e.department_id = d.department_id
WHERE DATE(e.hire_date) > DATE('1999-01-01') AND d.name IN ('Sales', 'Finance')
ORDER BY e.hire_date;

-- Ex.7 Employees with Project
SELECT e.employee_id, e.first_name, p.name as project_name FROM employees as e 
JOIN employees_projects as e_p ON e.employee_id = e_p.employee_id
JOIN projects as p ON e_p.project_id = p.project_id
WHERE DATE(p.start_date) > DATE('2002-08-13') AND p.end_date IS NULL
ORDER BY e.first_name, project_name LIMIT 5;

-- Ex.8 Employee 24
SELECT e.employee_id, e.first_name, 
IF(p.start_date >= DATE('2005-01-01'), NULL, p.name) as project_name FROM employees as e 
JOIN employees_projects as e_p ON e.employee_id = e_p.employee_id
JOIN projects as p ON e_p.project_id = p.project_id
WHERE e.employee_id = 24
ORDER BY e.first_name, p.name;

-- Ex.9	Employee Manager
SELECT e1.employee_id, e1.first_name, e1.manager_id, e2.first_name FROM employees as e1 
JOIN employees as e2 ON e1.manager_id = e2.employee_id
WHERE e1.manager_id IN (3, 7)
ORDER BY e1.first_name;

-- Ex.10 Employee Summary
SELECT e1.employee_id, CONCAT(e1.first_name, ' ', e1.last_name) as employee_name,
CONCAT(e2.first_name, ' ', e2.last_name) as manager_name, 
d.name as department_name FROM employees as e1 
JOIN employees as e2 ON e1.manager_id = e2.employee_id
JOIN departments as d on e1.department_id = d.department_id
WHERE e1.manager_id IS NOT NULL
ORDER BY e1.employee_id LIMIT 5;

-- Ex.11 Min Average Salary
SELECT AVG(e.salary) AS min_average_salary FROM employees as e 
JOIN departments as d ON e.department_id = d.department_id
GROUP BY e.department_id
ORDER BY min_average_salary LIMIT 1;

-- Ex.12 Highest Peaks in Bulgaria
SELECT c.country_code, m.mountain_range, p.peak_name, p.elevation FROM mountains as m 
JOIN mountains_countries as m_c ON m.id = m_c.mountain_id
JOIN countries as c ON m_c.country_code = c.country_code
JOIN peaks as p ON p.mountain_id = m.id
WHERE c.country_name = 'Bulgaria' AND p.elevation > 2835
ORDER BY p.elevation DESC;

-- Ex.13 Count Mountain Ranges
SELECT c.country_code, COUNT(m.mountain_range) as mountain_range FROM mountains as m 
JOIN mountains_countries as m_c ON m.id = m_c.mountain_id
JOIN countries as c ON m_c.country_code = c.country_code
WHERE c.country_name IN ('Russia', 'Bulgaria', 'United States')
GROUP BY c.country_code
ORDER BY mountain_range DESC;

-- Ex.14 Countries with Rivers
SELECT c.country_name, r.river_name FROM countries as c 
LEFT JOIN countries_rivers as c_r ON c.country_code = c_r.country_code
LEFT JOIN rivers as r ON r.id = c_r.river_id
JOIN continents as con ON c.continent_code = con.continent_code
WHERE con.continent_name = 'Africa'
ORDER BY c.country_name LIMIT 5;

-- Ex.15 Continents and Currencies
SELECT d1.continent_code, d1.currency_code, d1.cnt FROM 
	(SELECT c1.continent_code, c1.currency_code, COUNT(c1.currency_code) as cnt 
	FROM countries as c1 
	GROUP BY c1.continent_code, c1.currency_code 
	ORDER BY cnt DESC) as d1
JOIN 
	(SELECT continent_code, MAX(cnt) as max_count 
		FROM (SELECT DISTINCT c1.continent_code, COUNT(c1.currency_code) as cnt 
			FROM countries as c1 
			GROUP BY c1.continent_code, c1.currency_code 
			ORDER BY cnt DESC) as derived
	GROUP BY continent_code) as d2
ON d1.continent_code = d2.continent_code AND d1.cnt = d2.max_count
HAVING cnt > 1
ORDER BY d1.continent_code, d1.currency_code

-- Ex.16 Countries without any Mountains
SELECT COUNT(c.country_code) as country_count FROM countries as c
LEFT JOIN mountains_countries as m_c ON c.country_code = m_c.country_code
WHERE m_c.mountain_id IS NULL;

-- Ex.17 Highest Peak and Longest River by Country
SELECT c.country_name, MAX(p.elevation) as highest_peak_elevation,
MAX(r.`length`) as longest_river_length FROM countries as c 
LEFT JOIN mountains_countries as m_c ON c.country_code = m_c.country_code
LEFT JOIN mountains as m ON m.id = m_c.mountain_id
LEFT JOIN peaks as p ON m.id = p.mountain_id
LEFT JOIN countries_rivers as c_r ON c.country_code = c_r.country_code
LEFT JOIN rivers as r ON c_r.river_id = r.id
GROUP BY c.country_name
ORDER BY highest_peak_elevation DESC, longest_river_length DESC, c.country_name
LIMIT 5;
