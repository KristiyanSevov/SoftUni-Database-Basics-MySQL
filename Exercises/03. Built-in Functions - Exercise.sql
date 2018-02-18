--Ex.1 Find Names of All Employees by First Name
SELECT first_name, last_name from employees 
WHERE first_name LIKE 'Sa%'
ORDER BY employee_id;

--Ex.2 Find Names of All Employees by Last Name
SELECT first_name, last_name from employees 
WHERE last_name LIKE '%ei%'
ORDER BY employee_id;

--Ex.3 Find First Names of All Employees
SELECT first_name from employees 
WHERE (department_id = 3 OR department_id = 10) 
AND YEAR(hire_date) BETWEEN 1995 AND 2005
ORDER BY employee_id;

--Ex.4 Find All Employees Except Engineers
SELECT first_name, last_name from employees 
WHERE job_title NOT LIKE '%engineer%' 
ORDER BY employee_id;

--Ex.5 Find Towns with Name Length
SELECT name FROM towns
WHERE CHAR_LENGTH(name) in (5, 6)
ORDER BY name;

--Ex.6 Find Towns Starting With
SELECT town_id, name FROM towns
WHERE LEFT(name, 1) in ('M', 'K', 'B', 'E')
ORDER BY name;

--Ex.7 Find Towns Not Starting With
SELECT town_id, name FROM towns
WHERE LEFT(name, 1) NOT in ('R', 'B', 'D')
ORDER BY name;

--Ex.8 Create View Employees Hired After
CREATE VIEW `v_employees_hired_after_2000` AS
SELECT first_name, last_name FROM employees
WHERE YEAR(hire_date) > 2000;

--Ex.9 Length of Last Name
SELECT first_name, last_name FROM employees
WHERE CHAR_LENGTH(last_name) = 5;

--Ex.10 Countries Holding 'A'
SELECT country_name, iso_code FROM countries
WHERE country_name LIKE '%a%a%a%'
ORDER BY iso_code;

--Ex.11 Mix of Peak and River Names
SELECT peaks.peak_name, rivers.river_name, 
(LOWER(CONCAT(peaks.peak_name, SUBSTRING(rivers.river_name, 2)))) AS mix 
FROM peaks, rivers
WHERE RIGHT(peaks.peak_name, 1) = LEFT(rivers.river_name, 1)
ORDER BY mix;

--Ex.12 Games From 2011 and 2012 Year
SELECT name, DATE_FORMAT(`start`, '%Y-%m-%d') AS `start` FROM games
WHERE YEAR(`start`) in (2011, 2012)
ORDER BY `start`, name
LIMIT 50;

--Ex.13 User Email Providers
SELECT user_name, SUBSTRING(email, LOCATE('@', email)+1) AS 'Email Provider' FROM users
ORDER BY SUBSTRING(email, LOCATE('@', email)), user_name;

--Ex.14 Get Users with IP Address Like Pattern
SELECT user_name, ip_address FROM users
WHERE ip_address LIKE '___.1%.%.___'
ORDER BY user_name;

--Ex.15 Show All Games with Duration
SELECT name, 
(CASE WHEN HOUR(`start`) >= 0 AND HOUR(`start`) < 12 THEN 'Morning' 
ELSE
	(CASE WHEN HOUR(`start`) >= 12 AND HOUR(`start`) < 18 THEN 'Afternoon' 
	ELSE'Evening' END) 
END) AS 'Part of the Day', 
(CASE WHEN duration <= 3 THEN 'Extra Short' 
ELSE
	(CASE WHEN duration <= 6 THEN 'Short' 
	ELSE
		(CASE WHEN duration <= 10 THEN 'Long' 
		ELSE 'Extra Long' END)
	END)
END) AS 'Duration' FROM games

--Ex.16 Orders Table
SELECT product_name, order_date, 
(DATE_ADD(order_date, INTERVAL 3 DAY)) AS pay_due, 
(DATE_ADD(order_date, INTERVAL 1 MONTH)) AS deliver_due FROM orders;