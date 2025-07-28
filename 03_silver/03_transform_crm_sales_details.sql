USE DataWarehouse;
GO

CREATE PROCEDURE sp_load_silver_crm_sales_details AS
BEGIN
    BEGIN TRY
        PRINT '>> Starting silver.crm_sales_details transformation';

        -- Truncate silver table
        PRINT '>> Truncating silver.crm_sales_details';
        TRUNCATE TABLE silver.crm_sales_details;

        -- Insert cleaned and transformed records
        INSERT INTO silver.crm_sales_details (
            sls_ord_num, sls_prd_key, sls_cust_id,
            sls_order_dt, sls_ship_dt, sls_due_dt,
            sls_sales, sls_quantity, sls_price,
            dwh_create_date, dwh_source_system, dwh_filename
        )
        SELECT 
            sls_ord_num,
            sls_prd_key,
            sls_cust_id,

            -- Convert INT to DATE safely
            CASE 
                WHEN sls_order_dt = 0 OR LEN(CAST(sls_order_dt AS VARCHAR)) != 8 THEN NULL
                ELSE CONVERT(DATE, CAST(sls_order_dt AS CHAR(8)), 112)
            END AS sls_order_dt,

            CASE 
                WHEN sls_ship_dt = 0 OR LEN(CAST(sls_ship_dt AS VARCHAR)) != 8 THEN NULL
                ELSE CONVERT(DATE, CAST(sls_ship_dt AS CHAR(8)), 112)
            END AS sls_ship_dt,

            CASE 
                WHEN sls_due_dt = 0 OR LEN(CAST(sls_due_dt AS VARCHAR)) != 8 THEN NULL
                ELSE CONVERT(DATE, CAST(sls_due_dt AS CHAR(8)), 112)
            END AS sls_due_dt,

            -- Fix sales if missing, invalid, or wrong
            CASE 
                WHEN sls_sales IS NULL 
                  OR sls_sales <= 0 
                  OR sls_sales != sls_quantity * ABS(sls_price) 
                THEN sls_quantity * ABS(sls_price)
                ELSE sls_sales
            END AS sls_sales,

            sls_quantity,

            -- Fix or derive price
            CASE 
                WHEN sls_price IS NULL OR sls_price <= 0 
                THEN ABS(sls_sales) / NULLIF(sls_quantity, 0)
                ELSE sls_price
            END AS sls_price,

            GETDATE() AS dwh_create_date,
            'CRM'     AS dwh_source_system,
            'crm_sales_details.csv' AS dwh_filename

        FROM bronze.crm_sales_details;

        -- Row count confirmation
        DECLARE @inserted_rows INT;
        SELECT @inserted_rows = COUNT(*) FROM silver.crm_sales_details;
        PRINT '✅ silver.crm_sales_details loaded successfully. Rows inserted: ' + CAST(@inserted_rows AS NVARCHAR);

    END TRY
    BEGIN CATCH
        PRINT '❌ ERROR in silver.crm_sales_details load: ' + ERROR_MESSAGE();
    END CATCH
END;
GO
