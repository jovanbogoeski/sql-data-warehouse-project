USE DataWarehouse

/*
===============================================================================
Ranking Analysis
===============================================================================
Purpose:
    - To rank items (e.g., products, customers) based on performance or other metrics.
    - To identify top performers or laggards.

SQL Functions Used:
    - Window Ranking Functions: RANK(), DENSE_RANK(), ROW_NUMBER(), TOP
    - Clauses: GROUP BY, ORDER BY
===============================================================================
*/

-- Which 5 products Generating the Highest Revenue?
-- Simple Ranking

select * from [gold].[dim_products]
select * from [gold].[fact_sales]

select TOP 5
    p.product_name,
    sum(f.sales_amount) as total_revenue
FROM [gold].[fact_sales] f
LEFT JOIN [gold].[dim_products] p
ON f.product_key = p.product_key
GROUP BY p.product_name
ORDER BY total_revenue desc

-- Top 5 Best-Performing Products by Total Revenue
SELECT *
FROM (
    SELECT
        p.product_name,
        SUM(f.sales_amount) AS total_revenue,
        RANK() OVER (ORDER BY SUM(f.sales_amount) DESC) AS product_rank
    FROM gold.fact_sales f
    LEFT JOIN gold.dim_products p
        ON f.product_key = p.product_key
    GROUP BY p.product_name
) AS ranked
WHERE product_rank <= 5;

-- 5 Worst-Performing Products by Total Revenue
WITH product_revenue AS (
    SELECT
        p.product_name,
        SUM(f.sales_amount) AS total_revenue,
        RANK() OVER (ORDER BY SUM(f.sales_amount) ASC) AS revenue_rank
    FROM gold.fact_sales f
    LEFT JOIN gold.dim_products p
        ON f.product_key = p.product_key
    GROUP BY p.product_name
)
SELECT product_name, total_revenue
FROM product_revenue
WHERE revenue_rank <= 5;

-- Top 10 Customers by Revenue
SELECT TOP 10
    c.customer_key,
    c.customer_number,
    c.first_name,
    c.last_name,
    SUM(f.sales_amount) AS total_revenue
FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c
    ON f.customer_key = c.customer_key
GROUP BY 
    c.customer_key,
    c.customer_number,
    c.first_name,
    c.last_name
ORDER BY total_revenue DESC;

