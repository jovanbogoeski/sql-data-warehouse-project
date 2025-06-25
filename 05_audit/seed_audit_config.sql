USE DataWarehouse;
GO

-- ========================================
-- Insert paths into audit.csv_file_paths
-- ========================================
INSERT INTO audit.csv_file_paths (table_name, file_path) VALUES
    ('crm_cust_info',     'C:\\Users\\Administrator\\Desktop\\sql-data-warehouse-project\\datasets\\source_crm\\cust_info.csv'),
    ('crm_prd_info',      'C:\\Users\\Administrator\\Desktop\\sql-data-warehouse-project\\datasets\\source_crm\\prd_info.csv'),
    ('crm_sales_details', 'C:\\Users\\Administrator\\Desktop\\sql-data-warehouse-project\\datasets\\source_crm\\sales_details.csv'),
    ('erp_cust_az12',     'C:\\Users\\Administrator\\Desktop\\sql-data-warehouse-project\\datasets\\source_erp\\CUST_AZ12.csv'),
    ('erp_px_cat_g1v2',   'C:\\Users\\Administrator\\Desktop\\sql-data-warehouse-project\\datasets\\source_erp\\PX_CAT_G1V2.csv'),
    ('erp_loc_a101',      'C:\\Users\\Administrator\\Desktop\\sql-data-warehouse-project\\datasets\\source_erp\\LOC_A101.csv');
GO

-- ========================================
-- Insert row count thresholds
-- ========================================
INSERT INTO audit.row_count_thresholds (table_name, min_expected_rows) VALUES
    ('crm_cust_info',      15000),
    ('crm_prd_info',         300),
    ('crm_sales_details',  50000),
    ('erp_cust_az12',      15000),
    ('erp_px_cat_g1v2',       30),
    ('erp_loc_a101',       15000);
GO
