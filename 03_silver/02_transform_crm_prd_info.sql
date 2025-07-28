USE DataWarehouse;
GO

CREATE PROCEDURE sp_load_silver_crm_prd_info AS
BEGIN
    BEGIN TRY
        -- Log start
        PRINT '>> Starting silver.crm_prd_info transformation';

        -- Truncate target table
        PRINT '>> Truncating silver.crm_prd_info';
        TRUNCATE TABLE silver.crm_prd_info;

        -- Insert cleaned and transformed product data
        INSERT INTO silver.crm_prd_info (
            prd_id, cat_id, prd_key, prd_nm, prd_cost, prd_line,
            prd_start_dt, prd_end_dt,
            dwh_create_date, dwh_source_system, dwh_filename
        )
        SELECT 
            prd_id,
            REPLACE(SUBSTRING(prd_key, 1, 5), '-', '_') AS cat_id,
            SUBSTRING(prd_key, 7, LEN(prd_key)) AS prd_key,
            prd_nm,
            COALESCE(prd_cost, 0) AS prd_cost,
            CASE 
                WHEN UPPER(TRIM(prd_line)) = 'M' THEN 'Mountain'
                WHEN UPPER(TRIM(prd_line)) = 'R' THEN 'Road'
                WHEN UPPER(TRIM(prd_line)) = 'S' THEN 'Other Sales'
                WHEN UPPER(TRIM(prd_line)) = 'T' THEN 'Touring'
                ELSE 'n/a'
            END AS prd_line,
            CAST(prd_start_dt AS DATE) AS prd_start_dt,
            CAST(LEAD(prd_start_dt) OVER (PARTITION BY prd_key ORDER BY prd_start_dt) - 1 AS DATE) AS prd_end_dt,
            GETDATE() AS dwh_create_date,
            'CRM' AS dwh_source_system,
            'crm_prd_info.csv' AS dwh_filename
        FROM bronze.crm_prd_info;

        -- Confirm row count
        DECLARE @inserted_rows INT;
        SELECT @inserted_rows = COUNT(*) FROM silver.crm_prd_info;
        PRINT '✅ silver.crm_prd_info loaded successfully. Rows inserted: ' + CAST(@inserted_rows AS NVARCHAR);

    END TRY
    BEGIN CATCH
        PRINT '❌ ERROR in silver.crm_prd_info load: ' + ERROR_MESSAGE();
    END CATCH
END;
GO
