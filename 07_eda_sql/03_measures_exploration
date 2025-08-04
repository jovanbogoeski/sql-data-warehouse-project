/*
===============================================================================
Measures Exploration (Key Metrics)
===============================================================================
Purpose:
    - To calculate aggregated metrics (e.g., totals, averages) for quick insights.
    - To identify overall trends or spot anomalies.

SQL Functions Used:
    - COUNT(), SUM(), AVG()
===============================================================================
*/

-- 1. Total Sales
SELECT SUM(sales_amount) AS total_sales FROM gold.fact_sales;

-- 2. Total Quantity Sold
SELECT SUM(quantity) AS total_quantity FROM gold.fact_sales;

-- 3. Average Selling Price
SELECT AVG(price) AS avg_price FROM gold.fact_sales;

-- 4. Total Number of Orders (raw vs distinct)
SELECT COUNT(order_number) AS total_orders_raw FROM gold.fact_sales;
SELECT COUNT(DISTINCT order_number) AS total_orders FROM gold.fact_sales;

-- 5. Total Number of Products
SELECT COUNT(DISTINCT product_name) AS total_products FROM gold.dim_products;

-- 6. Total Number of Customers
SELECT COUNT(customer_key) AS total_customers FROM gold.dim_customers;

-- 7. Total Number of Customers Who Placed Orders
SELECT COUNT(DISTINCT customer_key) AS active_customers FROM gold.fact_sales;

-- 8. Combined KPI Summary
SELECT 'Total Sales' AS measure_name, CAST(SUM(sales_amount) AS VARCHAR) AS measure_value FROM gold.fact_sales
UNION ALL
SELECT 'Total Quantity', CAST(SUM(quantity) AS VARCHAR) FROM gold.fact_sales
UNION ALL
SELECT 'Average Price', CAST(AVG(price) AS VARCHAR) FROM gold.fact_sales
UNION ALL
SELECT 'Total Orders', CAST(COUNT(DISTINCT order_number) AS VARCHAR) FROM gold.fact_sales
UNION ALL
SELECT 'Total Products', CAST(COUNT(DISTINCT product_name) AS VARCHAR) FROM gold.dim_products
UNION ALL
SELECT 'Total Customers', CAST(COUNT(customer_key) AS VARCHAR) FROM gold.dim_customers
UNION ALL
SELECT 'Active Customers', CAST(COUNT(DISTINCT customer_key) AS VARCHAR) FROM gold.fact_sales;
