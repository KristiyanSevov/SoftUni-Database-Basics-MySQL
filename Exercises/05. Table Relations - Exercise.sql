-- Ex.1 One-To-One Relationship
CREATE TABLE persons(
person_id INT NOT NULL,
first_name VARCHAR(50) NOT NULL,
salary DECIMAL(7, 2) NOT NULL,
passport_id INT UNIQUE);

CREATE TABLE passports(
passport_id INT NOT NULL PRIMARY KEY,
passport_number VARCHAR(50) NOT NULL);

INSERT INTO persons
VALUES (1, 'Roberto', 43300.00, 102),
(2, 'Tom', 56100, 103),
(3, 'Yana', 60200, 101);

INSERT INTO passports
VALUES (101, 'N34FG21B'),
(102, 'K65LO4R7'),
(103, 'ZE657QP2');

ALTER TABLE persons
ADD CONSTRAINT PRIMARY KEY (person_id),
ADD CONSTRAINT fk_persons_passports FOREIGN KEY (passport_id) 
REFERENCES passports(passport_id);

-- Ex.2 One-To-Many Relationship
CREATE TABLE manufacturers(
manufacturer_id INT NOT NULL,
name VARCHAR(50) ,
established_on DATE);

CREATE TABLE models(
model_id INT NOT NULL,
name VARCHAR(50),
manufacturer_id INT);

INSERT INTO manufacturers
VALUES (1, 'BMW', '1916-03-01'),
(2, 'Tesla', '2003-01-01'),
(3, 'Lada', '1966-05-01');

INSERT INTO models
VALUES (101, 'X1', 1),
(102, 'i6', 1),
(103, 'Model S', 2),
(104, 'Model X', 2),
(105, 'Model 3', 2),
(106, 'Nova', 3);

ALTER TABLE manufacturers
ADD PRIMARY KEY (manufacturer_id);

ALTER TABLE models
ADD PRIMARY KEY (model_id),
ADD CONSTRAINT fk_models_manufacturers FOREIGN KEY (manufacturer_id) 
REFERENCES manufacturers(manufacturer_id);

-- Ex.3 Many-To-Many Relationship
CREATE TABLE students(
student_id INT NOT NULL PRIMARY KEY,
name VARCHAR(50) NOT NULL);

CREATE TABLE exams(
exam_id INT NOT NULL PRIMARY KEY,
name VARCHAR(50) NOT NULL);

CREATE TABLE students_exams(
student_id INT NOT NULL,
exam_id INT NOT NULL,
FOREIGN KEY (student_id) REFERENCES students(student_id),
FOREIGN KEY (exam_id) REFERENCES exams(exam_id));

INSERT INTO students
VALUES (1, 'Mila'),
(2, 'Toni'),
(3, 'Ron');

INSERT INTO exams
VALUES (101, 'Spring MVC'),
(102, 'Neo4j'),
(103, 'Oracle 11g');

INSERT INTO students_exams
VALUES (1, 101), (1, 102), (2, 101), (3, 103), (2, 102), (2, 103);

ALTER TABLE students_exams
ADD PRIMARY KEY (student_id, exam_id);

-- Ex.4 Self-Referencing
CREATE TABLE teachers(
teacher_id INT NOT NULL,
name VARCHAR(30) NOT NULL,
manager_id INT);

INSERT INTO teachers
VALUES (101, 'John', NULL),
(102, 'Maya', 106),
(103, 'Silvia', 106),
(104, 'Ted', 105),
(105, 'Mark', 101),
(106, 'Greta', 101);

ALTER TABLE teachers
ADD PRIMARY KEY (teacher_id);

ALTER TABLE teachers
ADD CONSTRAINT fk FOREIGN KEY (manager_id) REFERENCES teachers(teacher_id);

-- Ex.5 Online Store Database
CREATE TABLE cities(
city_id INT NOT NULL PRIMARY KEY,
name VARCHAR(50));

CREATE TABLE customers(
customer_id INT NOT NULL PRIMARY KEY,
name VARCHAR(50),
birthday DATE,
city_id INT,
FOREIGN KEY (city_id) REFERENCES cities(city_id));

CREATE TABLE orders(
order_id INT NOT NULL PRIMARY KEY,
customer_ID INT,
FOREIGN KEY (customer_id) REFERENCES customers(customer_id));

CREATE TABLE item_types(
item_type_id INT NOT NULL PRIMARY KEY,
name VARCHAR(50));

CREATE TABLE items(
item_id INT NOT NULL PRIMARY KEY,
name VARCHAR(50),
item_type_id INT,
FOREIGN KEY (item_type_id) REFERENCES item_types(item_type_id));

CREATE TABLE order_items(
order_id INT,
item_id INT,
PRIMARY KEY (order_id, item_id),
FOREIGN KEY (order_id) REFERENCES orders(order_id),
FOREIGN KEY (item_id) REFERENCES items(item_id));

-- Ex.6 University Database
CREATE TABLE majors(
major_id INT NOT NULL PRIMARY KEY,
name VARCHAR(50));

CREATE TABLE students(
student_id INT NOT NULL PRIMARY KEY,
student_number VARCHAR(12),
student_name VARCHAR(50),
major_id INT,
FOREIGN KEY (major_id) REFERENCES majors(major_id));

CREATE TABLE payments(
payment_id INT NOT NULL PRIMARY KEY,
payment_date DATE,
payment_amount DECIMAL(8,2),
student_id INT,
FOREIGN KEY (student_id) REFERENCES students(student_id));

CREATE TABLE subjects(
subject_id INT NOT NULL PRIMARY KEY,
subject_name VARCHAR(50));

CREATE TABLE agenda(
student_id INT,
subject_id INT,
PRIMARY KEY (student_id, subject_id),
FOREIGN KEY (student_id) REFERENCES students(student_id),
FOREIGN KEY (subject_id) REFERENCES subjects(subject_id));

-- Ex.7 Peaks in Rila
SELECT mountain_range, p.peak_name, p.elevation AS peak_elevation FROM 
mountains as m JOIN peaks as p ON p.mountain_id = m.id
WHERE mountain_range = 'Rila'
ORDER BY peak_elevation DESC;