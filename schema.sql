
-- =====================================================
-- PROJECT: E-COMMERCE SALES ANALYSIS
-- DATABASE: PostgreSQL
-- DATA: Synthetic sample data
-- =====================================================

-- 1. CREATE TABLES

CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(100),
    city VARCHAR(50),
    signup_date DATE
);

CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100),
    category VARCHAR(50),
    price NUMERIC(10,2)
);

CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT REFERENCES customers(customer_id),
    order_date DATE,
    order_status VARCHAR(30)
);

CREATE TABLE order_items (
    order_item_id INT PRIMARY KEY,
    order_id INT REFERENCES orders(order_id),
    product_id INT REFERENCES products(product_id),
    quantity INT
);

-- 2. INSERT CUSTOMERS

INSERT INTO customers VALUES
(1, 'Aarav Sharma', 'Mumbai', '2025-01-10'),
(2, 'Priya Patel', 'Pune', '2025-01-15'),
(3, 'Rahul Verma', 'Delhi', '2025-02-01'),
(4, 'Sneha Joshi', 'Nashik', '2025-02-12'),
(5, 'Aditya Singh', 'Mumbai', '2025-03-05'),
(6, 'Neha Gupta', 'Pune', '2025-03-15'),
(7, 'Rohan Mehta', 'Bangalore', '2025-04-01'),
(8, 'Ananya Rao', 'Hyderabad', '2025-04-10'),
(9, 'Karan Shah', 'Mumbai', '2025-05-05'),
(10, 'Isha Kulkarni', 'Nashik', '2025-05-20'),
(11, 'Vikram Desai', 'Pune', '2025-06-01'),
(12, 'Meera Nair', 'Bangalore', '2025-06-15');

-- 3. INSERT PRODUCTS

INSERT INTO products VALUES
(101, 'Laptop', 'Electronics', 55000),
(102, 'Smartphone', 'Electronics', 25000),
(103, 'Headphones', 'Accessories', 2500),
(104, 'Keyboard', 'Accessories', 1500),
(105, 'Office Chair', 'Furniture', 8500),
(106, 'Desk', 'Furniture', 12000),
(107, 'Monitor', 'Electronics', 15000),
(108, 'Mouse', 'Accessories', 800),
(109, 'Tablet', 'Electronics', 30000),
(110, 'Bookshelf', 'Furniture', 6500);

-- 4. INSERT ORDERS

INSERT INTO orders VALUES
(1001, 1, '2025-01-12', 'Delivered'),
(1002, 2, '2025-01-18', 'Delivered'),
(1003, 3, '2025-02-05', 'Delivered'),
(1004, 1, '2025-02-15', 'Delivered'),
(1005, 4, '2025-02-20', 'Delivered'),
(1006, 5, '2025-03-10', 'Delivered'),
(1007, 6, '2025-03-18', 'Delivered'),
(1008, 7, '2025-04-05', 'Delivered'),
(1009, 8, '2025-04-15', 'Delivered'),
(1010, 9, '2025-05-10', 'Delivered'),
(1011, 10, '2025-05-22', 'Delivered'),
(1012, 11, '2025-06-05', 'Delivered'),
(1013, 12, '2025-06-18', 'Delivered'),
(1014, 1, '2025-06-20', 'Delivered'),
(1015, 3, '2025-06-25', 'Cancelled'),
(1016, 5, '2025-06-28', 'Delivered'),
(1017, 2, '2025-06-30', 'Delivered'),
(1018, 7, '2025-07-05', 'Delivered'),
(1019, 8, '2025-07-12', 'Delivered'),
(1020, 9, '2025-07-20', 'Delivered');

-- 5. INSERT ORDER ITEMS

INSERT INTO order_items VALUES
(1,1001,101,1),
(2,1001,103,2),
(3,1002,102,1),
(4,1002,104,2),
(5,1003,105,1),
(6,1003,108,3),
(7,1004,107,1),
(8,1004,103,1),
(9,1005,106,1),
(10,1005,108,2),
(11,1006,101,1),
(12,1006,104,1),
(13,1007,109,1),
(14,1007,103,2),
(15,1008,102,2),
(16,1008,108,1),
(17,1009,105,1),
(18,1009,104,2),
(19,1010,107,2),
(20,1010,103,1),
(21,1011,110,1),
(22,1011,108,3),
(23,1012,101,1),
(24,1012,103,2),
(25,1013,109,1),
(26,1013,104,1),
(27,1014,102,1),
(28,1014,108,2),
(29,1015,106,1),
(30,1016,107,1),
(31,1016,103,2),
(32,1017,105,1),
(33,1017,104,1),
(34,1018,101,1),
(35,1018,108,2),
(36,1019,102,1),
(37,1019,103,3),
(38,1020,106,1),
(39,1020,104,2);
