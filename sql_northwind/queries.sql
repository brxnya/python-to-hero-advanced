SELECT DISTINCT city
FROM employees;

SELECT COUNT('Rio de Janeiro')
FROM orders;

SELECT *
FROM orders
WHERE freight BETWEEN 20 AND 40;

SELECT *
FROM customers
WHERE country = 'Mexico' OR country = 'Germany' OR country = 'USA' OR country = 'Canada';

SELECT *
FROM products
WHERE category_id IN (1, 3, 5, 7);

SELECT *
FROM customers
WHERE country NOT IN ('Mexico', 'Germany', 'USA', 'Canada');

SELECT DISTINCT country, city
FROM customers
ORDER BY country DESC, city ASC;

SELECT ship_city, order_date
FROM orders
WHERE ship_city = 'London'
ORDER BY order_date;
--↓--
SELECT MIN(order_date)
FROM orders
WHERE ship_city = 'London';

SELECT ship_city, order_date
FROM orders
WHERE ship_city = 'London'
ORDER BY order_date DESC;
--↓--
SELECT MAX(order_date)
FROM orders
WHERE ship_city = 'London';

SELECT AVG(unit_price)
FROM products
WHERE discontinued <> 1;

SELECT SUM(units_in_stock)
FROM products
WHERE discontinued <> 1;

SELECT last_name, first_name
FROM employees
WHERE first_name LIKE 'An%';

SELECT product_name, unit_price
FROM products
WHERE discontinued <> 1
ORDER BY unit_price DESC
LIMIT 15;

SELECT ship_city, ship_region, ship_country
FROM orders
WHERE ship_region IS NOT NULL;

SELECT ship_country, COUNT(*)
FROM orders
WHERE freight > 50
GROUP BY ship_country
ORDER BY COUNT(*) DESC;

SELECT category_id, SUM(units_in_stock)
FROM products
GROUP BY category_id
ORDER BY SUM(units_in_stock) DESC
LIMIT 5;

SELECT category_id, SUM(unit_price * units_in_stock)
FROM products
WHERE discontinued <> 1
GROUP BY category_id
HAVING SUM(unit_price * units_in_stock) > 5000
ORDER BY SUM(unit_price * units_in_stock) DESC;

SELECT country
FROM customers
UNION -- UNION ALL with duplicates --
SELECT country
FROM employees;

SELECT country
FROM customers
INTERSECT
SELECT country
FROM suppliers;

SELECT country
FROM customers
EXCEPT -- EXCEPT ALL with duplicates --
SELECT country
FROM suppliers;


-- ↓ INNER JOINs ↓ --

SELECT product_name, suppliers.company_name, units_in_stock
FROM products
INNER JOIN suppliers ON products.supplier_id = suppliers.supplier_id
ORDER BY units_in_stock DESC;

SELECT category_name, SUM(units_in_stock)
FROM products
INNER JOIN categories ON products.category_id = categories.category_id
GROUP BY category_name
ORDER BY SUM(units_in_stock) DESC
LIMIT 5;

SELECT category_name, SUM(unit_price * units_in_stock)
FROM products
INNER JOIN categories ON products.category_id = categories.category_id
WHERE discontinued <> 1
GROUP BY category_name
HAVING SUM(unit_price * units_in_stock) > 5000
ORDER BY SUM(unit_price * units_in_stock) DESC;

SELECT order_id, customer_id, first_name, last_name, title
FROM orders
INNER JOIN employees ON orders.employee_id = employees.employee_id;

SELECT order_date, product_name, ship_country, products.unit_price, quantity, discount
FROM orders
INNER JOIN order_details ON orders.order_id = order_details.order_id
INNER JOIN products ON order_details.product_id = products.product_id;

SELECT contact_name, company_name, phone, first_name, last_name, title,
	   order_date, product_name, ship_country, products.unit_price, quantity, discount
FROM orders
JOIN order_details ON orders.order_id = order_details.order_id
JOIN products ON order_details.product_id = products.product_id
JOIN customers ON orders.customer_id = customers.customer_id
JOIN employees ON orders.employee_id = employees.employee_id
WHERE ship_country = 'USA';


-- ↓ LEFT and RIGHT JOINS ↓ --

SELECT company_name, product_name
FROM suppliers
LEFT JOIN products ON suppliers.supplier_id = products.supplier_id;

SELECT company_name, order_id
FROM customers
JOIN orders ON orders.customer_id = customers.customer_id
WHERE order_id IS NULL;
-- ↓ --
SELECT company_name, order_id
FROM customers
LEFT JOIN orders ON orders.customer_id = customers.customer_id
WHERE order_id IS NULL;

