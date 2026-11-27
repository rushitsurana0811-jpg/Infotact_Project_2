USE WAREHOUSE GEOPULSE_WH;
USE DATABASE GEOPULSE_DB;
USE SCHEMA RAW;

-- ==========================================
-- 1. ROW COUNT CHECKS ACROSS ALL TABLES
-- ==========================================
SELECT 'RAW_GPS_PINGS' AS table_name, COUNT(*) AS loaded_rows FROM RAW_GPS_PINGS
UNION ALL
SELECT 'RAW_STORES' AS table_name, COUNT(*) AS loaded_rows FROM RAW_STORES
UNION ALL
SELECT 'STORE_POINTS_UTM' AS table_name, COUNT(*) AS loaded_rows FROM STORE_POINTS_UTM
UNION ALL
SELECT 'PREPARATION_SUMMARY' AS table_name, COUNT(*) AS loaded_rows FROM PREPARATION_SUMMARY
UNION ALL
SELECT 'GPS_REJECTED' AS table_name, COUNT(*) AS loaded_rows FROM GPS_REJECTED
UNION ALL
SELECT 'GPS_DUPLICATES' AS table_name, COUNT(*) AS loaded_rows FROM GPS_DUPLICATES
UNION ALL
SELECT 'STORES_REJECTED' AS table_name, COUNT(*) AS loaded_rows FROM STORES_REJECTED
UNION ALL
SELECT 'STORES_DUPLICATES' AS table_name, COUNT(*) AS loaded_rows FROM STORES_DUPLICATES;

-- ==========================================
-- 2. COMPARE LOADED COUNTS VS PREPARATION_SUMMARY
-- ==========================================
SELECT * FROM PREPARATION_SUMMARY;

-- ==========================================
-- 3. DUPLICATE IDENTIFIER CHECKS (Must return 0 rows!)
-- ==========================================
-- Check duplicate PingIDs
SELECT ping_id, COUNT(*) AS occurrences
FROM RAW_GPS_PINGS
GROUP BY ping_id
HAVING COUNT(*) > 1;

-- Check duplicate StoreIDs in RAW_STORES
SELECT store_id, COUNT(*) AS occurrences
FROM RAW_STORES
GROUP BY store_id
HAVING COUNT(*) > 1;

-- Check duplicate StoreIDs in STORE_POINTS_UTM
SELECT store_id, COUNT(*) AS occurrences
FROM STORE_POINTS_UTM
GROUP BY store_id
HAVING COUNT(*) > 1;

-- ==========================================
-- 4. VERIFY SPATIAL COLUMNS (UTM & GEOGRAPHY)
-- ==========================================
SELECT 
    store_id, 
    store_name, 
    utm_x, 
    utm_y, 
    geom_wkt, 
    location 
FROM STORE_POINTS_UTM 
LIMIT 5;

-- ==========================================
-- 5. CONFIRM DATA AVAILABILITY FOR DBT
-- ==========================================
-- Verify all tables exist and are visible in GEOPULSE_DB.RAW
SHOW TABLES IN SCHEMA GEOPULSE_DB.RAW;

-- Grant read permissions so dbt models can query all RAW tables
GRANT USAGE ON WAREHOUSE GEOPULSE_WH TO ROLE SYSADMIN;
GRANT USAGE ON DATABASE GEOPULSE_DB TO ROLE SYSADMIN;
GRANT USAGE ON SCHEMA GEOPULSE_DB.RAW TO ROLE SYSADMIN;
GRANT SELECT ON ALL TABLES IN SCHEMA GEOPULSE_DB.RAW TO ROLE SYSADMIN;