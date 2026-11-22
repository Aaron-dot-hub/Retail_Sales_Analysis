CREATE DATABASE retail_sales_analysis;
USE retail_sales_analysis;

SHOW DATABASES;

SELECT DATABASE();

CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(100),
    city VARCHAR(50),
    state VARCHAR(50),
    age INT
);

SHOW TABLES;
DESCRIBE customers;

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
(10, 'Divya Nair', 'Kochi', 'Kerala', 31);

SELECT * FROM customers;

CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100),
    category VARCHAR(50),
    price DECIMAL(10,2)
);

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

SELECT * FROM products;

CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    product_id INT,
    quantity INT,
    order_date DATE,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);
SHOW TABLES;
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

SELECT * FROM orders;

# What are all the orders placed by customers?
SELECT *
FROM orders;

# How many orders are there in total?
SELECT COUNT(order_id) AS total_orders
FROM orders;

# How much revenue did our retail business generate?
SELECT
    SUM(o.quantity * p.price) AS total_revenue
FROM orders o
JOIN products p
    ON o.product_id = p.product_id;

# "Which product generates the highest revenue?"
SELECT
    p.product_name,
    SUM(o.quantity * p.price) AS total_revenue
FROM orders o
JOIN products p
    ON o.product_id = p.product_id
GROUP BY p.product_name
ORDER BY total_revenue DESC;

# "Which city is generating the most revenue?"
SELECT
    c.city,
    SUM(o.quantity * p.price) AS total_revenue
FROM orders o
JOIN customers c
    ON o.customer_id = c.customer_id
JOIN products p
    ON o.product_id = p.product_id
GROUP BY c.city
ORDER BY total_revenue DESC;

# Which product category contributes the most revenue?
SELECT
    p.category,
    SUM(o.quantity * p.price) AS total_revenue
FROM orders o
JOIN products p
    ON o.product_id = p.product_id
GROUP BY p.category
ORDER BY total_revenue DESC;

# "On average, how much revenue does each order generate?"
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

# Which product did customers purchase the most?
SELECT
    p.product_name,
    SUM(o.quantity) AS total_quantity_sold
FROM orders o
JOIN products p
    ON o.product_id = p.product_id
GROUP BY p.product_name
ORDER BY total_quantity_sold DESC;

#"Which customer has spent the most money?"
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

#"How much revenue did we generate each month?"
SELECT
    MONTHNAME(o.order_date) AS sales_month,
    SUM(o.quantity * p.price) AS total_revenue
FROM orders o
JOIN products p
    ON o.product_id = p.product_id
GROUP BY MONTH(o.order_date), MONTHNAME(o.order_date)
ORDER BY MONTH(o.order_date);

SELECT
    MIN(order_date) AS first_order,
    MAX(order_date) AS last_order,
    COUNT(*) AS total_orders
FROM orders;

#"Show me only the orders placed by customers in Hyderabad."
SELECT
    c.customer_name,
    c.city,
    o.order_id,
    o.order_date
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
WHERE c.city = 'Hyderabad';

#"Show me orders placed by Hyderabad customers where the order quantity is greater than 1."
SELECT
    c.customer_name,
    c.city,
    o.order_id,
    o.quantity
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
WHERE c.city = 'Hyderabad'
AND o.quantity > 1;

#"Show me orders placed by customers from either Hyderabad or Mumbai."
SELECT
    c.customer_name,
    c.city,
    o.order_id,
    o.quantity
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
WHERE c.city = 'Hyderabad'
OR c.city = 'Mumbai';

#"Find all orders where the quantity purchased is between 2 and 4."
SELECT
    order_id,
    product_id,
    quantity
FROM orders
WHERE quantity BETWEEN 2 AND 4;

#"Show me customers who belong to Hyderabad, Mumbai, or Bengaluru."
SELECT
    customer_name,
    city,
    state
FROM customers
WHERE city IN ('Hyderabad', 'Mumbai', 'Bengaluru');

#"Find all customers whose age is between 25 and 30."
SELECT
    customer_name,
    city,
    age
FROM customers
WHERE age BETWEEN 25 AND 30
ORDER BY age ASC;