SELECT last_name, order_id
FROM employees
LEFT JOIN orders ON orders.employee_id = employees.employee_id
WHERE order_id IS NULL;

SELECT COUNT(*)
FROM employees
LEFT JOIN orders ON orders.employee_id = employees.employee_id
WHERE order_id IS NULL;

SELECT company_name, order_id
FROM orders
RIGHT JOIN customers ON orders.customer_id = customers.customer_id
WHERE order_id IS NULL;


-- ↓ SELF JOIN ↓ --

CREATE TABLE employee
(
	employee_id INT PRIMARY KEY,
	first_name VARCHAR(255) NOT NULL,
	last_name VARCHAR(255) NOT NULL,
	manager_id INT,
	FOREIGN KEY (manager_id) REFERENCES employee(employee_id)
);

INSERT INTO employee
(
	employee_id,
	first_name,
	last_name,
	manager_id
)

VALUES
(1, 'Windy', 'Hays', NULL),
(2, 'Ava', 'Christensen', 1),
(3, 'Hassan', 'Conner', 1),
(4, 'Anna', 'Reeves', 2),
(5, 'Sau', 'Norman', 2),
(6, 'Kelsie', 'Hays', 3),
(7, 'Tory', 'Goff', 3),
(8, 'Salley', 'Lester', 3);

SELECT e.first_name || ' ' || e.last_name AS employee,
	   m.first_name || ' ' || m.last_name AS manager
FROM employee e
LEFT JOIN employee m ON m.employee_id = e.manager_id
ORDER BY manager


-- ↓ USING and NATURAL JOIN ↓ --

SELECT contact_name, company_name, phone, first_name, last_name, title,
	   order_date, product_name, ship_country, products.unit_price, quantity, discount
FROM orders
JOIN order_details USING(order_id) -- ON orders.order_id = order_details.order_id
JOIN products USING(product_id) -- ON order_details.product_id = products.product_id
JOIN customers USING(customer_id) --ON orders.customer_id = customers.customer_id
JOIN employees USING(employee_id) -- ON orders.employee_id = employees.employee_id
WHERE ship_country = 'USA';

SELECT order_id, customer_id, first_name, last_name, title
FROM orders
NATURAL JOIN employees;


-- ↓ AS alias ↓ --

SELECT COUNT(*) AS employees_count
FROM employees;

SELECT COUNT(DISTINCT country) AS country
FROM employees;

SELECT category_id, SUM(units_in_stock) AS units_in_stock
FROM products
GROUP BY category_id
ORDER BY units_in_stock DESC
LIMIT 5;

SELECT category_id, SUM(unit_price * units_in_stock) AS total_price
FROM products
WHERE discontinued <> 1
GROUP BY category_id
HAVING SUM(unit_price * units_in_stock) > 5000
ORDER BY total_price DESC;


-- ↓ sub-queries ↓ --

SELECT company_name
FROM suppliers
WHERE country IN (SELECT DISTINCT country
				  FROM customers);
-- ↓ without subquery ↓ --
SELECT DISTINCT suppliers.company_name
FROM suppliers
JOIN customers USING(country);

SELECT category_name, SUM(units_in_stock)
FROM products
JOIN categories USING(category_id)
GROUP BY category_name
ORDER BY SUM(units_in_stock) DESC
LIMIT (SELECT MIN(product_id) + 4 FROM products);

SELECT AVG(units_in_stock)
FROM products;

SELECT product_name, units_in_stock
FROM products
WHERE units_in_stock > (SELECT AVG(units_in_stock)
						FROM products)
ORDER BY units_in_stock;


-- ↓ WHERE EXISTS ↓ --

SELECT company_name, contact_name
FROM customers
WHERE EXISTS (SELECT customer_id FROM orders
			 WHERE customer_id = customers.customer_id
			 AND freight BETWEEN 50 AND 100);

SELECT company_name, contact_name
FROM customers
WHERE NOT EXISTS (SELECT customer_id FROM orders
			 	 WHERE customer_id = customers.customer_id
			 	 AND order_date BETWEEN '1995-02-01' AND '1995-02-15');

SELECT product_name
FROM products
WHERE NOT EXISTS (SELECT orders.order_id FROM orders
			 	 JOIN order_details USING(order_id)
			 	 WHERE order_details.product_id=product_id
			 	 AND order_date BETWEEN '1995-02-01' AND '1995-02-15');


