/*
====================================================
PROJECT: RETAIL SALES ANALYSIS
TOOL: MySQL
AUTHOR: Aaron Paul
DESCRIPTION:
Analysis of retail sales, product performance,
customer spending, and revenue patterns.
====================================================
*/

-- SECTION 1: DATABASE SETUP

CREATE DATABASE IF NOT EXISTS retail_sales_analysis;

USE retail_sales_analysis;

-- SECTION 2: TABLE STRUCTURES

-- 1. Customers table
CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(100),
    city VARCHAR(50),
    state VARCHAR(50),
    age INT
);

-- 2. Products table
CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100),
    category VARCHAR(50),
    price DECIMAL(10,2)
);

-- 3. Orders table
CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    product_id INT,
    quantity INT,
    order_date DATE,
    FOREIGN KEY (customer_id)
        REFERENCES customers(customer_id),
    FOREIGN KEY (product_id)
        REFERENCES products(product_id)
);

-- SECTION 3: INSERT SAMPLE DATA

-- 1. Insert customer records
INSERT INTO customers
(customer_id, customer_name, city, state, age)
VALUES
(1, 'Rahul Sharma', 'Hyderabad', 'Telangana', 28),
(2, 'Priya Reddy', 'Bengaluru', 'Karnataka', 25),
(3, 'Amit Kumar', 'Chennai', 'Tamil Nadu', 32),
(4, 'Sneha Rao', 'Hyderabad', 'Telangana', 29),
(5, 'Vikram Singh', 'Mumbai', 'Maharashtra', 35),
(6, 'Ananya Das', 'Kolkata', 'West Bengal', 24),
(7, 'Kiran Kumar', 'Bengaluru', 'Karnataka', 30),
(8, 'Meera Patel', 'Mumbai', 'Maharashtra', 27),
(9, 'Arjun Reddy', 'Chennai', 'Tamil Nadu', 26),
(10, 'Divya Nair', 'Kochi', 'Kerala', 31),
(11, 'Ravi Kumar', 'Pune', 'Maharashtra', 29);


-- 2. Insert product records
INSERT INTO products
(product_id, product_name, category, price)
VALUES
(101, 'Laptop', 'Electronics', 55000.00),
(102, 'Smartphone', 'Electronics', 25000.00),
(103, 'Headphones', 'Accessories', 2000.00),
(104, 'Office Chair', 'Furniture', 8000.00),
(105, 'Desk', 'Furniture', 12000.00),
(106, 'Keyboard', 'Accessories', 1500.00),
(107, 'Monitor', 'Electronics', 18000.00),
(108, 'Mouse', 'Accessories', 800.00);


-- 3. Insert order records
INSERT INTO orders
(order_id, customer_id, product_id, quantity, order_date)
VALUES
(1001, 1, 101, 1, '2026-01-05'),
(1002, 2, 102, 2, '2026-01-06'),
(1003, 3, 103, 3, '2026-01-07'),
(1004, 4, 104, 1, '2026-01-08'),
(1005, 5, 105, 2, '2026-01-09'),
(1006, 6, 106, 4, '2026-01-10'),
(1007, 7, 107, 1, '2026-01-11'),
(1008, 8, 108, 2, '2026-01-12'),
(1009, 9, 101, 1, '2026-01-13'),
(1010, 10, 102, 1, '2026-01-14'),
(1011, 1, 107, 2, '2026-01-15'),
(1012, 2, 103, 2, '2026-01-16'),
(1013, 3, 108, 5, '2026-01-17'),
(1014, 4, 105, 1, '2026-01-18'),
(1015, 5, 102, 1, '2026-01-19');

-- SECTION 4: BUSINESS ANALYSIS

-- 1. What is the total number of orders and total revenue?

SELECT
    COUNT(DISTINCT o.order_id) AS total_orders,
    SUM(o.quantity * p.price) AS total_revenue
FROM orders o
JOIN products p
    ON o.product_id = p.product_id;


-- 2. Which are the top 3 products by revenue?

SELECT
    p.product_name,
    SUM(o.quantity * p.price) AS total_revenue
FROM products p
JOIN orders o
    ON p.product_id = o.product_id
GROUP BY p.product_id, p.product_name
ORDER BY total_revenue DESC
LIMIT 3;


-- 3. Which city generates the highest revenue?

SELECT
    c.city,
    SUM(o.quantity * p.price) AS total_revenue
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
JOIN products p
    ON o.product_id = p.product_id
GROUP BY c.city
ORDER BY total_revenue DESC;


-- 4. Which product category generates the highest revenue?

SELECT
    p.category,
    SUM(o.quantity * p.price) AS total_revenue
FROM products p
JOIN orders o
    ON p.product_id = o.product_id
GROUP BY p.category
ORDER BY total_revenue DESC;


-- 5. What is the average order value?

SELECT
    AVG(order_revenue) AS average_order_value
FROM (
    SELECT
        o.order_id,
        SUM(o.quantity * p.price) AS order_revenue
    FROM orders o
    JOIN products p
        ON o.product_id = p.product_id
    GROUP BY o.order_id
) AS order_summary;


