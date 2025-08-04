/*
===============================================================================
Part-to-Whole Analysis
===============================================================================
Purpose:
    - To compare performance or metrics across dimensions or time periods.
    - To evaluate differences between categories.
    - Useful for A/B testing or regional comparisons.

SQL Functions Used:
    - SUM(), AVG(): Aggregates values for comparison.
    - Window Functions: SUM() OVER() for total calculations.
===============================================================================
*/

SELECT
    p.category,
    SUM(f.sales_amount) AS total_sales,
    SUM(SUM(f.sales_amount)) OVER () AS overall_sales,
    ROUND((SUM(f.sales_amount) * 100.0) / SUM(SUM(f.sales_amount)) OVER (), 2) AS percentage_of_total
FROM gold.fact_sales f
LEFT JOIN gold.dim_products p
    ON f.product_key = p.product_key
GROUP BY p.category
ORDER BY total_sales DESC;
