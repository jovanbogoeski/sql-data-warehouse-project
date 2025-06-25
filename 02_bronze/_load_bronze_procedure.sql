USE DataWarehouse;
GO

-- ========================================
-- Create or Replace Bronze Layer Load Procedure
-- ========================================
CREATE OR ALTER PROCEDURE bronze.load_bronze
AS
BEGIN
    DECLARE @start_time DATETIME, @end_time DATETIME;
    DECLARE @batch_start_time DATETIME, @batch_end_time DATETIME;
    DECLARE @path NVARCHAR(500), @sql NVARCHAR(MAX);

    BEGIN TRY
        SET @batch_start_time = GETDATE();

        PRINT '================================================';
        PRINT '   Starting Bronze Layer Load Procedure';
        PRINT '================================================';

        ------------------------------------------------
        -- Load: crm_cust_info
        ------------------------------------------------
        SET @start_time = GETDATE();
        TRUNCATE TABLE bronze.crm_cust_info;
        SELECT @path = file_path FROM audit.csv_file_paths WHERE table_name = 'crm_cust_info';

        SET @sql = '
            BULK INSERT bronze.crm_cust_info
            FROM ''' + @path + '''
            WITH (FIRSTROW = 2, FIELDTERMINATOR = '','', ROWTERMINATOR = ''\n'', TABLOCK);';
        EXEC(@sql);

        SET @end_time = GETDATE();
        PRINT 'crm_cust_info load time: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';

        IF EXISTS (SELECT 1 FROM bronze.crm_cust_info WHERE cst_id IS NULL OR cst_key IS NULL)
            PRINT '⚠️ Nulls found in crm_cust_info key columns';
        IF EXISTS (
            SELECT cst_id FROM bronze.crm_cust_info GROUP BY cst_id HAVING COUNT(*) > 1
        )
            PRINT '⚠️ Duplicate cst_id detected in crm_cust_info';

        ------------------------------------------------
        -- Load: crm_prd_info
        ------------------------------------------------
        SET @start_time = GETDATE();
        TRUNCATE TABLE bronze.crm_prd_info;
        SELECT @path = file_path FROM audit.csv_file_paths WHERE table_name = 'crm_prd_info';

        SET @sql = '
            BULK INSERT bronze.crm_prd_info
            FROM ''' + @path + '''
            WITH (FIRSTROW = 2, FIELDTERMINATOR = '','', ROWTERMINATOR = ''\n'', TABLOCK);';
        EXEC(@sql);

        SET @end_time = GETDATE();
        PRINT 'crm_prd_info load time: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';

        IF EXISTS (SELECT 1 FROM bronze.crm_prd_info WHERE prd_id IS NULL OR prd_key IS NULL)
            PRINT '⚠️ Nulls found in crm_prd_info key columns';
        IF EXISTS (
            SELECT prd_id FROM bronze.crm_prd_info GROUP BY prd_id HAVING COUNT(*) > 1
        )
            PRINT '⚠️ Duplicate prd_id detected in crm_prd_info';

        ------------------------------------------------
        -- Load: crm_sales_details
        ------------------------------------------------
        SET @start_time = GETDATE();
        TRUNCATE TABLE bronze.crm_sales_details;
        SELECT @path = file_path FROM audit.csv_file_paths WHERE table_name = 'crm_sales_details';

        SET @sql = '
            BULK INSERT bronze.crm_sales_details
            FROM ''' + @path + '''
            WITH (FIRSTROW = 2, FIELDTERMINATOR = '','', ROWTERMINATOR = ''\n'', TABLOCK);';
        EXEC(@sql);

        SET @end_time = GETDATE();
        PRINT 'crm_sales_details load time: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';

        IF EXISTS (SELECT 1 FROM bronze.crm_sales_details WHERE sls_ord_num IS NULL)
            PRINT '⚠️ Nulls found in crm_sales_details key columns';
        IF EXISTS (
            SELECT sls_ord_num FROM bronze.crm_sales_details GROUP BY sls_ord_num HAVING COUNT(*) > 1
        )
            PRINT '⚠️ Duplicate sls_ord_num detected in crm_sales_details';

        ------------------------------------------------
        -- Load: erp_cust_az12
        ------------------------------------------------
        SET @start_time = GETDATE();
        TRUNCATE TABLE bronze.erp_cust_az12;
        SELECT @path = file_path FROM audit.csv_file_paths WHERE table_name = 'erp_cust_az12';

        SET @sql = '
            BULK INSERT bronze.erp_cust_az12
            FROM ''' + @path + '''
            WITH (FIRSTROW = 2, FIELDTERMINATOR = '','', ROWTERMINATOR = ''\n'', TABLOCK);';
        EXEC(@sql);

        SET @end_time = GETDATE();
        PRINT 'erp_cust_az12 load time: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';

        IF EXISTS (SELECT 1 FROM bronze.erp_cust_az12 WHERE cid IS NULL)
            PRINT '⚠️ Nulls found in erp_cust_az12 key columns';
        IF EXISTS (
            SELECT cid FROM bronze.erp_cust_az12 GROUP BY cid HAVING COUNT(*) > 1
        )
            PRINT '⚠️ Duplicate cid detected in erp_cust_az12';

        ------------------------------------------------
        -- Load: erp_px_cat_g1v2
        ------------------------------------------------
        SET @start_time = GETDATE();
        TRUNCATE TABLE bronze.erp_px_cat_g1v2;
        SELECT @path = file_path FROM audit.csv_file_paths WHERE table_name = 'erp_px_cat_g1v2';

        SET @sql = '
            BULK INSERT bronze.erp_px_cat_g1v2
            FROM ''' + @path + '''
            WITH (FIRSTROW = 2, FIELDTERMINATOR = '','', ROWTERMINATOR = ''\n'', TABLOCK);';
        EXEC(@sql);

        SET @end_time = GETDATE();
        PRINT 'erp_px_cat_g1v2 load time: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';

        ------------------------------------------------
        -- Load: erp_loc_a101
        ------------------------------------------------
        SET @start_time = GETDATE();
        TRUNCATE TABLE bronze.erp_loc_a101;
        SELECT @path = file_path FROM audit.csv_file_paths WHERE table_name = 'erp_loc_a101';

        SET @sql = '
            BULK INSERT bronze.erp_loc_a101
            FROM ''' + @path + '''
            WITH (FIRSTROW = 2, FIELDTERMINATOR = '','', ROWTERMINATOR = ''\n'', TABLOCK);';
        EXEC(@sql);

        SET @end_time = GETDATE();
        PRINT 'erp_loc_a101 load time: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';

        ------------------------------------------------
        -- Final Row Count Summary and Threshold Check
        ------------------------------------------------
        PRINT 'Row Count Summary and Threshold Validation:';

        SELECT
            t.table_name,
            a.row_count,
            t.min_expected_rows,
            CASE 
                WHEN a.row_count < t.min_expected_rows THEN 'BELOW THRESHOLD'
                ELSE 'OK'
            END AS status
        FROM
            (SELECT 'crm_cust_info'     AS table_name, COUNT(*) AS row_count FROM bronze.crm_cust_info
             UNION ALL
             SELECT 'crm_prd_info',     COUNT(*) FROM bronze.crm_prd_info
             UNION ALL
             SELECT 'crm_sales_details', COUNT(*) FROM bronze.crm_sales_details
             UNION ALL
             SELECT 'erp_cust_az12',    COUNT(*) FROM bronze.erp_cust_az12
             UNION ALL
             SELECT 'erp_px_cat_g1v2',  COUNT(*) FROM bronze.erp_px_cat_g1v2
             UNION ALL
             SELECT 'erp_loc_a101',     COUNT(*) FROM bronze.erp_loc_a101) a
        JOIN audit.row_count_thresholds t ON a.table_name = t.table_name
        ORDER BY t.table_name;

        SET @batch_end_time = GETDATE();
        PRINT 'Bronze Load Completed in ' + CAST(DATEDIFF(SECOND, @batch_start_time, @batch_end_time) AS NVARCHAR) + ' seconds';

    END TRY
    BEGIN CATCH
        PRINT '⚠️ ERROR: ' + ERROR_MESSAGE();
    END CATCH
END;
GO