-- ↓ sub-queries ANY and ALL quantifiers ↓ --

SELECT DISTINCT company_name
FROM customers
JOIN orders USING(customer_id)
JOIN order_details USING(order_id)
WHERE quantity > 40;
-- ↓ --
SELECT DISTINCT company_name
FROM customers
WHERE customer_id = ANY(
	SELECT customer_id
	FROM orders
	JOIN order_details USING(order_id)
	WHERE quantity > 40);

SELECT DISTINCT product_name, quantity
FROM products
JOIN order_details USING(product_id)
WHERE quantity > (
	SELECT AVG(quantity)
	FROM order_details)
ORDER BY quantity;

SELECT DISTINCT product_name, quantity
FROM products
JOIN order_details USING(product_id)
WHERE quantity > ALL(
	SELECT AVG(quantity)
	FROM order_details
	GROUP BY product_id)
ORDER BY quantity;


-- ↓ DDL part_1 ↓ --

CREATE TABLE student
(
	student_id serial,
	first_name varchar,
	last_name varchar,
	birthday date,
	phone varchar
);

CREATE TABLE cathedra
(
	cathedra_id serial,
	cathedra_name varchar,
	dean varchar
);

ALTER TABLE student
ADD COLUMN middle_name varchar;

ALTER TABLE student
ADD COLUMN rating float;

ALTER TABLE student
ADD COLUMN enrolled date;

ALTER TABLE student
DROP COLUMN middle_name;

ALTER TABLE cathedra
RENAME TO chair;

ALTER TABLE chair
RENAME cathedra_id TO chai_id;

ALTER TABLE chair
RENAME cathedra_name TO chai_name;

ALTER TABLE student
ALTER COLUMN first_name SET DATA TYPE varchar(64);

ALTER TABLE student
ALTER COLUMN last_name SET DATA TYPE varchar(64);

ALTER TABLE student
ALTER COLUMN phone SET DATA TYPE varchar(64);

CREATE TABLE faculty
(
	faculty_id serial,
	faculty_name varchar
);
INSERT INTO faculty(faculty_name)
VALUES
('faculty1'),
('faculty2'),
('faculty3');

SELECT * FROM faculty;

TRUNCATE TABLE faculty RESTART IDENTITY;

DROP TABLE faculty;


-- ↓ PRIMARY KEY ↓ --

CREATE TABLE chair
(
	chair_id serial PRIMARY KEY,
	chair_name varchar,
	dean varchar
);

INSERT INTO chair
VALUES (1, 'name', 'dean');

SELECT * FROM chair;

INSERT INTO chair
VALUES (2, 'name2', 'dean2');

DROP TABLE chair;

CREATE TABLE chair
(
	chair_id serial UNIQUE NOT NULL,
	chair_name varchar,
	dean varchar
);

SELECT constraint_name
FROM information_schema.key_column_usage
WHERE table_name = 'chair'
	AND table_schema = 'public'
	AND column_name = 'chair_id';

CREATE TABLE chair
(
	chair_id serial, -- PRIMARY KEY,
	chair_name varchar,
	dean varchar

	CONSTRAINT PK_chair_chair_id PRIMARY KEY(chair_id)
);

ALTER TABLE chair
DROP CONSTRAINT chair_chair_id_key;

ALTER TABLE chair
ADD PRIMARY KEY(chair_id);


-- ↓ FOREIGN KEY ↓ --

DROP TABLE publisher;

DROP TABLE book_author;

DROP TABLE book;

CREATE TABLE publisher
(
	publisher_id int,
	publisher_name varchar(128) NOT NULL,
	address text,

	CONSTRAINT PK_publisher_publisher_id PRIMARY KEY(publisher_id)
);

CREATE TABLE book
(
	book_id int,
	title text NOT NULL,
	isbn varchar(32) NOT NULL,
	publisher_id int,

	CONSTRAINT PK_book_book_id PRIMARY KEY(book_id)
);

INSERT INTO publisher
VALUES
(1, 'Everyman''s Library', 'NY'),
(2, 'Oxford University Press', 'NY'),
(3, 'Grand Central Publishing', 'Washington'),
(4, 'Simon & Schuster', 'Chicago');

INSERT INTO book
VALUES
(1, 'The Diary of a Young Girl', '0199535566', 10);

SELECT * FROM book;

TRUNCATE TABLE book;

ALTER TABLE book
ADD CONSTRAINT FK_books_publisher FOREIGN KEY(publisher_id) REFERENCES publisher(publisher_id);

