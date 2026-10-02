/*
=============================================================
Create Database and Architecture Schemas
=============================================================
Script Purpose:
    This script creates a new database named 'DataWareHouseNovels' after checking if it already exists.
    If the database exists, it is dropped and recreated. Additionally, the script sets up three schemas
    within the database: 'bronze', 'silver', and 'gold'.

WARNING:
    Running this script will drop the entire 'DataWareHouseNovels' database if it exists.
    All data in the database will be permanently deleted. Proceed with caution
    and ensure you have proper backups before running this script.
*/

USE master;
GO

-- Drop database if it already exists
IF EXISTS (SELECT 1 FROM sys.databases WHERE name = 'DataWarehouseNovels')
BEGIN
    ALTER DATABASE DataWarehouseNovels SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE DataWarehouseNovels;
END;
GO

-- Create the database
CREATE DATABASE DataWarehouseNovels;
GO

-- Switch to the new database
USE DataWarehouseNovels;
GO

-- Create Medallion architecture schemas
CREATE SCHEMA bronze;
GO

CREATE SCHEMA silver;
GO

CREATE SCHEMA gold;
GO
