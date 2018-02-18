-- Ex.1 Find Book Titles
SELECT title FROM books
WHERE LEFT(title, 3) = 'The'
ORDER BY id;

-- Ex.2 Replace Titles
UPDATE books
SET title = REPLACE(title, 'The', '***')
WHERE LEFT(title, 3) = 'The';


SELECT title FROM books 
WHERE LEFT(title, 3) = '***'
ORDER BY id;

-- Ex.3 Sum Cost of All Books
SELECT ROUND(SUM(cost), 2) FROM books;

-- Ex.4 Days Lived
SELECT CONCAT(first_name, ' ', last_name) AS 'Full Name',
TIMESTAMPDIFF(DAY, born, died) AS 'Days Lived' FROM authors;

-- Ex.5 Harry Potter Books
SELECT title FROM books
WHERE title LIKE 'Harry Potter%'
ORDER BY id;