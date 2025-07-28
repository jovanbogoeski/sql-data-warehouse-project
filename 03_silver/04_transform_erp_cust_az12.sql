USE DataWarehouse;
GO

CREATE PROCEDURE sp_load_silver_erp_customer_info AS
BEGIN
    BEGIN TRY
        PRINT '>> Starting silver.erp_customer_info transformation';

        -- Truncate target Silver table
        PRINT '>> Truncating silver.erp_cust_az12';
        TRUNCATE TABLE [silver].[erp_cust_az12];

        -- Insert cleaned and standardized data
        INSERT INTO [silver].[erp_cust_az12] (
            cid, bdate, gen,
            dwh_create_date, dwh_source_system, dwh_filename
        )
        SELECT 
            -- Remove NAS prefix if present
            CASE
                WHEN cid LIKE 'NAS%' THEN SUBSTRING(cid, 4, LEN(cid))
                ELSE cid
            END AS cust_id,

            -- Null out future birthdates
            CASE
                WHEN bdate > GETDATE() THEN NULL
                ELSE bdate
            END AS cust_birthdate,

            -- Standardize gender
            CASE
                WHEN UPPER(TRIM(gen)) IN ('F', 'FEMALE') THEN 'Female'
                WHEN UPPER(TRIM(gen)) IN ('M', 'MALE') THEN 'Male'
                ELSE 'n/a'
            END AS cust_gender,

            -- Metadata
            GETDATE() AS dwh_create_date,
            'ERP' AS dwh_source_system,
            'erp_customer_info.csv' AS dwh_filename

        FROM [bronze].[erp_cust_az12];

        -- Row count confirmation
        DECLARE @inserted_rows INT;
        SELECT @inserted_rows = COUNT(*) FROM [silver].[erp_cust_az12];
        PRINT '✅ silver.erp_customer_info loaded successfully. Rows inserted: ' + CAST(@inserted_rows AS NVARCHAR);

    END TRY
    BEGIN CATCH
        PRINT '❌ ERROR in silver.erp_customer_info load: ' + ERROR_MESSAGE();
    END CATCH
END;
GO
