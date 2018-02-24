--Ex.1 Database Design
CREATE TABLE locations(
id INT NOT NULL PRIMARY KEY,
latitude float,
longitude float);

CREATE TABLE credentials(
id INT NOT NULL PRIMARY KEY,
email VARCHAR(30),
`password` VARCHAR(20));

CREATE TABLE users(
id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
nickname VARCHAR(25),
gender CHAR(1),
age INT,
location_id INT,
credential_id INT UNIQUE,
FOREIGN KEY (location_id) REFERENCES locations(id),
FOREIGN KEY (credential_id) REFERENCES credentials(id));

CREATE TABLE chats(
id INT NOT NULL PRIMARY KEY,
title VARCHAR(32),
start_date DATE,
is_active BIT);

CREATE TABLE messages(
id INT NOT NULL PRIMARY KEY,
content VARCHAR(200),
sent_on DATE,
chat_id INT,
user_id INT,
FOREIGN KEY (chat_id) REFERENCES chats(id),
FOREIGN KEY (user_id) REFERENCES users(id));

CREATE TABLE users_chats(
user_id INT,
chat_id INT,
PRIMARY KEY (user_id, chat_id),
FOREIGN KEY (user_id) REFERENCES users(id),
FOREIGN KEY (chat_id) REFERENCES chats(id));

--Ex.2 Insert
ALTER TABLE messages
DROP PRIMARY KEY,
MODIFY id INT NOT NULL PRIMARY KEY AUTO_INCREMENT;

INSERT INTO messages (content, sent_on, chat_id, user_id)
SELECT CONCAT_WS('-', u.age, u.gender, l.latitude, l.longitude), DATE(NOW()),  
CEIL(IF(u.gender = 'F', SQRT(u.age * 2), POW(u.age/18, 3))),
u.id FROM users as u
JOIN locations as l ON u.location_id = l.id
WHERE u.id BETWEEN 10 AND 20;

--Ex.3 Update
UPDATE chats as c 
SET c.start_date = (SELECT MIN(m.sent_on) FROM messages as m WHERE m.chat_id = c.id)
WHERE c.start_date > (SELECT MIN(m.sent_on) FROM messages as m WHERE m.chat_id = c.id);

--Ex.4 Delete
DELETE FROM locations 
WHERE id NOT IN (SELECT location_id FROM users WHERE location_id IS NOT NULL);

--Ex.5 Age Range
SELECT nickname, gender, age FROM users
WHERE age BETWEEN 22 AND 37;

--Ex.6 Messages
SELECT content, sent_on FROM messages
WHERE sent_on > DATE('2014-05-12') AND content LIKE '%just%'
ORDER BY id DESC;

--Ex.7 Chats
SELECT c.title, c.is_active FROM chats as c
WHERE (c.is_active = 0 AND CHAR_LENGTH(c.title) < 5) OR SUBSTRING(c.title, 3, 2) = 'tl' 
ORDER BY c.title DESC;

--Ex.8 Chat Messages
SELECT c.id, c.title, m.id FROM chats as c 
JOIN messages as m ON c.id = m.chat_id
WHERE m.sent_on < DATE('2012-03-26') AND RIGHT(c.title, 1) = 'x'
ORDER BY c.id, m.id;

--Ex.9 Message Count
SELECT c.id, COUNT(m.id) as total_messages FROM chats as c 
RIGHT JOIN messages as m ON c.id = m.chat_id
WHERE m.id < 90
GROUP BY c.id
ORDER BY total_messages DESC, c.id
LIMIT 5;

--Ex.10 Credentials
SELECT u.nickname, c.email, c.password FROM credentials as c 
JOIN users as u ON c.id = u.credential_id
WHERE c.email LIKE '%co.uk'
ORDER BY c.email;

--Ex.11 Locations
SELECT u.id, u.nickname, u.age FROM users as u 
LEFT JOIN locations as l ON u.location_id = l.id
WHERE l.id IS NULL;

--Ex.12 Left Users
SELECT m.id, c.id, m.user_id FROM chats as c
JOIN messages as m ON c.id = m.chat_id
WHERE 17 NOT IN (SELECT chat_id FROM users_chats WHERE user_id = m.user_id)
AND c.id = 17
ORDER BY m.id DESC;

--Ex.13 Users in Bulgaria
SELECT u.nickname, c.title, l.latitude, l.longitude FROM users as u 
JOIN locations as l ON u.location_id = l.id
JOIN users_chats as u_c ON u.id = u_c.user_id
JOIN chats as c ON u_c.chat_id = c.id
WHERE l.latitude BETWEEN 41.14 - 0.000001 AND 44.13 + 0.000001
AND l.longitude BETWEEN 22.21 - 0.000001 AND 28.36 + 0.000001
ORDER BY c.title;

--Ex.14 Last Chat
SELECT c.title, m.content FROM chats as c 
LEFT JOIN messages as m ON c.id = m.chat_id
WHERE c.id = (SELECT c.id FROM chats as c ORDER BY c.start_date DESC LIMIT 1);

--Ex.15 Radians
CREATE FUNCTION udf_get_radians(deg float)
RETURNS float
BEGIN
DECLARE result float;
SET result := deg * PI() / 180;
return result;
END;

--Ex.16 Change Password
CREATE PROCEDURE udp_change_password(email VARCHAR(30), `password` VARCHAR(20))
BEGIN
START TRANSACTION;
	CASE WHEN (SELECT c.email FROM credentials as c WHERE c.email = email) IS NULL
		THEN 
			SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'The email doesn\'t exist!';
			ROLLBACK;
		ELSE
			UPDATE credentials as c
			SET c.`password` = `password`
			WHERE c.email = email;
	END CASE;
COMMIT;
END;

--Ex.17 Send Message
CREATE PROCEDURE udp_send_message(user_id INT, chat_id INT, content VARCHAR(200))
BEGIN
START TRANSACTION;
	CASE WHEN (SELECT u_c.user_id FROM users_chats as u_c WHERE u_c.user_id = user_id LIMIT 1) IS NULL
		THEN 
			SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'There is no chat with that user!';
			ROLLBACK;
		ELSE
			INSERT INTO messages (content, sent_on, chat_id, user_id)
			VALUES (content, DATE(NOW()), chat_id, user_id);
	END CASE;
COMMIT;
END;

--Ex.18 Log Messages
CREATE TRIGGER my_trigger BEFORE DELETE ON messages
FOR EACH ROW
BEGIN
INSERT INTO messages_log (id, content, sent_on, chat_id, user_id)
VALUES (OLD.id, OLD.content, OLD.sent_on, OLD.chat_id, OLD.user_id);
END;

--Ex.19 Delete users
CREATE TRIGGER my_trigger BEFORE DELETE ON users
FOR EACH ROW
BEGIN
DELETE FROM users_chats 
WHERE user_id = OLD.id;

DELETE FROM messages 
WHERE user_id = OLD.id;
END;