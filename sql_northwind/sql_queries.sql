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

