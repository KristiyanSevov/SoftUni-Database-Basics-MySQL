--Ex.1 Table Design
CREATE TABLE users(
id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
username VARCHAR(30) NOT NULL UNIQUE,
`password` VARCHAR(30) NOT NULL,
email VARCHAR(50) NOT NULL);

CREATE TABLE repositories(
id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
name VARCHAR(50) NOT NULL);

CREATE TABLE repositories_contributors(
repository_id INT,
contributor_id INT,
FOREIGN KEY (repository_id) REFERENCES repositories(id),
FOREIGN KEY (contributor_id) REFERENCES users(id));

CREATE TABLE issues(
id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
title VARCHAR(255) NOT NULL,
issue_status VARCHAR(6) NOT NULL,
repository_id INT NOT NULL,
assignee_id INT NOT NULL,
FOREIGN KEY (repository_id) REFERENCES repositories(id),
FOREIGN KEY (assignee_id) REFERENCES users(id));

CREATE TABLE commits(
id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
message VARCHAR(255) NOT NULL,
issue_id INT,
repository_id INT NOT NULL,
contributor_id INT NOT NULL,
FOREIGN KEY (issue_id) REFERENCES issues(id),
FOREIGN KEY (repository_id) REFERENCES repositories(id),
FOREIGN KEY (contributor_id) REFERENCES users(id));

CREATE TABLE files(
id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
name VARCHAR(100) NOT NULL,
size DECIMAL(10,2) NOT NULL,
parent_id INT,
commit_id INT NOT NULL,
FOREIGN KEY (parent_id) REFERENCES files(id),
FOREIGN KEY (commit_id) REFERENCES commits(id));

--Ex.2 Insert
INSERT INTO issues (title, issue_status, repository_id, assignee_id)
SELECT CONCAT('Critical Problem With ', f.name, '!'), 'open', CEIL(f.id * 2 / 3), c.contributor_id
FROM files as f JOIN commits as c ON f.commit_id = c.id
WHERE f.id BETWEEN 46 AND 50;

--Ex.3 Update
UPDATE repositories_contributors
SET repository_id = (SELECT * FROM 
	(SELECT MIN(r.id) FROM repositories as r 
	LEFT JOIN repositories_contributors as r_c ON r.id = r_c.repository_id
	WHERE r_c.contributor_id IS NULL) as d)
WHERE repository_id = contributor_id;

--Ex.4 Delete
DELETE FROM repositories 
WHERE id NOT IN (SELECT repository_id FROM issues);

--Ex.5 Users
SELECT id, username FROM users 
ORDER BY id;

--Ex.6 Lucky Numbers
SELECT repository_id, contributor_id FROM repositories_contributors
WHERE repository_id = contributor_id
ORDER BY repository_id;

--Ex.7 Heavy HTML
SELECT id, name, size FROM files
WHERE size > 1000 AND name LIKE '%html%'
ORDER BY size DESC;

--Ex.8 IssuesAndUsers
SELECT i.id, CONCAT(u.username, ' : ', i.title) as issue_assignee FROM issues as i 
JOIN users as u ON i.assignee_id = u.id
ORDER BY i.id DESC;

--Ex.9 NonDirectoryFiles
SELECT f.id, f.name, CONCAT(f.size, 'KB') as size FROM files as f
WHERE f.id NOT IN (SELECT f2.parent_id FROM files as f2 WHERE f2.parent_id IS NOT NULL)
ORDER BY f.id;

--Ex.10 ActiveRepositories
SELECT r.id, r.name, COUNT(i.id) as `issues` FROM repositories as r 
JOIN issues as i ON r.id = i.repository_id
GROUP BY r.id, r.name
ORDER BY `issues` DESC, r.id
LIMIT 5;

--Ex.11 MostContributedRepository
SELECT r.id, r.name, 
(SELECT COUNT(c.id) FROM commits as c WHERE c.repository_id = r.id) as commits, 
COUNT(r_c.contributor_id) as contributors FROM repositories_contributors as r_c
JOIN repositories as r ON r_c.repository_id = r.id
GROUP BY r_c.repository_id
HAVING contributors = (SELECT COUNT(r_c.contributor_id) as contributors 
							FROM repositories_contributors as r_c
							GROUP BY r_c.repository_id
							ORDER BY contributors DESC LIMIT 1)
ORDER BY r.id LIMIT 1;

--Ex.12 FixingMyOwnProblems
SELECT u.id, u.username, IFNULL(COUNT(c.id), 0) as `commits` FROM users as u
LEFT JOIN issues as i ON u.id = i.assignee_id 
LEFT JOIN commits as c ON u.id = c.contributor_id AND c.issue_id = i.id
GROUP BY u.id, u.username
ORDER BY `commits` DESC, u.id;

--Ex.13 RecursiveCommits
SELECT SUBSTRING(f.name, 1, LOCATE('.', f.name)-1) as `file`,
(SELECT COUNT(c.id) FROM commits as c WHERE c.message LIKE CONCAT('%', f.name, '%'))
as recursive_count
FROM files as f
WHERE f.id = (SELECT f2.parent_id FROM files as f2 WHERE f2.id = f.parent_id)
AND f.id != f.parent_id
ORDER BY `file`;

--Ex.14 RepositoriesAndCommits
SELECT r.id, r.name, COUNT(DISTINCT c.contributor_id) as `users` FROM commits as c 
RIGHT JOIN repositories as r ON r.id = c.repository_id
GROUP BY r.id, r.name
ORDER BY `users` DESC, r.id;

--Ex.15 Commit
CREATE PROCEDURE udp_commit(username VARCHAR(30), `password` VARCHAR(30),
message VARCHAR(255), issue_id INT)
BEGIN
	CASE WHEN (SELECT u.id FROM users as u WHERE u.username = username) IS NULL
		THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No such user!';
	WHEN (SELECT u.`password` FROM users as u WHERE u.username = username) != `password`
		THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Password is incorrect!';
	WHEN (SELECT i.id FROM issues as i WHERE i.id = issue_id) IS NULL
		THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'The issue does not exist!';
	ELSE 
		INSERT INTO commits (message, issue_id, repository_id, contributor_id)
		VALUES (message, issue_id, 
		(SELECT i.repository_id FROM issues as i WHERE i.id = issue_id),
		(SELECT u.id FROM users as u WHERE u.username = username));
		
		UPDATE issues 
		SET issue_status = 'closed'
		WHERE id = issue_id;
	END CASE;
END;

--Ex.16 Filter Extensions
CREATE PROCEDURE udp_findbyextension(extension VARCHAR(30))
BEGIN
	SELECT f.id, f.name as caption, CONCAT(f.size, 'KB') as user FROM files as f
	WHERE f.name REGEXP CONCAT('\\.', extension, '$')
	ORDER BY f.id;		
END;