USE DataWarehouse;
GO

CREATE PROCEDURE sp_load_silver_crm_cust_info AS
BEGIN
    BEGIN TRY
        -- Log start
        PRINT '>> Starting silver.crm_cust_info transformation';

        -- Truncate target
        PRINT '>> Truncating silver.crm_cust_info';
        TRUNCATE TABLE silver.crm_cust_info;

        -- Insert cleaned data
        ;WITH cleaned_cust_info AS (
            SELECT 
                cst_id,
                cst_key,
                UPPER(TRIM(cst_firstname)) AS cst_firstname,
                UPPER(TRIM(cst_lastname))  AS cst_lastname,
                CASE 
                    WHEN UPPER(TRIM(cst_marital_status)) = 'S' THEN 'Single'
                    WHEN UPPER(TRIM(cst_marital_status)) = 'M' THEN 'Married'
                    ELSE 'N/A'
                END AS cst_marital_status,
                CASE 
                    WHEN UPPER(TRIM(cst_gndr)) = 'M' THEN 'Male'
                    WHEN UPPER(TRIM(cst_gndr)) = 'F' THEN 'Female'
                    ELSE 'N/A'
                END AS cst_gndr,
                cst_create_date,
                GETDATE() AS dwh_create_date,
                'CRM'     AS dwh_source_system,
                'crm_cust_info.csv' AS dwh_filename,
                ROW_NUMBER() OVER (PARTITION BY cst_id ORDER BY cst_create_date DESC) AS flag_last
            FROM bronze.crm_cust_info
            WHERE cst_id IS NOT NULL
        )

        INSERT INTO silver.crm_cust_info (
            cst_id, cst_key, cst_firstname, cst_lastname,
            cst_marital_status, cst_gndr, cst_create_date,
            dwh_create_date, dwh_source_system, dwh_filename
        )
        SELECT 
            cst_id, cst_key, cst_firstname, cst_lastname,
            cst_marital_status, cst_gndr, cst_create_date,
            dwh_create_date, dwh_source_system, dwh_filename
        FROM cleaned_cust_info
        WHERE flag_last = 1;

        -- Confirm row count
        DECLARE @inserted_rows INT;
        SELECT @inserted_rows = COUNT(*) FROM silver.crm_cust_info;
        PRINT '✅ silver.crm_cust_info loaded successfully. Rows inserted: ' + CAST(@inserted_rows AS NVARCHAR);

    END TRY
    BEGIN CATCH
        PRINT '❌ ERROR in silver.crm_cust_info load: ' + ERROR_MESSAGE();
    END CATCH
END;
GO