#"Find all customers whose names start with the letter A."
SELECT
    customer_name,
    city
FROM customers
WHERE customer_name LIKE 'A%';

#Business question: Which cities have more than one customer?
SELECT
    city,
    COUNT(customer_id) AS total_customers
FROM customers
GROUP BY city
HAVING COUNT(customer_id) > 1;

# Business question: Find the top 3 products based on total revenue.
SELECT 
    p.product_name, 
    SUM(o.quantity * p.price) AS total_revenue
FROM 
    products p
JOIN 
    orders o ON p.product_id = o.product_id
GROUP BY 
    p.product_id, 
    p.product_name
ORDER BY 
    total_revenue DESC
LIMIT 3;


/*Step 28: Learn CASE WHEN
Imagine the sales manager wants to classify products based on their price.
Price ₹20,000 or above → Expensive
Price ₹5,000 or above → Medium
Price below ₹5,000 → Affordable*/
SELECT
    product_name,
    price,
    CASE
        WHEN price >= 20000 THEN 'Expensive'
        WHEN price >= 5000 THEN 'Medium'
        ELSE 'Affordable'
    END AS price_category
FROM products;


/*Step 29: Use CASE WHEN for sales performance
Now let's classify customers based on their total spending.

Business rule:
- Spending ≥ ₹50,000 → High Value
- Spending ≥ ₹20,000 → Medium Value
- Spending below ₹20,000 → Low Value*/
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

/* Step 30: Find customers who have never placed an order
New concept: LEFT JOIN
Imagine a business manager asks:

"Which customers registered with us but never purchased anything?"

A LEFT JOIN keeps all customers, even if they have no matching order.*/

SELECT
    c.customer_name,
    o.order_id
FROM customers c
LEFT JOIN orders o
    ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL;

-- Step 30A: Check which customers have orders
SELECT
    c.customer_name,
    COUNT(o.order_id) AS total_orders
FROM customers c
LEFT JOIN orders o
    ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.customer_name;

/*Great! Your order-count query should show 10 customers, and every customer should have at least one order.
Let's make our LEFT JOIN example more meaningful by adding one customer who has not placed an order.
Step 1: Add a test customer
Run this SQL command once:*/
INSERT INTO customers
(customer_id, customer_name, city, state, age)
VALUES
(11, 'Ravi Kumar', 'Pune', 'Maharashtra', 29);

-- Excellent! 🎯 Now let's find customers who have never placed an order.

SELECT
    c.customer_name,
    o.order_id
FROM customers c
LEFT JOIN orders o
    ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL;

/*Next challenge: Find customers with orders
Now let's reverse the logic.

Run this query:*/
SELECT
    c.customer_name,
    o.order_id
FROM customers c
LEFT JOIN orders o
    ON c.customer_id = o.customer_id
WHERE o.order_id IS NOT NULL;

-- Your task: Display the customer name and total number of orders, but only for customers with more than one order.
SELECT
    c.customer_name,
    COUNT(o.order_id) AS total_orders
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.customer_name
HAVING COUNT(o.order_id) > 1
ORDER BY total_orders DESC;

/*Next topic: Subqueries
A subquery is a query inside another query.

For example, let's find products whose price is greater than the average price of all products.*/
SELECT product_name, price
FROM products
WHERE price > (
    SELECT AVG(price)
    FROM products
);

/*Your next challenge 🧩
Find customers whose total spending is greater than the average customer spending.*/
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

/*Business insight: Rahul Sharma is your highest-value customer, spending ₹91,000.

One important detail: Ravi Kumar is excluded from this average because he has no orders. The query calculates average spending among customers who have placed orders.*/

/*A window function helps us calculate values across related rows without combining them into one row.
For example, we can rank customers by how much they spend while still displaying each customer's name and spending.
We'll learn one function at a time, using your retail_sales_analysis database.
Level 1: ROW_NUMBER()
This function assigns a unique number to each row based on the order you specify.
Step 1: Write your first window-function query
Run this:*/
SELECT
    c.customer_name,
    SUM(o.quantity * p.price) AS total_spent,
    ROW_NUMBER() OVER (
        ORDER BY SUM(o.quantity * p.price) DESC
    ) AS spending_rank
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
JOIN products p
    ON o.product_id = p.product_id