-- 6. Which customers spend the most?

SELECT
    c.customer_name,
    SUM(o.quantity * p.price) AS total_spent
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
JOIN products p
    ON o.product_id = p.product_id
GROUP BY c.customer_id, c.customer_name
ORDER BY total_spent DESC;


-- 7. Which products have the highest sales quantity?

SELECT
    p.product_name,
    SUM(o.quantity) AS total_quantity_sold
FROM products p
JOIN orders o
    ON p.product_id = o.product_id
GROUP BY p.product_id, p.product_name
ORDER BY total_quantity_sold DESC;


-- 8. How much revenue was generated each month?

SELECT
    YEAR(o.order_date) AS sales_year,
    MONTHNAME(o.order_date) AS sales_month,
    SUM(o.quantity * p.price) AS total_revenue
FROM orders o
JOIN products p
    ON o.product_id = p.product_id
GROUP BY YEAR(o.order_date), MONTH(o.order_date),
         MONTHNAME(o.order_date)
ORDER BY sales_year, MONTH(o.order_date);

-- SECTION 5: ADVANCED SQL ANALYSIS


-- 1. Find customers who have never placed an order

SELECT
    c.customer_name,
    c.city
FROM customers c
LEFT JOIN orders o
    ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL;


-- 2. Classify customers based on their spending

SELECT
    c.customer_name,
    SUM(o.quantity * p.price) AS total_spent,
    CASE
        WHEN SUM(o.quantity * p.price) >= 50000
            THEN 'High Value'
        WHEN SUM(o.quantity * p.price) >= 20000
            THEN 'Medium Value'
        ELSE 'Low Value'
    END AS customer_category
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
JOIN products p
    ON o.product_id = p.product_id
GROUP BY c.customer_id, c.customer_name
ORDER BY total_spent DESC;


-- 3. Find customers spending above average

SELECT
    c.customer_name,
    SUM(o.quantity * p.price) AS total_spent
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
JOIN products p
    ON o.product_id = p.product_id
GROUP BY c.customer_id, c.customer_name
HAVING SUM(o.quantity * p.price) > (
    SELECT AVG(customer_total)
    FROM (
        SELECT
            SUM(o2.quantity * p2.price) AS customer_total
        FROM orders o2
        JOIN products p2
            ON o2.product_id = p2.product_id
        GROUP BY o2.customer_id
    ) AS customer_spending
)
ORDER BY total_spent DESC;


-- 4. Rank customers using window functions

WITH customer_spending AS (
    SELECT
        c.customer_name,
        SUM(o.quantity * p.price) AS total_spent
    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
    JOIN products p
        ON o.product_id = p.product_id
    GROUP BY c.customer_id, c.customer_name
)
SELECT
    customer_name,
    total_spent,
    ROW_NUMBER() OVER (
        ORDER BY total_spent DESC
    ) AS row_number_rank,
    RANK() OVER (
        ORDER BY total_spent DESC
    ) AS spending_rank,
    DENSE_RANK() OVER (
        ORDER BY total_spent DESC
    ) AS dense_spending_rank,
    LAG(total_spent) OVER (
        ORDER BY total_spent DESC
    ) AS previous_customer_spending,
    LEAD(total_spent) OVER (
        ORDER BY total_spent DESC
    ) AS next_customer_spending
FROM customer_spending;


-- 5. Find the highest-revenue product in each category

WITH product_revenue AS (
    SELECT
        p.product_name,
        p.category,
        SUM(o.quantity * p.price) AS total_revenue
    FROM products p
    JOIN orders o
        ON p.product_id = o.product_id
    GROUP BY
        p.product_id,
        p.product_name,
        p.category
),
ranked_products AS (
    SELECT
        product_name,
        category,
        total_revenue,
        RANK() OVER (
            PARTITION BY category
            ORDER BY total_revenue DESC
        ) AS product_rank
    FROM product_revenue
)
SELECT
    product_name,
    category,
    total_revenue,
    product_rank
FROM ranked_products
WHERE product_rank = 1;


-- 6. Calculate running revenue over time

SELECT
    o.order_id,
    o.order_date,
    p.product_name,
    (o.quantity * p.price) AS order_revenue,
    SUM(o.quantity * p.price) OVER (
        ORDER BY o.order_date, o.order_id
    ) AS running_total
FROM orders o
JOIN products p
    ON o.product_id = p.product_id;
    
-- SECTION 6: DATA VALIDATION

-- 1. Verify the number of records in each table

SELECT
    (SELECT COUNT(*) FROM customers) AS total_customers,
    (SELECT COUNT(*) FROM products) AS total_products,
    (SELECT COUNT(*) FROM orders) AS total_orders;


-- 2. Verify total sales revenue

SELECT
    SUM(o.quantity * p.price) AS verified_total_revenue
FROM orders o
JOIN products p
    ON o.product_id = p.product_id;


-- 3. Check customers without orders

SELECT
    COUNT(*) AS customers_without_orders
FROM customers c
LEFT JOIN orders o
    ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL;

