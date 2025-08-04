
-- ==============================================================================
-- Dimension Exploration: gold.dim_customers
-- ==============================================================================

-- Unique values for key dimensions
SELECT DISTINCT country FROM gold.dim_customers;
SELECT DISTINCT gender FROM gold.dim_customers;
SELECT DISTINCT marital_status FROM gold.dim_customers;

-- Null checks
SELECT COUNT(*) AS null_country FROM gold.dim_customers WHERE country IS NULL;
SELECT COUNT(*) AS null_gender FROM gold.dim_customers WHERE gender IS NULL;

-- Top 5 countries by customer count
SELECT TOP 5 country, COUNT(*) AS customer_count
FROM gold.dim_customers
GROUP BY country
ORDER BY customer_count DESC;

-- ==============================================================================
-- Dimension Exploration: gold.dim_products
-- ==============================================================================

-- Unique categories and subcategories
SELECT DISTINCT category FROM gold.dim_products;
SELECT DISTINCT subcategory FROM gold.dim_products;

-- Null checks
SELECT COUNT(*) AS null_category FROM gold.dim_products WHERE category IS NULL;
SELECT COUNT(*) AS null_subcategory FROM gold.dim_products WHERE subcategory IS NULL;

-- Top 5 categories by product count
SELECT TOP 5 category, COUNT(*) AS product_count
FROM gold.dim_products
GROUP BY category
ORDER BY product_count DESC;
