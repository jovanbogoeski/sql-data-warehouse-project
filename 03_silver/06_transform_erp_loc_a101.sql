USE DataWarehouse;
GO

CREATE PROCEDURE sp_load_silver_erp_loc_a101 AS
BEGIN
    BEGIN TRY
        PRINT '>> Starting silver.erp_loc_a101 transformation';

        -- Truncate the Silver table
        PRINT '>> Truncating silver.erp_loc_a101';
        TRUNCATE TABLE silver.erp_loc_a101;

        -- Insert cleaned and normalized data
        INSERT INTO silver.erp_loc_a101 (
            cid,
            cntry,
            dwh_create_date,
            dwh_source_system,
            dwh_filename
        )
        SELECT 
            -- Clean CID: remove all dashes
            REPLACE(cid, '-', '') AS cid,

            -- Clean CNTRY: normalize country values
            CASE
                WHEN TRIM(cntry) = 'DE' THEN 'Germany'
                WHEN TRIM(cntry) IN ('US', 'USA') THEN 'United States'
                WHEN TRIM(cntry) = '' OR cntry IS NULL THEN 'n/a'
                ELSE TRIM(cntry)
            END AS cntry,

            GETDATE() AS dwh_create_date,
            'ERP' AS dwh_source_system,
            'erp_loc_a101.csv' AS dwh_filename

        FROM bronze.erp_loc_a101;

        -- Log row count
        DECLARE @inserted_rows INT;
        SELECT @inserted_rows = COUNT(*) FROM silver.erp_loc_a101;
        PRINT '✅ silver.erp_loc_a101 loaded successfully. Rows inserted: ' + CAST(@inserted_rows AS NVARCHAR);

    END TRY
    BEGIN CATCH
        PRINT '❌ ERROR in silver.erp_loc_a101 load: ' + ERROR_MESSAGE();
    END CATCH
END;
GO
