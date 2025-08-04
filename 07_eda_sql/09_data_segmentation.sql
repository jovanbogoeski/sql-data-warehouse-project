/*
===============================================================================
Data Segmentation Analysis
===============================================================================
Purpose:
    - To group data into meaningful categories for targeted insights.
    - For customer segmentation, product categorization, or regional analysis.

SQL Functions Used:
    - CASE: Defines custom segmentation logic.
    - GROUP BY: Groups data into segments.
===============================================================================
*/

/*Segment products into cost ranges and 
count how many products fall into each segment*/

SELECT 
    CASE 
        WHEN cost < 100 THEN 'Below 100'
        WHEN cost BETWEEN 100 AND 500 THEN '100-500'
        WHEN cost BETWEEN 500 AND 1000 THEN '500-1000'
        ELSE 'Above 1000'
    END AS cost_range,
    COUNT(*) AS total_products
FROM gold.dim_products
GROUP BY 
    CASE 
        WHEN cost < 100 THEN 'Below 100'
        WHEN cost BETWEEN 100 AND 500 THEN '100-500'
        WHEN cost BETWEEN 500 AND 1000 THEN '500-1000'
        ELSE 'Above 1000'
    END
ORDER BY total_products DESC;

/*
===============================================================================
Customer Segmentation
===============================================================================
Purpose:
    - Group customers by spending and activity duration.
    - Segments:
        - VIP: > €5000 & lifespan ≥ 12 months
        - Regular: ≤ €5000 & lifespan ≥ 12 months
        - New: lifespan < 12 months
===============================================================================
*/

WITH customer_spending AS (
    SELECT
        f.customer_key,
        SUM(f.sales_amount) AS total_spending,
        DATEDIFF(MONTH, MIN(f.order_date), MAX(f.order_date)) AS lifespan
    FROM gold.fact_sales f
    WHERE f.order_date IS NOT NULL
    GROUP BY f.customer_key
),
segmented_customers AS (
    SELECT 
        customer_key,
        CASE 
            WHEN lifespan >= 12 AND total_spending > 5000 THEN 'VIP'
            WHEN lifespan >= 12 THEN 'Regular'
            ELSE 'New'
        END AS customer_segment
    FROM customer_spending
)
SELECT 
    customer_segment,
    COUNT(*) AS total_customers
FROM segmented_customers
GROUP BY customer_segment
ORDER BY total_customers DESC;


    
