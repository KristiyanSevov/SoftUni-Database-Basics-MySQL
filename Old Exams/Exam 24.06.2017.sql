--Ex.1 Table Design
CREATE TABLE users(
id INT NOT NULL PRIMARY KEY,
username VARCHAR(30) NOT NULL UNIQUE,
`password` VARCHAR(30) NOT NULL,
email VARCHAR(50));

CREATE TABLE categories(
id INT NOT NULL PRIMARY KEY,
name VARCHAR(50) NOT NULL,
parent_id INT,
FOREIGN KEY (parent_id) REFERENCES categories(id));

CREATE TABLE contests(
id INT NOT NULL PRIMARY KEY,
name VARCHAR(50) NOT NULL,
category_id INT,
FOREIGN KEY (category_id) REFERENCES categories(id));

CREATE TABLE users_contests(
user_id INT,
contest_id INT,
PRIMARY KEY (user_id, contest_id),
FOREIGN KEY (user_id) REFERENCES users(id),
FOREIGN KEY (contest_id) REFERENCES contests(id));

CREATE TABLE problems(
id INT NOT NULL PRIMARY KEY,
name VARCHAR(100) NOT NULL,
points INT NOT NULL,
tests INT DEFAULT 0,
contest_id INT,
FOREIGN KEY (contest_id) REFERENCES contests(id));

CREATE TABLE submissions(
id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
passed_tests INT NOT NULL,
problem_id INT,
user_id INT,
FOREIGN KEY (problem_id) REFERENCES problems(id),
FOREIGN KEY(user_id) REFERENCES users(id));

--Ex.2 Data Insertion
INSERT INTO submissions (passed_tests, problem_id, user_id)
SELECT CEIL(SQRT(POW(CHAR_LENGTH(name), 3)) - CHAR_LENGTH(name)), id, CEIL(id * 3 / 2) 
FROM problems 
ORDER BY id 
LIMIT 10;

--Ex.3 Data Update
UPDATE problems as p 
JOIN contests as c ON p.contest_id = c.id
JOIN categories as cat on c.category_id = cat.id
SET p.tests = 
(CASE 
	WHEN p.id % 3 = 0 THEN CHAR_LENGTH(cat.name)
	WHEN p.id % 3 = 1 THEN (
		SELECT sums.our_sum FROM 
			(SELECT p.id, SUM(s.id) as our_sum from problems as p 
			JOIN submissions as s on p.id = s.problem_id
			GROUP BY p.id) as sums 
		WHERE p.id = sums.id)
	WHEN p.id % 3 = 2 THEN CHAR_LENGTH(c.name) 
END)
WHERE p.tests = 0;

--Ex.4 Data Deletion
DELETE FROM users 
WHERE (SELECT u.user_id FROM users_contests as u WHERE u.user_id = id LIMIT 1) IS NULL;

--Ex.5 Users
SELECT id, username, email FROM users
ORDER BY id;

--Ex.6 Root Categories
SELECT id, name FROM categories
WHERE parent_id IS NULL
ORDER BY id;

--Ex.7 Well Tested Problems
SELECT id, name, tests FROM problems
WHERE tests > points AND name REGEXP '^[^ ]+ [^ ]+$'
ORDER BY id DESC;

--Ex.8 Full Path Problems
SELECT p.id, CONCAT(cat.name, ' - ', c.name, ' - ', p.name) as full_path
FROM problems as p 
JOIN contests as c ON p.contest_id = c.id
JOIN categories as cat ON c.category_id = cat.id
ORDER BY p.id;

--Ex.9 Leaf Categories
SELECT id, name FROM categories
WHERE id NOT IN (SELECT parent_id FROM categories WHERE parent_id IS NOT NULL)
ORDER BY name, id;

--Ex.10 Mainstream Passwords
SELECT id, username, `password` FROM users as u1
WHERE `password` IN (SELECT `password` FROM users as u2 WHERE u2.id != u1.id)
ORDER BY username, id;

--Ex.11 Most Participated Contests
SELECT * FROM 
	(SELECT c.id, c.name, COUNT(u_c.user_id) as contestants FROM contests as c 
	LEFT JOIN users_contests as u_c ON c.id = u_c.contest_id
	GROUP BY u_c.contest_id
	ORDER BY contestants DESC LIMIT 5) as derived
ORDER BY contestants, id;

--Ex.12 Most Valuable Person
SELECT s.id, u.username, p.name, CONCAT(s.passed_tests, ' / ', p.tests) as result
FROM submissions as s 
JOIN users as u ON s.user_id = u.id
JOIN problems as p ON s.problem_id = p.id
WHERE u.id = (SELECT derived.id FROM 
	(SELECT u.id, COUNT(u_c.contest_id) as count_c FROM users as u
	JOIN users_contests as u_c ON u.id = u_c.user_id
	GROUP BY u.id
	ORDER BY count_c DESC LIMIT 1) as derived)
ORDER BY s.id DESC;

--Ex.13 Contests Maximum Points
SELECT c.id, c.name, SUM(p.points) as maximum_points FROM contests as c 
JOIN problems as p ON c.id = p.contest_id
GROUP BY c.id, c.name
ORDER BY maximum_points DESC, c.id;

--Ex.14 Contestants Submissions
SELECT c.id, c.name, COUNT(s.id) as `submissions` FROM contests as c 
JOIN problems as p ON c.id = p.contest_id 
JOIN submissions as s ON s.problem_id = p.id AND 
	(SELECT contest_id FROM users_contests 
	WHERE s.user_id = user_id AND p.contest_id = contest_id 
	LIMIT 1) IS NOT NULL
GROUP BY c.id, c.name
ORDER BY `submissions` DESC, id;

--Ex.15 Login
CREATE PROCEDURE udp_login(username VARCHAR(30), `password` VARCHAR(30))
BEGIN 
	CASE WHEN (SELECT id FROM users as u WHERE u.username = username) IS NULL
		THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Username does not exist!';
	   WHEN (SELECT id FROM users as u WHERE u.username = username AND u.`password` = `password`) IS NULL 
	      THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Password is incorrect!';
	   WHEN (SELECT id FROM logged_in_users as l WHERE l.username = username) IS NOT NULL
	      THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'User is already logged in!';
	   ELSE 
		 INSERT INTO logged_in_users (id, username, `password`, email) 
		 SELECT u.id, u.username, u.`password`, u.email FROM users as u
		 WHERE u.username = username;
	END CASE;
END;

--Ex.16 Evaluate Submission
CREATE PROCEDURE udp_evaluate(id INT)
BEGIN 
	CASE WHEN (SELECT id FROM submissions as s WHERE s.id = id) IS NULL
		THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Submission does not exist!';
	ELSE 
		INSERT INTO evaluated_submissions (id, problem, `user`, result) 
		SELECT s.id, p.name, u.username, CEIL(p.points / p.tests * s.passed_tests) FROM submissions as s 
		JOIN users as u ON s.user_id = u.id
		JOIN problems as p ON s.problem_id = p.id
		WHERE s.id = id;
	END CASE;
END;

--Ex.17 Check Constraint
CREATE TRIGGER my_trigger BEFORE INSERT ON problems
FOR EACH ROW
BEGIN 
	CASE WHEN NEW.name NOT LIKE '% %'
		THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'The given name is invalid!';
	WHEN NEW.points <= 0
		THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'The problem’s points cannot be less or equal to 0!';
	WHEN NEW.tests <= 0
		THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'The problem’s tests cannot be less or equal to 0!';
	ELSE BEGIN END;
END CASE;
END;