GROUP BY c.customer_id, c.customer_name;

/*Step 2: Understand ROW_NUMBER()*/
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
    ) AS spending_rank
FROM customer_spending;



/*Level 2: RANK()
Now let's learn another window function.

The difference:
- ROW_NUMBER() gives every row a unique number.
- RANK() gives the same rank to tied values and skips the next rank.
Your next task: Replace ROW_NUMBER() with RANK() in your previous query and execute it.*/

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
    RANK() OVER (
        ORDER BY total_spent DESC
    ) AS spending_rank
FROM customer_spending;


/*Level 3: DENSE_RANK()
This is our third ranking function.

Understand the difference:
Function	Example result when values tie
ROW_NUMBER()	1, 2, 3, 4
RANK()	1, 2, 2, 4
DENSE_RANK()	1, 2, 2, 3

Key difference: DENSE_RANK() does not skip numbers after a tie.*/
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
    DENSE_RANK() OVER (
        ORDER BY total_spent DESC
    ) AS spending_rank
FROM customer_spending;

/*Remember:
- ROW_NUMBER: Unique numbers.
- RANK: Ties share ranks, numbers are skipped.
- DENSE_RANK: Ties share ranks, no numbers are skipped.*/

/* Next: A practical SQL challenge
Let's learn PARTITION BY.
It allows us to rank products within each category, rather than ranking all products together
For example, Electronics products get their own ranking, Accessories get their own ranking, and Furniture gets its own ranking.*/
SELECT
    product_name,
    category,
    price,
    RANK() OVER (
        PARTITION BY category
        ORDER BY price DESC
    ) AS product_rank
FROM products;

/*Next level: LAG() function
This function helps compare the current row with the previous row.

For example, in sales analysis:
- January revenue: ₹10,000
- February revenue: ₹15,000
- March revenue: ₹20,000
LAG() can help us compare February with January and March with February.*/
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
    LAG(total_spent) OVER (
        ORDER BY total_spent DESC
    ) AS previous_customer_spending
FROM customer_spending;


/*One more useful concept: LEAD()
LEAD() is the opposite of LAG().
- LAG() looks at the previous row.
- LEAD() looks at the next row.*/

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
    LEAD(total_spent) OVER (
        ORDER BY total_spent DESC
    ) AS next_customer_spending
FROM customer_spending;

/*WITH customer_spending AS (
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
    LEAD(total_spent) OVER (
        ORDER BY total_spent DESC
    ) AS next_customer_spending
FROM customer_spending;*/
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
    
/*Level 7: AVG() OVER()
Now let's calculate each order's revenue alongside the average revenue of all orders.

Run this:*/
SELECT
    o.order_id,
    p.product_name,
    (o.quantity * p.price) AS order_revenue,
    AVG(o.quantity * p.price) OVER () AS average_revenue
FROM orders o
JOIN products p
    ON o.product_id = p.product_id;
    
/*Level 8: SUM() OVER(PARTITION BY)
Now let's calculate total revenue separately for each product category, while keeping individual orders visible.

Run this:*/
SELECT
    p.product_name,
    p.category,
    (o.quantity * p.price) AS order_revenue,
    SUM(o.quantity * p.price) OVER (
        PARTITION BY p.category
    ) AS category_revenue
FROM orders o
JOIN products p
    ON o.product_id = p.product_id;
    
/*Option 2: PARTITION BY with RANK() is the right answer.

Why?
- PARTITION BY separates products into categories.
- RANK() ranks products by revenue within each category.
- ORDER BY ... DESC puts the highest-revenue product first.
Let's put it into practice
Run this query to find the highest-revenue product in each category:*/

WITH product_revenue AS (
    SELECT
        p.product_name,
        p.category,
        SUM(o.quantity * p.price) AS total_revenue
    FROM products p
    JOIN orders o
        ON p.product_id = o.product_id
    GROUP BY p.product_id, p.product_name, p.category
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
SELECT *
FROM ranked_products
WHERE product_rank = 1;