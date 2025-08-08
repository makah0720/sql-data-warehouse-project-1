/*
================================================================
Create Database and Schemas
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
GO

-- Now create the new database
CREATE DATABASE DataWarehouse;
GO

USE DataWarehouse;
GO

-- Create Schema

CREATE SCHEMA bronze;
GO
IF OBJECT_ID ('bronze.crm_cust_info','U') IS NOT NULL
  DROP TABLE bronze.crm_cust_info;
 
CREATE TABLE bronze.crm_cust_info (
   cst_id INT,
   cst_key NVARCHAR (50),
   cst_firstname NVARCHAR(50),
   cst_lastname NVARCHAR(50),
   cst_material_status NVARCHAR(50),
   cst_gndr NVARCHAR (50) ,
   cst_create_date DATE,

);

IF OBJECT_ID ('bronze.crm_sales_details','U') IS NOT NULL
  DROP TABLE bronze.crm_sales_details;

CREATE TABLE bronze.crm_sales_details (
    sls_ord_num NVARCHAR (50),
    sls_prod_key NVARCHAR (50),
    sls_cust_id INT ,
    sls_order_dT INT ,
    sls_ship_dt INT ,
    sls_due_dt INT ,
    sls_sales INT ,
    sls_quantity INT ,
    sls_price INT ,
);

IF OBJECT_ID ('bronze.crm_prd_info','U') IS NOT NULL
  DROP TABLE bronze.crm_prd_info;

CREATE TABLE bronze.crm_prd_info (
    prd_id INT ,
    prd_key NVARCHAR (50),
    prd_nm NVARCHAR (50),
    prd_cost INT,
    prd_line NVARCHAR(50),
    prd_start_dt DATE,
    prd_end_dt DATE ,
);
IF OBJECT_ID ('bronze.erp_CUST_AZ12','U') IS NOT NULL
  DROP TABLE bronze.erp_CUST_AZ12;

CREATE TABLE bronze.erp_CUST_AZ12 (
   CID NVARCHAR(50),
   BDATE DATE,
   GEN NVARCHAR (50),
);

IF OBJECT_ID ('bronze.erp_LOC_A101','U') IS NOT NULL
  DROP TABLE bronze.erp_LOC_A101;

CREATE TABLE bronze.erp_LOC_A101(
   CID NVARCHAR (50),
   CNTRY NVARCHAR (50),
);
IF OBJECT_ID ('bronze.erp_PX_CAT_G1V','U') IS NOT NULL
  DROP TABLE bronze.erp_PX_CAT_G1V;

CREATE TABLE bronze.erp_PX_CAT_G1V2(
   ID NVARCHAR (50),
   CAT NVARCHAR (50),
   SUBCAT NVARCHAR (50) ,
   MAINTENANCE NVARCHAR (50),
);

EXEC bronze.load_bronze

USE DataWarehouse;
GO

CREATE OR ALTER PROCEDURE bronze.load_bronze AS
BEGIN
DECLARE @start_time DATETIME , @end_time DATETIME,@batch_start_time DATETIME,@batch_end_time DATETIME ;
  BEGIN TRY

  SET @batch_start_time = GETDATE ();
  

PRINT '============================================================';
PRINT ' LOADING BRONZE LAYER';
PRINT '============================================================';

PRINT '------------------------------------------------------------';
PRINT 'LOADING CRM TABLES';
PRINT '------------------------------------------------------------';

    -- Load CRM Customer Info
    SET @start_time = GETDATE();
PRINT'>>> TRUNCATING TABLE bronze.crm_cust_info ';
    TRUNCATE TABLE bronze.crm_cust_info;

PRINT'>>>INSERTING DAT INTO:bronze.crm_cust_info';
    BULK INSERT bronze.crm_cust_info
    FROM 'C:\Users\HP\Desktop\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_crm\cust_info.csv'
    WITH (
        FIRSTROW = 2,
        FIELDTERMINATOR = ',',
        ROWTERMINATOR = '\n',
        TABLOCK
    );
     SET @end_time = GETDATE();
     PRINT '>>> LOAD DURATION:'+ CAST(DATEDIFF (second , @start_date ,end_date) AS NVARCHAR)+ 'seconds';
     PRINT '---------------------------'

    -- Load CRM Product Info
    SET @start_time = GETDATE();
PRINT'>>> TRUNCATING TABLE bronze.crm_prd_info ';

    TRUNCATE TABLE bronze.crm_prd_info;

PRINT'>>>INSERTING DAT INTO:bronze.crm_prd_info';

    BULK INSERT bronze.crm_prd_info
    FROM 'C:\Users\HP\Desktop\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_crm\prd_info.csv'
    WITH (
        FIRSTROW = 2,
        FIELDTERMINATOR = ',',
        ROWTERMINATOR = '\n',
        TABLOCK
    );
    SET @end_time = GETDATE();
     PRINT '>>> LOAD DURATION:'+ CAST(DATEDIFF (second , @start_date ,end_date) AS NVARCHAR)+ 'seconds';
     PRINT '---------------------------'

    -- Load CRM Sales Details
    SET @start_time = GETDATE();
PRINT'>>> TRUNCATING TABLE bronze.crm_sales_details ';

    TRUNCATE TABLE bronze.crm_sales_details;

    PRINT'>>>INSERTING DAT INTO:bronze.crm_sales_details';
    BULK INSERT bronze.crm_sales_details
    FROM 'C:\Users\HP\Desktop\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_crm\sales_details.csv'
    WITH (
        FIRSTROW = 2,
        FIELDTERMINATOR = ',',
        ROWTERMINATOR = '\n',
        TABLOCK
    );
    SET @end_time = GETDATE();
     PRINT '>>> LOAD DURATION:'+ CAST(DATEDIFF (second , @start_date ,end_date) AS NVARCHAR)+ 'seconds';
     PRINT '---------------------------'

PRINT '------------------------------------------------------------';
PRINT 'LOADING ERP TABLES';
PRINT '------------------------------------------------------------';

    -- Load ERP Customer
    SET @start_time = GETDATE();
PRINT'>>> TRUNCATING TABLE bronze.erp_CUST_AZ12 ';

    TRUNCATE TABLE bronze.erp_CUST_AZ12;

PRINT'>>>INSERTING DAT INTO:bronze.erp_CUST_AZ12';
    BULK INSERT bronze.erp_CUST_AZ12
    FROM 'C:\Users\HP\Desktop\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_erp\cust_az12.csv'
    WITH (
        FIRSTROW = 2,
        FIELDTERMINATOR = ',',
        ROWTERMINATOR = '\n',
        TABLOCK
    );
    SET @end_time = GETDATE();
     PRINT '>>> LOAD DURATION:'+ CAST(DATEDIFF (second , @start_date ,end_date) AS NVARCHAR)+ 'seconds';
     PRINT '---------------------------'

    -- Load ERP Location
    SET @start_time = GETDATE();
PRINT'>>> TRUNCATING TABLE bronze.erp_CUST_AZ1LOC_A101 ';

    TRUNCATE TABLE bronze.erp_LOC_A101;

  PRINT'>>>INSERTING DAT INTO:bronze.erp_LOC_A101';
    BULK INSERT bronze.erp_LOC_A101
    FROM 'C:\Users\HP\Desktop\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_erp\LOC_A101.csv'
    WITH (
        FIRSTROW = 2,
        FIELDTERMINATOR = ',',
        ROWTERMINATOR = '\n',
        TABLOCK
    );
    SET @end_time = GETDATE();
     PRINT '>>> LOAD DURATION:'+ CAST(DATEDIFF (second , @start_date ,end_date) AS NVARCHAR)+ 'seconds';
     PRINT '---------------------------'

    -- Load ERP Product Category
    SET @start_time = GETDATE();
    PRINT'>>> TRUNCATING TABLE bronze.erp_PX_CAT_G1V2 ';
    TRUNCATE TABLE bronze.erp_PX_CAT_G1V2;

     PRINT'>>>INSERTING DAT INTO:bronze.erp_PX_CAT_G1V2';
    BULK INSERT bronze.erp_PX_CAT_G1V2
    FROM 'C:\Users\HP\Desktop\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_erp\PX_CAT_G1V2.csv'
    WITH (
        FIRSTROW = 2,
        FIELDTERMINATOR = ',',
        ROWTERMINATOR = '\n',
        TABLOCK
    );
    SET @end_time = GETDATE();
     PRINT '>>> LOAD DURATION:'+ CAST(DATEDIFF (second , @start_date ,end_date) AS NVARCHAR)+ 'seconds';
     PRINT '---------------------------'

    SET @batch_end_time = GETDATE();

    PRINT'===============================================';
    PRINT'LOADING BRONZE LAYER IS COMPLETED';
    PRINT'  -TOTAL DURATION:'+ CAST (DATEDIFF(SECOND,@batch_start_time,@batch_end_time)AS NVARCHAR)+ 'seconds';
    PRINT'===============================================';

 END TRY
 BEGIN CATCH
 PRINT'==================================================';
 PRINT'ERROR OCCURED WHEN LOADING BRONZE LAYER';
 PRINT'ERROR MESSAGE: '+ ERROR_MESSAGE();
 PRINT'ERROR MESSAGE: '+ CAST (ERROR_NUMBER() AS NVARCHAR);
 PRINT'==================================================';
 END CATCH
END
GO

CREATE SCHEMA silver;
GO

CREATE SCHEMA gold;
GO
