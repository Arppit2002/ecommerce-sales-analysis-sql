-- DATA QUALITY CHECKS
-- E-commerce Sales Analysis

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