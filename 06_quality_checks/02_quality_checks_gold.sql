USE DataWarehouse;
GO

/*
===============================================================================
Quality Checks - Gold Layer
===============================================================================
Script Purpose:
    This script performs quality checks to validate the integrity, consistency, 
    and accuracy of the Gold Layer. These checks ensure:
    - Uniqueness of surrogate keys in dimension tables.
    - Referential integrity between fact and dimension tables.
    - Validation of relationships in the data model for analytical purposes.

Usage Notes:
    - Investigate and resolve any discrepancies found during the checks.
===============================================================================
*/

-- ====================================================================
-- Check: Uniqueness of Customer Key in gold.dim_customers
-- Expectation: No results (customer_key must be unique)
-- ====================================================================
SELECT 
    customer_key,
    COUNT(*) AS duplicate_count
FROM gold.dim_customers
GROUP BY customer_key
HAVING COUNT(*) > 1;

-- ====================================================================
-- Check: Uniqueness of Product Key in gold.dim_products
-- Expectation: No results (product_key must be unique)
-- ====================================================================
SELECT 
    product_key,
    COUNT(*) AS duplicate_count
FROM gold.dim_products
GROUP BY product_key
HAVING COUNT(*) > 1;

-- ====================================================================
-- Check: Referential Integrity in gold.fact_sales
-- Expectation: No unmatched keys (joins to dimensions must succeed)
-- ====================================================================
SELECT 
    f.order_number,
    f.customer_key,
    f.product_key
FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c ON f.customer_key = c.customer_key
LEFT JOIN gold.dim_products p ON f.product_key = p.product_key
WHERE c.customer_key IS NULL OR p.product_key IS NULL;
