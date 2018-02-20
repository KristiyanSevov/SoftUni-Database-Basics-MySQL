--Ex.1 DDL
CREATE TABLE flights(
flight_id INT NOT NULL PRIMARY KEY,
departure_time DATETIME NOT NULL,
arrival_time DATETIME NOT NULL,
`status` VARCHAR(9),
origin_airport_id INT,
destination_airport_id INT, 
airline_id INT,
FOREIGN KEY (origin_airport_id) REFERENCES airports(airport_id),
FOREIGN KEY (destination_airport_id) REFERENCES airports(airport_id),
FOREIGN KEY (airline_id) REFERENCES airlines(airline_id));

CREATE TABLE tickets(
ticket_id INT NOT NULL PRIMARY KEY,
price DECIMAL(8, 2) NOT NULL,
class VARCHAR(6),
seat VARCHAR(5) NOT NULL,
customer_id INT,
flight_id INT,
FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
FOREIGN KEY (flight_id) REFERENCES flights(flight_id));

--Ex.2 Data Insertion
INSERT INTO flights VALUES
(1, STR_TO_DATE('2016-10-13 06:00 AM', '%Y-%m-%d %h:%i %p'), 
STR_TO_DATE('2016-10-13 10:00 AM', '%Y-%m-%d %h:%i %p'), 'Delayed', 1, 4, 1),
(2, STR_TO_DATE('2016-10-12 12:00 PM', '%Y-%m-%d %h:%i %p'), 
STR_TO_DATE('2016-10-12 12:01 PM', '%Y-%m-%d %h:%i %p'), 'Departing', 1, 3, 2),
(3, STR_TO_DATE('2016-10-14 03:00 PM', '%Y-%m-%d %h:%i %p'), 
STR_TO_DATE('2016-10-20 04:00 AM', '%Y-%m-%d %h:%i %p'), 'Delayed', 4, 2, 4),
(4, STR_TO_DATE('2016-10-12 01:24 PM', '%Y-%m-%d %h:%i %p'), 
STR_TO_DATE('2016-10-12 4:31 PM', '%Y-%m-%d %h:%i %p'), 'Departing', 3, 1, 3),
(5, STR_TO_DATE('2016-10-12 08:11 AM', '%Y-%m-%d %h:%i %p'), 
STR_TO_DATE('2016-10-12 11:22 PM', '%Y-%m-%d %h:%i %p'), 'Departing', 4, 1, 1),
(6, STR_TO_DATE('1995-06-21 12:30 PM', '%Y-%m-%d %h:%i %p'), 
STR_TO_DATE('1995-06-22 08:30 PM', '%Y-%m-%d %h:%i %p'), 'Arrived', 2, 3, 5),
(7, STR_TO_DATE('2016-10-12 11:34 PM', '%Y-%m-%d %h:%i %p'), 
STR_TO_DATE('2016-10-13 03:00 AM', '%Y-%m-%d %h:%i %p'), 'Departing', 2, 4, 2),
(8, STR_TO_DATE('2016-11-11 01:00 PM', '%Y-%m-%d %h:%i %p'), 
STR_TO_DATE('2016-11-12 10:00 PM', '%Y-%m-%d %h:%i %p'), 'Delayed', 4, 3, 1),
(9, STR_TO_DATE('2015-10-01 12:00 PM', '%Y-%m-%d %h:%i %p'), 
STR_TO_DATE('2015-12-01 01:00 AM', '%Y-%m-%d %h:%i %p'), 'Arrived', 1, 2, 1),
(10, STR_TO_DATE('2016-10-12 07:30 PM', '%Y-%m-%d %h:%i %p'), 
STR_TO_DATE('2016-10-13 12:30 PM', '%Y-%m-%d %h:%i %p'), 'Departing', 2, 1, 7);

INSERT INTO tickets VALUES
(1, 3000.00, 'First', '233-A', 3, 8),
(2, 1799.90, 'Second', '123-D', 1, 1),
(3, 1200.5, 'Second', '12-Z', 2, 5),
(4, 410.68, 'Third', '45-Q', 2, 8),
(5, 560.00, 'Third', '201-R', 4, 6),
(6, 2100, 'Second', '13-T', 1, 9),
(7, 5500, 'First', '98-O', 2, 7);

--Ex.3 Update Flights
UPDATE flights 
SET airline_id = 1
WHERE `status` = 'Arrived'

