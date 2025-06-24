USE DataWarehouse
-- Drop and recreate bronze.crm_cust_info
IF OBJECT_ID('bronze.crm_cust_info', 'U') IS NOT NULL
    DROP TABLE bronze.crm_cust_info;
GO
-- Customer information from the CRM system (bronze layer)
CREATE TABLE bronze.crm_cust_info (
    cst_id INT,                         -- Customer ID (INT)
    cst_key NVARCHAR(50),              -- Unique customer key (string, up to 50 chars)
    cst_firstname NVARCHAR(50),        -- First name (string)
    cst_lastname NVARCHAR(50),         -- Last name (string)
    cst_marital_status NVARCHAR(50),   -- Marital status (string)
    cst_gndr NVARCHAR(50),             -- Gender (string)
    cst_create_date DATE               -- Record creation date (date only)
);
GO

-- Drop and recreate bronze.crm_prd_info
IF OBJECT_ID('bronze.crm_prd_info', 'U') IS NOT NULL
    DROP TABLE bronze.crm_prd_info;
GO
-- Product information from the CRM system
CREATE TABLE bronze.crm_prd_info (
    prd_id INT,                        -- Product ID (INT)
    prd_key NVARCHAR(50),             -- Unique product key (string)
    prd_nm NVARCHAR(50),              -- Product name (string)
    prd_cost INT,                     -- Product cost (stored as INT)
    prd_line NVARCHAR(50),            -- Product line or category (string)
    prd_start_dt DATETIME,            -- Start date of product availability (date + time)
    prd_end_dt DATETIME               -- End date of product availability (date + time)
);
GO

-- Drop and recreate bronze.crm_sales_details
IF OBJECT_ID('bronze.crm_sales_details', 'U') IS NOT NULL
    DROP TABLE bronze.crm_sales_details;
GO
-- Sales transaction details from the CRM system
CREATE TABLE bronze.crm_sales_details (
    sls_ord_num NVARCHAR(50),         -- Sales order number (string)
    sls_prd_key NVARCHAR(50),         -- Product key (string)
    sls_cust_id INT,                  -- Customer ID (INT)
    sls_order_dt INT,                 -- Order date ()
    sls_ship_dt INT,                  -- Shipping date (as INT)
    sls_due_dt INT,                   -- Due date (as INT)
    sls_sales INT,                    -- Total sales value (INT)
    sls_quantity INT,                 -- Quantity sold (INT)
    sls_price INT                     -- Price per unit (INT)
);
GO

-- Drop and recreate bronze.erp_cust_az12
IF OBJECT_ID('bronze.erp_cust_az12', 'U') IS NOT NULL
    DROP TABLE bronze.erp_cust_az12;
GO
-- Customer demographic info from ERP (birthdate, gender)
CREATE TABLE bronze.erp_cust_az12 (
    cid NVARCHAR(50),                 -- Customer ID (string)
    bdate DATE,                       -- Birthdate (date only)
    gen NVARCHAR(50)                  -- Gender (string)
);
GO

-- Drop and recreate bronze.erp_px_cat_g1v2
IF OBJECT_ID('bronze.erp_px_cat_g1v2', 'U') IS NOT NULL
    DROP TABLE bronze.erp_px_cat_g1v2;
GO
-- Product category and maintenance metadata from ERP
CREATE TABLE bronze.erp_px_cat_g1v2 (
    id NVARCHAR(50),                  -- Product ID (string)
    cat NVARCHAR(50),                 -- Category (string)
    subcat NVARCHAR(50),              -- Subcategory (string)
    maintenance NVARCHAR(50)          -- Maintenance info (string)
);
GO

-- Drop and recreate bronze.erp_loc_a101
IF OBJECT_ID('bronze.erp_loc_a101', 'U') IS NOT NULL
    DROP TABLE bronze.erp_loc_a101;
GO
-- Customer location details from ERP
CREATE TABLE bronze.erp_loc_a101 (
    cid NVARCHAR(50),                 -- Customer ID (string)
    cntry NVARCHAR(50)                -- Country name or code (string)
);
GO
