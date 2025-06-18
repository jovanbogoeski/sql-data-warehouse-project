-- ========================================
-- SAFE DATA WAREHOUSE INITIALIZATION SCRIPT
-- Description: Creates the 'DataWarehouse' database with bronze, silver, and gold schemas
-- ========================================

-- ========================================
-- [OPTIONAL] DROP DATABASE IF EXISTS
-- Use this section only if you want to reset the entire database (testing only!)
-- ========================================
-- IF EXISTS (SELECT 1 FROM sys.databases WHERE name = 'DataWarehouse')
-- BEGIN
--     ALTER DATABASE DataWarehouse SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
--     DROP DATABASE DataWarehouse;
-- END;
-- GO

-- ========================================
-- CREATE DATABASE IF NOT EXISTS
-- ========================================
USE master;
GO

IF DB_ID('DataWarehouse') IS NULL
    CREATE DATABASE DataWarehouse;
GO

-- ========================================
-- SWITCH TO TARGET DATABASE
-- ========================================
USE DataWarehouse;
GO

-- ========================================
-- CREATE SCHEMA: BRONZE (Raw Data)
-- ========================================
IF NOT EXISTS (
    SELECT * FROM sys.schemas WHERE name = 'bronze'
)
EXEC('CREATE SCHEMA bronze');
GO

-- ========================================
-- CREATE SCHEMA: SILVER (Cleaned Data)
-- ========================================
IF NOT EXISTS (
    SELECT * FROM sys.schemas WHERE name = 'silver'
)
EXEC('CREATE SCHEMA silver');
GO

-- ========================================
-- CREATE SCHEMA: GOLD (Business-Final Data)
-- ========================================
IF NOT EXISTS (
    SELECT * FROM sys.schemas WHERE name = 'gold'
)
EXEC('CREATE SCHEMA gold');
GO

-- ========================================
--  SETUP COMPLETE
-- ========================================
PRINT 'DataWarehouse setup complete: bronze, silver, gold schemas created.';