CREATE TABLE book
(
	book_id int,
	title text NOT NULL,
	isbn varchar(32) NOT NULL,
	publisher_id int,

	CONSTRAINT PK_book_book_id PRIMARY KEY(book_id),
	CONSTRAINT PK_book_publisher FOREIGN KEY (publisher_id) REFERENCES publisher(publisher_id)
);

ALTER TABLE book
DROP CONSTRAINT PK_book_publisher;


-- ↓ DDL - check ↓ --

CREATE TABLE book
(
	book_id int,
	title text NOT NULL,
	isbn varchar(32) NOT NULL,
	publisher_id int,

	CONSTRAINT PK_book_book_id PRIMARY KEY(book_id)
);

ALTER TABLE book
ADD COLUMN price decimal CONSTRAINT CHK_book_price CHECK(price >= 0);

INSERT INTO book
VALUES
(1, 'title', 'isbn', 1, 1.5);

SELECT * FROM book;

INSERT INTO book
VALUES
(2, 'title', 'isbn', 1, -1.5);


-- ↓ DDL - default ↓ --

CREATE TABLE customer
(
	customer_id serial,
	full_name text,
	status char DEFAULT 'r',

	CONSTRAINT PK_customer_customer_id PRIMARY KEY(customer_id),
	CONSTRAINT CHK_customer_status CHECK (status = 'r' OR status = 'p')
);

INSERT INTO customer (full_name)
VALUES
('name');

SELECT * FROM customer;

ALTER TABLE customer
ALTER COLUMN status DROP DEFAULT;

ALTER TABLE customer
ALTER COLUMN status SET DEFAULT 'r';


-- ↓ DDL - sequences ↓ --

CREATE SEQUENCE seq1;

SELECT nextval('seq1');
SELECT currval('seq1');
SELECT lastval();

SELECT setval('seq1', 16, true);
SELECT currval('seq1');
SELECT nextval('seq1');

SELECT setval('seq1', 16, false);
SELECT currval('seq1');
SELECT nextval('seq1');

CREATE SEQUENCE IF NOT EXISTS seq2 INCREMENT 16;
SELECT nextval('seq2');

CREATE SEQUENCE IF NOT EXISTS seq3
INCREMENT 16
MINVALUE 0
MAXVALUE 128
START WITH 0;

SELECT nextval('seq3');

ALTER SEQUENCE seq3 RENAME TO seq4;
ALTER SEQUENCE seq4 RESTART WITH 16;

SELECT nextval('seq4');

DROP SEQUENCE seq4;


-- ↓ DDL - sequences & tables ↓ --

CREATE TABLE book
(
	book_id serial NOT NULL,
	title text NOT NULL,
	isbn varchar(32) NOT NULL,
	publisher_id int NOT NULL,

	CONSTRAINT PK_book_book_id PRIMARY KEY(book_id)
);
-- ↓ --
CREATE TABLE book
(
	book_id int NOT NULL,
	title text NOT NULL,
	isbn varchar(32) NOT NULL,
	publisher_id int NOT NULL,

	CONSTRAINT PK_book_book_id PRIMARY KEY(book_id)
);

CREATE SEQUENCE IF NOT EXISTS book_book_id_seq
START WITH 1 OWNED BY book.book_id;

ALTER TABLE book
ALTER COLUMN book_id SET DEFAULT nextval('book_book_id_seq');

INSERT INTO book(title, isbn, publisher_id)
VALUES('title', 'isbn', 1);

SELECT * FROM book;

CREATE TABLE book
(
	book_id int GENERATED ALWAYS AS IDENTITY NOT NOT NULL,
	title text NOT NULL,
	isbn varchar(32) NOT NULL,
	publisher_id int NOT NULL,

	CONSTRAINT PK_book_book_id PRIMARY KEY(book_id)
);

INSERT INTO book
OVERRIDING SYSTEM VALUE
VALUES(3, 'title', 'isbn', 1);


-- ↓ DDL - insert ↓ --

INSERT INTO author
VALUES(10, 'John Silver', 4.5);

SELECT * FROM author;

INSERT INTO author (author_id, full_name)
VALUES (11, 'Bob Gray');

INSERT INTO author (author_id, full_name)
VALUES
(12, 'Name 1'),
(13, 'Name 2'),
(14, 'Name 3');

SELECT *
INTO best_authors
FROM author
WHERE rating >= 4.5;

SELECT * FROM best_authors;

INSERT INTO best_authors
SELECT *
FROM author
WHERE rating < 4.5;