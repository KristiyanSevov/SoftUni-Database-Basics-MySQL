-- Ex.1 Employees with Salary Above 35000
CREATE PROCEDURE usp_get_employees_salary_above_35000()
BEGIN
	SELECT first_name, last_name FROM employees 
	WHERE salary > 35000 
	ORDER BY first_name, last_name, employee_id;
END;

-- Ex.2. Employees with Salary Above Number
CREATE PROCEDURE usp_get_employees_salary_above(salary DOUBLE)
BEGIN
	SELECT e.first_name, e.last_name FROM employees as e
	WHERE e.salary >= salary 
	ORDER BY e.first_name, e.last_name, e.employee_id;
END;

-- Ex.3. Town Names Starting With
CREATE PROCEDURE usp_get_towns_starting_with(str VARCHAR(50))
BEGIN
	SELECT name as town_name FROM towns 
	WHERE LEFT(name, CHAR_LENGTH(str)) = str
	ORDER BY name;
END;

-- Ex.4. Employees from Town
CREATE PROCEDURE usp_get_employees_from_town(town_name VARCHAR(50))
BEGIN
	SELECT e.first_name, e.last_name FROM towns as t 
	JOIN addresses as a ON t.town_id = a.town_id
	JOIN employees as e ON a.address_id = e.address_id 
	WHERE t.name = town_name
	ORDER BY e.first_name, e.last_name, e.employee_id;
END;

-- Ex.5. Salary Level Function
CREATE FUNCTION ufn_get_salary_level(salary DOUBLE)
RETURNS VARCHAR(50)
BEGIN
	DECLARE result VARCHAR(50);
	SET result = (CASE WHEN salary < 30000 THEN 'Low'
		 WHEN salary BETWEEN 30000 AND 50000 THEN 'Average'
		 ELSE 'High' END);
	RETURN result;
END;

-- Ex.6. Employees by Salary Level
CREATE FUNCTION ufn_get_salary_level(salary DOUBLE)
RETURNS VARCHAR(50)
BEGIN
	DECLARE result VARCHAR(50);
	SET result = (CASE WHEN salary < 30000 THEN 'Low'
		 WHEN salary BETWEEN 30000 AND 50000 THEN 'Average'
		 ELSE 'High' END);
	RETURN result;
END;

CREATE PROCEDURE usp_get_employees_by_salary_level(sal_level VARCHAR(50))
BEGIN 
	SELECT first_name, last_name FROM employees
	WHERE ufn_get_salary_level(salary) = sal_level
	ORDER BY first_name DESC, last_name DESC;
END;

-- Ex.7. Define Function
CREATE FUNCTION ufn_is_word_comprised(set_of_letters varchar(50), word varchar(50))
RETURNS INT
BEGIN
	DECLARE result INT;
	DECLARE counter INT;
	DECLARE our_char VARCHAR(30);
	SET result = 1;
	SET counter = 0;
	REPEAT
		SET our_char = SUBSTRING(word, counter, 1);
		SET result = IF(set_of_letters NOT LIKE CONCAT('%', our_char, '%'), 0, 1);
		SET counter = counter + 1;
	UNTIL result = 0 OR counter = CHAR_LENGTH(word) + 1
	END REPEAT;
	RETURN result;
END;

-- Ex.8 Find Full Name
CREATE PROCEDURE usp_get_holders_full_name ()
BEGIN 
	SELECT CONCAT(first_name, ' ', last_name) as full_name FROM account_holders
	ORDER BY full_name, id;
END;

-- Ex.9 People with Balance Higher Than
CREATE PROCEDURE usp_get_holders_with_balance_higher_than(num DOUBLE)
BEGIN 
	SELECT h.first_name, h.last_name FROM account_holders as h
	JOIN accounts as a ON a.account_holder_id = h.id
	GROUP BY (h.id) HAVING SUM(a.balance) > num
	ORDER BY a.id, h.first_name, h.last_name;
END;

-- Ex.10 Future Value Function
CREATE FUNCTION ufn_calculate_future_value(total DOUBLE, rate DOUBLE, years INT)
returns DOUBLE
BEGIN 
	DECLARE result DOUBLE;
	SET result = total * POW((1 + rate), years);
	return ROUND(result, 2);
END;

-- Ex.11 Calculating Interest
CREATE FUNCTION ufn_calculate_future_value(total DECIMAL(20,4), rate DECIMAL(15,4), years INT)
returns DECIMAL(20,4)
BEGIN 
	DECLARE result DECIMAL(20,4);
	SET result = total * POW((1 + rate), years);
	return result;
