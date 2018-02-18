-- Ex.1 Mountains and Peaks
CREATE TABLE mountains (
id INT NOT NULL PRIMARY KEY, 
name VARCHAR(50) NOT NULL);

CREATE TABLE peaks (
id INT NOT NULL PRIMARY KEY,
name VARCHAR(50) NOT NULL,
mountain_id INT NOT NULL,
CONSTRAINT fk_peaks_mountains FOREIGN KEY(mountain_id) REFERENCES mountains(id));

-- Ex.2 Books and Authors
CREATE TABLE authors(
id INT NOT NULL PRIMARY KEY,
name VARCHAR(50) NOT NULL);

CREATE TABLE books(
id INT NOT NULL PRIMARY KEY,
name VARCHAR(50) NOT NULL,
author_id INT NOT NULL,
CONSTRAINT fk_books_authors FOREIGN KEY (author_id)
REFERENCES authors(id) ON DELETE CASCADE);

-- Ex.3 Trip Organization
SELECT v.driver_id, v.vehicle_type, 
CONCAT(c.first_name, ' ', c.last_name) AS driver_name FROM
vehicles as v JOIN campers as c ON v.driver_id = c.id;

-- Ex.4 SoftUni Hiking
SELECT r.starting_point AS route_starting_point, r.end_point AS route_ending_point,
r.leader_id, CONCAT(c.first_name, ' ', c.last_name) AS leader_name 
FROM campers as c JOIN routes as r ON c.id = r.leader_id;

-- Ex.5 Project Management DB
CREATE TABLE clients(
id INT NOT NULL PRIMARY KEY,
client_name VARCHAR(100),
project_id INT);

CREATE TABLE employees(
id INT NOT NULL PRIMARY KEY,
first_name VARCHAR(30),
last_name VARCHAR(30),
project_id INT);

CREATE TABLE projects (
id INT NOT NULL PRIMARY KEY,
client_id INT,
project_lead_id INT,
FOREIGN KEY (client_id) REFERENCES clients(id),
FOREIGN KEY (project_lead_id) REFERENCES employees(id));


ALTER TABLE clients
ADD FOREIGN KEY (project_id) REFERENCES projects(id);

ALTER TABLE employees
ADD FOREIGN KEY (projecT_id) REFERENCES projects(id);