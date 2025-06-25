USE DataWarehouse;
GO

-- ========================================
-- Create audit.csv_file_paths
-- ========================================
IF OBJECT_ID('audit.csv_file_paths', 'U') IS NOT NULL
    DROP TABLE audit.csv_file_paths;
GO

CREATE TABLE audit.csv_file_paths (
    table_name NVARCHAR(100) PRIMARY KEY,  -- Name of the bronze table
    file_path  NVARCHAR(500)               -- Full file path to its CSV source
);
GO

-- ========================================
-- Create audit.row_count_thresholds
-- ========================================
IF OBJECT_ID('audit.row_count_thresholds', 'U') IS NOT NULL
    DROP TABLE audit.row_count_thresholds;
GO

CREATE TABLE audit.row_count_thresholds (
    table_name NVARCHAR(100) PRIMARY KEY,  -- Name of the bronze table
    min_expected_rows INT                  -- Minimum expected row count
);
GO
