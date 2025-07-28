USE DataWarehouse;
GO

CREATE PROCEDURE sp_load_silver_erp_px_cat_g1v2 AS
BEGIN
    BEGIN TRY
        PRINT '>> Starting silver.erp_px_cat_g1v2 transformation';

        -- Truncate Silver table
        PRINT '>> Truncating silver.erp_px_cat_g1v2';
        TRUNCATE TABLE silver.erp_px_cat_g1v2;

        -- Insert directly from Bronze with metadata
        INSERT INTO silver.erp_px_cat_g1v2 (
            id,
            cat,
            subcat,
            maintenance,
            dwh_create_date,
            dwh_source_system,
            dwh_filename
        )
        SELECT 
            id,
            cat,
            subcat,
            maintenance,
            GETDATE() AS dwh_create_date,
            'ERP' AS dwh_source_system,
            'erp_px_cat_g1v2.csv' AS dwh_filename
        FROM bronze.erp_px_cat_g1v2;

        -- Log inserted row count
        DECLARE @inserted_rows INT;
        SELECT @inserted_rows = COUNT(*) FROM silver.erp_px_cat_g1v2;
        PRINT '✅ silver.erp_px_cat_g1v2 loaded successfully. Rows inserted: ' + CAST(@inserted_rows AS NVARCHAR);

    END TRY
    BEGIN CATCH
        PRINT '❌ ERROR in silver.erp_px_cat_g1v2 load: ' + ERROR_MESSAGE();
    END CATCH
END;
GO