--Ex.4 Update Tickets
UPDATE flights as f JOIN tickets as t ON f.flight_id = t.flight_id
SET t.price = t.price * 1.5
WHERE f.airline_id = (SELECT airline_id FROM airlines
ORDER BY rating DESC LIMIT 1);

--Ex.5 Table Creation
CREATE TABLE customer_reviews(
review_id INT PRIMARY KEY,
review_content VARCHAR(255) NOT NULL,
review_grade INT CHECK(review_grade BETWEEN 0 and 10),
airline_id INT,
customer_id INT,
FOREIGN KEY (airline_id) REFERENCES airlines(airline_id),
FOREIGN KEY (customer_id) REFERENCES customers(customer_id));

CREATE TABLE customer_bank_accounts(
account_id INT PRIMARY KEY,
account_number VARCHAR(10) NOT NULL UNIQUE,
balance DECIMAL(10, 2) NOT NULL,
customer_id INT,
FOREIGN KEY (customer_id) REFERENCES customers(customer_id));

--Ex.6 Filling New Tables
INSERT INTO customer_reviews VALUES
(1, 'Me is very happy. Me likey this airline. Me good.', 10, 1, 1),
(2, 'Ja, Ja, Ja... Ja, Gut, Gut, Ja Gut! Sehr Gut!', 10, 1, 4),
(3, 'Meh...', 5, 4, 3),
(4, 'Well Ive seen better, but Ive certainly seen a lot worse...', 7, 3, 5);

INSERT INTO customer_bank_accounts VALUES
(1, '123456790', 2569.23, 1),
(2, '18ABC23672', 14004568.23, 2),
(3, 'F0RG0100N3', 19345.20, 5);

--Ex.7 Extract All Tickets
SELECT ticket_id, price, class, seat FROM tickets
ORDER BY ticket_id;

--Ex.8 Extract All Customers
SELECT customer_id, CONCAT(first_name, ' ', last_name) as full_name,
gender FROM customers
ORDER BY full_name, customer_id;

--Ex.9 Extract Delayed Flights
SELECT flight_id, departure_time, arrival_time FROM flights
WHERE `status` = 'Delayed' 
ORDER BY flight_id;

--Ex.10 Querying - 04. Top 5 Airlines
SELECT DISTINCT a.airline_id, a.airline_name, a.nationality, a.rating FROM flights as f 
JOIN airlines as a ON f.airline_id = a.airline_id
ORDER BY a.rating DESC, a.airline_id
LIMIT 5;

--Ex.11 Querying - 05. All Tickets Below 5000
SELECT t.ticket_id, a.airport_name, 
CONCAT(c.first_name, ' ', c.last_name) as customer_name FROM tickets as t 
JOIN customers as c ON t.customer_id = c.customer_id
JOIN flights as f ON t.flight_id = f.flight_id
JOIN airports as a ON a.airport_id = f.destination_airport_id
WHERE t.class = 'First' AND t.price < 5000
ORDER BY t.ticket_id;

--Ex.12 Customers From Home
SELECT c.customer_id, CONCAT(c.first_name, ' ', c.last_name) as full_name, tn.town_name as home_town 
FROM customers as c 
JOIN tickets as t ON c.customer_id = t.customer_id
JOIN flights as f ON t.flight_id = f.flight_id
JOIN airports as a ON a.airport_id = f.origin_airport_id
JOIN towns as tn ON tn.town_id = c.home_town_id AND tn.town_id = a.town_id
WHERE f.`status` = 'Departing'
ORDER BY t.ticket_id;

--Ex.13 Customers who will fly
SELECT DISTINCT c.customer_id, CONCAT(c.first_name, ' ', c.last_name) as full_name, 
2016 - YEAR(c.date_of_birth) AS age FROM customers as c 
JOIN tickets as t ON c.customer_id = t.customer_id
JOIN flights as f ON t.flight_id = f.flight_id
WHERE f.`status` = 'Departing'
ORDER BY age, c.customer_id;

--Ex.14 Top 3 Customers Delayed
SELECT c.customer_id, CONCAT(c.first_name, ' ', c.last_name) as full_name, 
t.price AS ticket_price, a.airport_name FROM customers as c 
JOIN tickets as t ON c.customer_id = t.customer_id
JOIN flights as f ON t.flight_id = f.flight_id
JOIN airports as a ON f.destination_airport_id = a.airport_id
WHERE f.`status` = 'Delayed'
ORDER BY ticket_price DESC, c.customer_id
LIMIT 3;

