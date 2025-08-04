/*
===============================================================================
Exploratory Data Analysis: Date Range Exploration
===============================================================================
Purpose:
    Validate the coverage, completeness, and distribution of key date fields 
    in the gold.fact_sales table for reliable time-based reporting.
===============================================================================
*/

-- 1. Date Ranges: Min and Max
SELECT 
    MIN(order_date)     AS min_order_date,
    MAX(order_date)     AS max_order_date,
    MIN(shipping_date)  AS min_shipping_date,
    MAX(shipping_date)  AS max_shipping_date,
    MIN(due_date)       AS min_due_date,
    MAX(due_date)       AS max_due_date
FROM gold.fact_sales;

-- 2. Null Check on Date Fields
SELECT 
    COUNT(*) AS total_rows,
    SUM(CASE WHEN order_date IS NULL THEN 1 ELSE 0 END)    AS null_order_dates,
    SUM(CASE WHEN shipping_date IS NULL THEN 1 ELSE 0 END) AS null_shipping_dates,
    SUM(CASE WHEN due_date IS NULL THEN 1 ELSE 0 END)      AS null_due_dates
FROM gold.fact_sales;

-- 3. Orders by Year – to detect missing or skewed time periods
SELECT 
    YEAR(order_date) AS order_year,
    COUNT(*)         AS order_count
FROM gold.fact_sales
GROUP BY YEAR(order_date)
ORDER BY order_year;

-- 4. Future-Dated Orders (Data Error Check)
SELECT *
FROM gold.fact_sales
WHERE order_date > GETDATE();

-- 5. Delivery Duration (Shipping - Order) and Due Duration (Due - Order)
SELECT
    DATEDIFF(DAY, order_date, shipping_date) AS delivery_days,
    DATEDIFF(DAY, order_date, due_date)      AS due_days,
    COUNT(*) AS order_count
FROM gold.fact_sales
WHERE order_date IS NOT NULL 
  AND shipping_date IS NOT NULL 
  AND due_date IS NOT NULL
GROUP BY 
    DATEDIFF(DAY, order_date, shipping_date),
    DATEDIFF(DAY, order_date, due_date)
ORDER BY delivery_days;
