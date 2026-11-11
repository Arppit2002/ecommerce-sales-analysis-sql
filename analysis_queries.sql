
-- =====================================================
-- E-COMMERCE SALES ANALYSIS
-- ANALYTICAL QUERIES
-- =====================================================

-- QUERY 1: DATASET OVERVIEW

SELECT 'Customers' AS table_name, COUNT(*) AS total_records
FROM customers

UNION ALL

SELECT 'Products', COUNT(*) FROM products

UNION ALL

SELECT 'Orders', COUNT(*) FROM orders

UNION ALL

SELECT 'Order Items', COUNT(*) FROM order_items;


-- QUERY 2: TOTAL REVENUE

SELECT
    ROUND(SUM(oi.quantity * p.price), 2) AS total_revenue
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id
WHERE o.order_status = 'Delivered';


-- QUERY 3: TOP 5 PRODUCTS BY REVENUE

SELECT
    p.product_name,
    SUM(oi.quantity) AS units_sold,
    SUM(oi.quantity * p.price) AS revenue
FROM products p
JOIN order_items oi ON p.product_id = oi.product_id
JOIN orders o ON oi.order_id = o.order_id
WHERE o.order_status = 'Delivered'
GROUP BY p.product_id, p.product_name
ORDER BY revenue DESC
LIMIT 5;


-- QUERY 4: MONTHLY REVENUE

SELECT
    TO_CHAR(DATE_TRUNC('month', o.order_date), 'YYYY-MM') AS month,
    SUM(oi.quantity * p.price) AS monthly_revenue
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id
WHERE o.order_status = 'Delivered'
GROUP BY DATE_TRUNC('month', o.order_date)
ORDER BY DATE_TRUNC('month', o.order_date);


-- QUERY 5: CATEGORY-WISE SALES PERFORMANCE

SELECT
    p.category,
    SUM(oi.quantity) AS units_sold,
    SUM(oi.quantity * p.price) AS revenue
FROM products p
JOIN order_items oi ON p.product_id = oi.product_id
JOIN orders o ON oi.order_id = o.order_id
WHERE o.order_status = 'Delivered'
GROUP BY p.category
ORDER BY revenue DESC;


-- QUERY 6: CUSTOMER-WISE SPENDING

SELECT
    c.customer_id,
    c.customer_name,
    c.city,
    SUM(oi.quantity * p.price) AS total_spending
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id
WHERE o.order_status = 'Delivered'
GROUP BY c.customer_id, c.customer_name, c.city
ORDER BY total_spending DESC;


-- QUERY 7: TOP 5 CUSTOMERS

SELECT
    c.customer_name,
    COUNT(DISTINCT o.order_id) AS total_orders,
    SUM(oi.quantity * p.price) AS total_spending
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id
WHERE o.order_status = 'Delivered'
GROUP BY c.customer_id, c.customer_name
ORDER BY total_spending DESC
LIMIT 5;


-- QUERY 8: AVERAGE ORDER VALUE

WITH order_revenue AS (
    SELECT
        o.order_id,
        SUM(oi.quantity * p.price) AS order_value
    FROM orders o
    JOIN order_items oi ON o.order_id = oi.order_id
    JOIN products p ON oi.product_id = p.product_id
    WHERE o.order_status = 'Delivered'
    GROUP BY o.order_id
)
SELECT
    ROUND(AVG(order_value), 2) AS average_order_value
FROM order_revenue;


-- QUERY 9: REVENUE ABOVE CATEGORY AVERAGE
-- Uses a subquery

SELECT
    p.product_name,
    p.category,
    SUM(oi.quantity * p.price) AS product_revenue
FROM products p
JOIN order_items oi ON p.product_id = oi.product_id
JOIN orders o ON oi.order_id = o.order_id
WHERE o.order_status = 'Delivered'
GROUP BY p.product_id, p.product_name, p.category
HAVING SUM(oi.quantity * p.price) >
(
    SELECT AVG(product_revenue)
    FROM (
        SELECT
            SUM(oi2.quantity * p2.price) AS product_revenue
        FROM products p2
        JOIN order_items oi2 ON p2.product_id = oi2.product_id
        JOIN orders o2 ON oi2.order_id = o2.order_id
        WHERE o2.order_status = 'Delivered'
        GROUP BY p2.product_id
    ) AS product_average
)
ORDER BY product_revenue DESC;


-- QUERY 10: CUSTOMER RANKING
-- Uses CTE and WINDOW FUNCTION

WITH customer_sales AS (
    SELECT
        c.customer_id,
        c.customer_name,
        SUM(oi.quantity * p.price) AS total_revenue
    FROM customers c
    JOIN orders o ON c.customer_id = o.customer_id
    JOIN order_items oi ON o.order_id = oi.order_id
    JOIN products p ON oi.product_id = p.product_id
    WHERE o.order_status = 'Delivered'
    GROUP BY c.customer_id, c.customer_name
)
SELECT
    customer_id,
    customer_name,
    total_revenue,
    RANK() OVER (ORDER BY total_revenue DESC) AS revenue_rank
FROM customer_sales;


-- QUERY 11: REPEAT CUSTOMERS

SELECT
    c.customer_name,
    COUNT(DISTINCT o.order_id) AS completed_orders
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
WHERE o.order_status = 'Delivered'
GROUP BY c.customer_id, c.customer_name
HAVING COUNT(DISTINCT o.order_id) > 1
ORDER BY completed_orders DESC;


-- QUERY 12: ORDER STATUS ANALYSIS

SELECT
    order_status,
    COUNT(*) AS total_orders,
    ROUND(
        COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (),
        2
    ) AS percentage_of_orders
FROM orders
GROUP BY order_status
ORDER BY total_orders DESC;

-- =====================================================
-- DATA QUALITY CHECKS
-- =====================================================

-- 1. Check duplicate customer IDs
SELECT customer_id, COUNT(*)
FROM customers
GROUP BY customer_id
HAVING COUNT(*) > 1;

-- 2. Check invalid quantities
SELECT *
FROM order_items
WHERE quantity <= 0;

-- 3. Check missing customer information
SELECT *
FROM customers
WHERE customer_name IS NULL
   OR city IS NULL;

-- 4. Check orders without order items
SELECT o.order_id
FROM orders o
LEFT JOIN order_items oi
    ON o.order_id = oi.order_id
WHERE oi.order_id IS NULL;
