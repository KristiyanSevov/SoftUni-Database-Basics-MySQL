--Ex.1 Count Employees by Town
CREATE FUNCTION ufn_count_employees_by_town(town_name VARCHAR(50))
RETURNS INT
BEGIN
	DECLARE result INT;
	SET result := (SELECT COUNT(e.employee_id) FROM employees as e
			JOIN addresses as a ON e.address_id = a.address_id
			JOIN towns as t ON a.town_id = t.town_id
			WHERE t.name = town_name);
	RETURN result;
END;

--Ex.2 Employees Promotion
CREATE PROCEDURE usp_raise_salaries(department_name VARCHAR(50))
BEGIN 
	UPDATE employees as e JOIN departments as d 
	ON e.department_id = d.department_id AND d.name = department_name
	SET e.salary = e.salary * 1.05;
END;
	
--Ex.3 Employees Promotion By ID
CREATE PROCEDURE usp_raise_salary_by_id(id INT)
BEGIN
	START TRANSACTION;
	CASE WHEN (SELECT employee_id FROM employees WHERE employee_id = id) IS NULL
	THEN ROLLBACK;
	ELSE
		UPDATE employees
		SET salary = salary*1.05
		WHERE employee_id = id;
	END CASE;
	COMMIT;
END;

--Ex.4 Triggered
CREATE TABLE deleted_employees(
employee_id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
first_name VARCHAR(50),
last_name VARCHAR(50),
middle_name VARCHAR(50),
job_title VARCHAR(50),
department_id INT,
salary DECIMAL(19,4));

CREATE TRIGGER log_deleted_employees AFTER DELETE ON employees
FOR EACH ROW
BEGIN
	INSERT INTO deleted_employees 
	(first_name, last_name, middle_name, job_title, department_id, salary)
	VALUES (OLD.first_name, OLD.last_name, OLD.middle_name,
	OLD.job_title, OLD.department_id, OLD.salary);
END;
