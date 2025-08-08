/*
================================================================
Script Purpose:
    This script creates a new database named 'DataWarehouse' after checking if it already exists.
    If the database exists, it is dropped and recreated. Additionally, the script sets up three schemas
    within the database: 'bronze', 'silver', and 'gold'.

WARNING:
    Running this script will drop the entire 'DataWarehouse' database if it exists.
    All data in the database will be permanently deleted. Proceed with caution
    and ensure you have proper backups before running this script.
*/

USE master;
GO


-- Drop the database only if it exists
IF EXISTS (SELECT 1 FROM sys.databases WHERE name = 'DataWarehouse')
BEGIN
    -- Set it to SINGLE_USER to avoid connection issues
    EXEC('ALTER DATABASE DataWarehouse SET SINGLE_USER WITH ROLLBACK IMMEDIATE');
    DROP DATABASE DataWarehouse;
END

IF EXISTS (SELECT 1 FROM sys.databases WHERE name = 'DataWarehouse')

-- Create Database 'DataWarehouse'

CREATE DATABASE DataWarehouse;
GO

USE DataWarehouse;
GO

-- Create Schema

CREATE SCHEMA bronze;
GO
CREATE OR ALTER PROCEDURE bronze.load_bronze AS

TRUNCATE TABLE bronze.crm_cust_info;

BULK INSERT bronze.crm_cust_info
FROM 'C:\Users\HP\Desktop\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_crm\cust_info.csv'
WITH (
     FIRSTROW = 2,
     FIELDTERMINATOR = ',' ,
     TABLOCK 
     );

    SELECT COUNT (*) FROM bronze.crm_cust_info

TRUNCATE TABLE bronze.crm_prd_info;

BULK INSERT bronze.crm_prd_info
FROM 'C:\Users\HP\Desktop\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_crm\prd_info.csv'
WITH (
     FIRSTROW = 2,
     FIELDTERMINATOR = ',' ,
     TABLOCK 
     );

     SELECT COUNT (*) FROM bronze.crm_prd_info

TRUNCATE TABLE bronze.crm_sales_details;

BULK INSERT bronze.crm_sales_details
FROM 'C:\Users\HP\Desktop\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_crm\sales_details.csv'
WITH (
     FIRSTROW = 2,
     FIELDTERMINATOR = ',' ,
     TABLOCK 
     );
     SELECT COUNT (*) FROM bronze.crm_sales_details

TRUNCATE TABLE bronze.erp_cust_az12;

BULK INSERT bronze.erp_cust_az12
FROM 'C:\Users\HP\Desktop\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_erp\cust_az12.csv'
WITH (
     FIRSTROW = 2,
     FIELDTERMINATOR = ',' ,
     TABLOCK 
     );
     SELECT COUNT (*) FROM bronze.erp_cust_az12

TRUNCATE TABLE bronze.erp_LOC_A101;

BULK INSERT bronze.erp_LOC_A101
FROM 'C:\Users\HP\Desktop\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_erp\LOC_A101.csv'
WITH (
     FIRSTROW = 2,
     FIELDTERMINATOR = ',' ,
     TABLOCK 
     );
     SELECT COUNT (*) FROM bronze.erp_LOC_A101

TRUNCATE TABLE bronze.erp_PX_CAT_G1V2;

BULK INSERT bronze.erp_PX_CAT_G1V2
FROM 'C:\Users\HP\Desktop\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_erp\PX_CAT_G1V2.csv'
WITH (
     FIRSTROW = 2,
     FIELDTERMINATOR = ',' ,
     TABLOCK 
     );

     SELECT COUNT (*) FROM bronze.erp_PX_CAT_G1V2
CREATE SCHEMA silver;
GO
CREATE SCHEMA gold;
GO



