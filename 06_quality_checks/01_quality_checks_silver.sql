USE DataWarehouse;
GO

/*
===============================================================================
Quality Checks for Silver Layer
===============================================================================
Purpose:
    Perform validation on Silver tables for:
    - Primary key integrity (nulls/duplicates)
    - Standardization (gender, marital status, country)
    - Invalid or inconsistent dates
    - Business rule violations (e.g., sales = quantity * price)

Usage:
    Run this script after loading Silver layer data to validate data quality.
===============================================================================
*/

-- ============================================================================
-- silver.crm_cust_info
-- ============================================================================
PRINT 'Checking: silver.crm_cust_info';

-- Nulls or duplicates in primary key
SELECT cst_id, COUNT(*) AS count
FROM silver.crm_cust_info
GROUP BY cst_id
HAVING COUNT(*) > 1 OR cst_id IS NULL;

-- Unwanted spaces in customer key
SELECT cst_key
FROM silver.crm_cust_info
WHERE cst_key != TRIM(cst_key);

-- Marital status standardization
SELECT DISTINCT cst_marital_status
FROM silver.crm_cust_info;

-- ============================================================================
-- silver.crm_prd_info
-- ============================================================================
PRINT 'Checking: silver.crm_prd_info';

-- Nulls or duplicates in product ID
SELECT prd_id, COUNT(*) AS count
FROM silver.crm_prd_info
GROUP BY prd_id
HAVING COUNT(*) > 1 OR prd_id IS NULL;

-- Trim check on product name
SELECT prd_nm
FROM silver.crm_prd_info
WHERE prd_nm != TRIM(prd_nm);

-- Negative or null product cost
SELECT prd_cost
FROM silver.crm_prd_info
WHERE prd_cost IS NULL OR prd_cost < 0;

-- Product line consistency
SELECT DISTINCT prd_line
FROM silver.crm_prd_info;

-- Invalid product date ranges
SELECT *
FROM silver.crm_prd_info
WHERE prd_end_dt < prd_start_dt;

-- ============================================================================
-- silver.crm_sales_details
-- ============================================================================
PRINT 'Checking: silver.crm_sales_details';

-- Invalid date conversion from bronze (if applicable)
SELECT *
FROM bronze.crm_sales_details
WHERE sls_due_dt <= 0 
  OR LEN(sls_due_dt) != 8
  OR sls_due_dt > 20500101
  OR sls_due_dt < 19000101;

-- Inconsistent shipping/order/due dates
SELECT *
FROM silver.crm_sales_details
WHERE sls_order_dt > sls_ship_dt 
   OR sls_order_dt > sls_due_dt;

-- Sales amount validation
SELECT *
FROM silver.crm_sales_details
WHERE sls_sales != sls_quantity * sls_price
   OR sls_sales IS NULL OR sls_quantity IS NULL OR sls_price IS NULL
   OR sls_sales <= 0 OR sls_quantity <= 0 OR sls_price <= 0;

-- ============================================================================
-- silver.erp_cust_az12
-- ============================================================================
PRINT 'Checking: silver.erp_cust_az12';

-- Out-of-range birthdates
SELECT bdate
FROM silver.erp_cust_az12
WHERE bdate < '1924-01-01' OR bdate > GETDATE();

-- Gender consistency
SELECT DISTINCT gen
FROM silver.erp_cust_az12;

-- ============================================================================
-- silver.erp_loc_a101
-- ============================================================================
PRINT 'Checking: silver.erp_loc_a101';

-- Country value consistency
SELECT DISTINCT cntry
FROM silver.erp_loc_a101
ORDER BY cntry;

-- ============================================================================
-- silver.erp_px_cat_g1v2
-- ============================================================================
PRINT 'Checking: silver.erp_px_cat_g1v2';

-- Unwanted spaces in text fields
SELECT *
FROM silver.erp_px_cat_g1v2
WHERE cat != TRIM(cat)
   OR subcat != TRIM(subcat)
   OR maintenance != TRIM(maintenance);

-- Maintenance values consistency
SELECT DISTINCT maintenance
FROM silver.erp_px_cat_g1v2;
