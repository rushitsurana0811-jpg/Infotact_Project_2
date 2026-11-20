-- 1. Create the compute engine (Warehouse)
CREATE WAREHOUSE IF NOT EXISTS GEOPULSE_WH 
    WAREHOUSE_SIZE = 'X-SMALL' 
    AUTO_SUSPEND = 60 
    AUTO_RESUME = TRUE;

-- 2. Create the main project Database
CREATE DATABASE IF NOT EXISTS GEOPULSE_DB;

-- 3. Create the RAW folder (Schema) inside the Database
CREATE SCHEMA IF NOT EXISTS GEOPULSE_DB.RAW;

-- 4. Tell Snowflake to use these new objects right now
USE WAREHOUSE GEOPULSE_WH;
USE DATABASE GEOPULSE_DB;
USE SCHEMA RAW;