END;

CREATE PROCEDURE usp_calculate_future_value_for_account(account_id INT, interest_rate DECIMAL(15, 4))
BEGIN
	SELECT a.id, a_h.first_name, a_h.last_name, a.balance as current_balance,
	ufn_calculate_future_value(a.balance, interest_rate, 5) as balance_in_5_years 
	FROM accounts as a 
	JOIN account_holders as a_h ON a.account_holder_id = a_h.id
	WHERE a.id = account_id;
END; 

-- Ex.12 Deposit Money
CREATE PROCEDURE usp_deposit_money(account_id INT, money_amount DECIMAL(20,4))
BEGIN
START TRANSACTION;
	CASE WHEN money_amount < 0 
		THEN ROLLBACK;
	ELSE 
		UPDATE accounts as a 
		SET a.balance = a.balance + money_amount
        	WHERE a.id = account_id;
	END CASE;
COMMIT;
END; 

-- Ex.13 Withdraw Money
CREATE PROCEDURE usp_withdraw_money(account_id INT, money_amount DECIMAL(20,4))
BEGIN
START TRANSACTION;
	CASE WHEN money_amount < 0 OR money_amount > (SELECT a.balance FROM accounts as a
						      WHERE a.id = account_id)
		THEN ROLLBACK;
	ELSE 
		UPDATE accounts as a 
		SET a.balance = a.balance - money_amount
        	WHERE a.id = account_id;
	END CASE;
COMMIT;
END; 

-- Ex.14 Money Transfer
CREATE PROCEDURE usp_transfer_money(from_account_id INT, to_account_id INT, amount DECIMAL(20,4))
BEGIN
	START TRANSACTION;
	CASE WHEN ((SELECT a.id FROM accounts as a WHERE a.id = from_account_id) IS NULL)
			OR ((SELECT a.id FROM accounts as a WHERE a.id = to_account_id) IS NULL)
			OR from_account_id = to_account_id
			OR amount < 0 
			OR amount > (SELECT a.balance FROM accounts as a
				     WHERE a.id = from_account_id)
		THEN ROLLBACK;
	ELSE 
		UPDATE accounts as a 
		SET a.balance = a.balance - amount
		WHERE a.id = from_account_id;
		UPDATE accounts as a
		SET a.balance = a.balance + amount
		WHERE a.id = to_account_id;
	END CASE;
	COMMIT;
END; 

-- Ex.15 Log Accounts Trigger
CREATE TABLE `logs`(
log_id INT PRIMARY KEY AUTO_INCREMENT,
account_id INT NOT NULL,
old_sum DECIMAL(20,4) NOT NULL,
new_sum DECIMAL(20,4) NOT NULL);

CREATE TRIGGER log_balance_changes AFTER UPDATE ON accounts 
FOR EACH ROW
BEGIN
	CASE WHEN OLD.balance != NEW.balance THEN 
		INSERT INTO `logs`(account_id, old_sum, new_sum)
		VALUES (OLD.id, OLD.balance, NEW.balance);
	ELSE
		BEGIN END;
	END CASE;
END;

-- Ex.16 Emails Trigger
CREATE TABLE `logs`(
log_id INT PRIMARY KEY AUTO_INCREMENT,
account_id INT NOT NULL,
old_sum DECIMAL(20,4) NOT NULL,
new_sum DECIMAL(20,4) NOT NULL);

CREATE TRIGGER log_balance_changes AFTER UPDATE ON accounts 
FOR EACH ROW
BEGIN
	CASE WHEN OLD.balance != NEW.balance THEN 
		 INSERT INTO `logs`(account_id, old_sum, new_sum)
		 VALUES (OLD.id, OLD.balance, NEW.balance);
	ELSE
		BEGIN END;
	END CASE;
END;

CREATE TABLE notification_emails(
id INT PRIMARY KEY AUTO_INCREMENT,
recipient INT NOT NULL,
subject VARCHAR(50) NOT NULL,
body TEXT NOT NULL);

CREATE TRIGGER create_notification_email AFTER INSERT ON `logs` 
FOR EACH ROW
BEGIN 
	INSERT INTO notification_emails (recipient, subject, body)
	VALUES (NEW.account_id, CONCAT('Balance change for account: ', NEW.account_id),
	CONCAT('On ', DATE_FORMAT(NOW(), '%b %d %Y'), ' at ', DATE_FORMAT(NOW(), '%r'),
	' your account balance was changed from ', NEW.old_sum, ' to ', NEW.new_sum, '.'));
END;