--Ex.15 Last 5 Departing Flights
SELECT * FROM (SELECT f.flight_id, f.departure_time, f.arrival_time, 
	a2.airport_name as origin, a1.airport_name as destination FROM flights as f 
	JOIN airports as a1 ON f.destination_airport_id = a1.airport_id
	JOIN airports as a2 ON f.origin_airport_id = a2.airport_id
	WHERE f.`status` = 'Departing'
	ORDER BY f.departure_time DESC, f.flight_id
	LIMIT 5) as derived
ORDER BY departure_time, flight_id;


--Ex.16 Customers Below 21
SELECT DISTINCT c.customer_id, CONCAT(c.first_name, ' ', c.last_name) as full_name, 
(2016 - YEAR(c.date_of_birth)) as age FROM customers as c 
JOIN tickets as t ON c.customer_id = t.customer_id
JOIN flights as f ON f.flight_id = t.flight_id
WHERE f.`status` = 'Arrived'
HAVING age < 21
ORDER BY age DESC, c.customer_id;

--Ex.17 Airports and Passengers
SELECT a.airport_id, a.airport_name, COUNT(t.ticket_id) as passengers 
FROM customers as c 
JOIN tickets as t ON c.customer_id = t.customer_id
JOIN flights as f ON f.flight_id = t.flight_id
JOIN airports as a ON f.origin_airport_id = a.airport_id
WHERE f.`status` = 'Departing'
GROUP BY a.airport_id
ORDER BY a.airport_id; 

--Ex.18 Submit Review
CREATE PROCEDURE usp_submit_review(customer_id INT, review_content VARCHAR(255),
review_grade INT, airline_name VARCHAR(30))
BEGIN 
	DECLARE airline_id INT;
	DECLARE max_id INT;
	SET max_id := (SELECT MAX(c_r.review_id) FROM customer_reviews as c_r);
	SET airline_id := (SELECT a.airline_id from airlines as a 
			   WHERE a.airline_name = airline_name);
	CASE WHEN airline_id IS NULL 
		THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Airline does not exist.';
	ELSE
		INSERT INTO customer_reviews
		VALUES (IFNULL(max_id + 1, 1), review_content, review_grade, airline_id, customer_id);
	END CASE;
END;

--Ex.19 Ticket Purchase
CREATE PROCEDURE usp_purchase_ticket(customer_id INT, flight_id INT,
ticket_price DECIMAL(8,2), class VARCHAR(6), seat VARCHAR(5))
BEGIN 
	DECLARE max_id INT;
	DECLARE customer_balance INT;
	SET max_id := (SELECT MAX(t.ticket_id) FROM tickets as t);
	SET customer_balance := (SELECT b.balance FROM customer_bank_accounts as b 
				WHERE b.customer_id = customer_id);
	START TRANSACTION;
	IF ticket_price < 0
		OR ticket_price > customer_balance
		OR customer_balance IS NULL
	   THEN 
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Insufficient bank account balance for ticket purchase.';
		ROLLBACK;
	ELSE 
		INSERT INTO tickets VALUES (IFNULL(max_id + 1, 1), ticket_price, class, seat, customer_id, flight_id);
		UPDATE customer_bank_accounts as b 
		SET b.balance = b.balance - ticket_price
		WHERE b.customer_id = customer_id;
	END IF;
	COMMIT;
END;

--Ex.20 Update Trigger
CREATE TRIGGER my_trigger AFTER UPDATE ON flights 
FOR EACH ROW
BEGIN
	CASE WHEN (OLD.`status` != 'Arrived' AND NEW.`status` = 'Arrived') THEN
		INSERT INTO arrived_flights
		VALUES (NEW.flight_id, NEW.arrival_time, 
			(SELECT airport_name FROM airports WHERE airport_id = NEW.origin_airport_id),
			(SELECT airport_name FROM airports WHERE airport_id = NEW.destination_airport_id),
			(SELECT COUNT(ticket_id) FROM flights as f 
			JOIN tickets as t ON t.flight_id = f.flight_id
			WHERE f.flight_id = NEW.flight_id));
	ELSE BEGIN END;
	END CASE;
END;
