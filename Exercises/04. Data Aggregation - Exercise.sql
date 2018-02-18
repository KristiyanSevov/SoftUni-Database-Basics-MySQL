--Ex.1 Records Count
SELECT COUNT(id) AS count FROM wizzard_deposits;

--Ex.2 Longest Magic Wand
SELECT MAX(magic_wand_size) AS longest_magic_wand FROM wizzard_deposits;

--Ex.3 Longest Magic Wand per Deposit Groups
SELECT deposit_group, MAX(magic_wand_size) AS longest_magic_wand FROM wizzard_deposits
GROUP BY (deposit_group)
ORDER BY longest_magic_wand, deposit_group;

--Ex.4 Smallest Deposit Group per Magic Wand Size
SELECT deposit_group FROM wizzard_deposits
GROUP BY (deposit_group)
ORDER BY AVG(magic_wand_size)
LIMIT 1;

--Ex.5 Deposits Sum
SELECT deposit_group, SUM(deposit_amount) AS total_sum FROM wizzard_deposits
GROUP BY (deposit_group)
ORDER BY total_sum;

--Ex.6 Deposits Sum for Ollivander Family
SELECT deposit_group, SUM(deposit_amount) AS total_sum FROM wizzard_deposits
WHERE magic_wand_creator = 'Ollivander family'
GROUP BY (deposit_group)
ORDER BY deposit_group;

--Ex.7 Deposits Filter
SELECT deposit_group, SUM(deposit_amount) AS total_sum FROM wizzard_deposits
WHERE magic_wand_creator = 'Ollivander family'
GROUP BY (deposit_group)
HAVING total_sum < 150000
ORDER BY total_sum DESC;

--Ex.8 Deposit Charge
SELECT deposit_group, magic_wand_creator, 
MIN(deposit_charge) AS min_deposit_charge FROM wizzard_deposits
GROUP BY deposit_group, magic_wand_creator
ORDER BY magic_wand_creator, deposit_group;

--Ex.9 Age Groups
SELECT CASE 
	WHEN age <= 10 THEN '[0-10]'
	WHEN age <= 20 THEN '[11-20]'
	WHEN age <= 30 THEN '[21-30]'
	WHEN age <= 40 THEN '[31-40]'
	WHEN age <= 50 THEN '[41-50]'
	WHEN age <= 60 THEN '[51-60]'
	ELSE '[61+]' END
AS age_group, COUNT(id) AS wizard_count FROM wizzard_deposits
GROUP BY age_group
ORDER BY wizard_count

--Ex.10 First Letter
SELECT LEFT(first_name, 1) AS first_letter FROM wizzard_deposits
WHERE deposit_group = 'Troll Chest'
GROUP BY first_letter
ORDER BY first_letter;

--Ex.11 Average Interest
SELECT deposit_group, is_deposit_expired, 
AVG(deposit_interest) AS average_interest FROM wizzard_deposits
WHERE deposit_start_date > DATE('1985-01-01')
GROUP BY deposit_group, is_deposit_expired
ORDER BY deposit_group DESC, is_deposit_expired;

--Ex.12 Rich Wizard, Poor Wizard
SELECT SUM(sums) AS sum_difference FROM 
	(SELECT (deposit_amount - 
					(SELECT deposit_amount FROM wizzard_deposits AS t2 
					WHERE t2.id = t1.id + 1)
			) AS sums 
		FROM wizzard_deposits AS t1
	) AS derived_table;
	
--Ex.13 Employees Minimum Salaries
SELECT department_id, MIN(salary) AS minimum_salary FROM employees
WHERE department_id IN (2, 5, 7) AND hire_date > DATE('2000-01-01')
GROUP BY department_id
ORDER BY department_id;

--Ex.14 Employees Average Salaries
CREATE TABLE new_table AS SELECT * FROM employees
WHERE salary > 30000;

DELETE FROM new_table
WHERE manager_id = 42;

UPDATE new_table
SET salary = salary + 5000
WHERE department_id = 1;

SELECT department_id, AVG(salary) AS avg_salary FROM new_table
GROUP BY department_id
ORDER BY department_id;

--Ex.15 Employees Maximum Salaries
SELECT department_id, MAX(salary) AS max_salary FROM employees
GROUP BY department_id
HAVING max_salary < 30000 OR max_salary > 70000
ORDER BY department_id;

--Ex.16 Employees Count Salaries
SELECT COUNT(salary) FROM employees
WHERE manager_id IS NULL;

--Ex.17 3rd Highest Salary
SELECT department_id, 
(
	SELECT DISTINCT salary FROM employees AS t2 
	WHERE t1.department_id = t2.department_id 
	ORDER BY salary DESC LIMIT 2, 1
) AS third_highest_salary FROM employees AS t1
GROUP BY department_id 
HAVING third_highest_salary IS NOT NULL
ORDER BY department_id;

--Ex.18 Salary Challenge
SELECT first_name, last_name, department_id FROM employees AS t1
WHERE salary > (SELECT AVG(salary) FROM employees AS t2 
				WHERE t1.department_id = t2.department_id)
ORDER BY department_id, employee_id
LIMIT 10;

--Ex.19 Departments Total Salaries
SELECT department_id, SUM(salary) AS total_salary FROM employees
GROUP BY department_id
ORDER BY department_id;