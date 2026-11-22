USE WAREHOUSE GEOPULSE_WH;
USE DATABASE GEOPULSE_DB;
USE SCHEMA RAW;

LIST @GPS_RAW_STAGE;



COPY INTO RAW_GPS_PINGS (
    ping_id, device_id, session_id, latitude, longitude, ping_timestamp,
    accuracy_meters, speed_kmh, heading_degrees, altitude_meters,
    device_type, movement_mode, location_type, event_date, hour_of_day,
    day_of_week, is_weekend, data_source, location
)
FROM (
    SELECT 
        $1, $2, $3, $4::FLOAT, $5::FLOAT, $6::TIMESTAMP_NTZ,
        $7::FLOAT, $8::FLOAT, $9::FLOAT, $10::FLOAT,
        $11, $12, $13, $14::DATE, $15::INT,
        $16, $17::BOOLEAN, $18,
        ST_MAKEPOINT($5::FLOAT, $4::FLOAT)::GEOGRAPHY
    FROM @GPS_RAW_STAGE/gps_pings.csv
)
FILE_FORMAT = (FORMAT_NAME = 'GPS_CSV_FORMAT');






COPY INTO RAW_STORES (
    store_id, store_name, store_category, latitude, longitude,
    address, city, neighborhood, opening_time, closing_time,
    store_area_sqft, is_active, location
)
FROM (
    SELECT 
        $1, $2, $3, $4::FLOAT, $5::FLOAT,
        $6, $7, $8, $9::TIME, $10::TIME,
        $11::INT, $12::BOOLEAN,
        ST_MAKEPOINT($5::FLOAT, $4::FLOAT)::GEOGRAPHY
    FROM @GPS_RAW_STAGE/stores.csv
)
FILE_FORMAT = (FORMAT_NAME = 'GPS_CSV_FORMAT');




-- Query 1: Verify exact row counts (100,000 pings and 20 stores)
SELECT 
    (SELECT COUNT(*) FROM RAW_GPS_PINGS) AS total_gps_pings,
    (SELECT COUNT(*) FROM RAW_STORES) AS total_stores;

-- Query 2: Preview GPS pings with the GEOGRAPHY column populated
SELECT ping_id, device_id, latitude, longitude, location 
FROM RAW_GPS_PINGS 
LIMIT 5;

-- Query 3: Preview stores with the GEOGRAPHY column populated
SELECT store_id, store_name, city, location 
FROM RAW_STORES 
LIMIT 5;

-- Query 4: Spatial distance test (pings within 500 meters of Central Coffee)
SELECT 
    p.ping_id,
    p.device_id,
    s.store_name,
    ROUND(ST_DISTANCE(p.location, s.location), 2) AS distance_meters
FROM RAW_GPS_PINGS p
JOIN RAW_STORES s ON s.store_id = 'STR0001'
WHERE ST_DWITHIN(p.location, s.location, 500)
LIMIT 10;




COPY INTO RAW_STORES (
    store_id, store_name, store_category, latitude, longitude,
    address, city, neighborhood, opening_time, closing_time,
    store_area_sqft, is_active, location
)
FROM (
    SELECT 
        $1, $2, $3, $4::FLOAT, $5::FLOAT,
        $6, $7, $8, $9::TIME, $10::TIME,
        $11::INT, $12::BOOLEAN,
        ST_MAKEPOINT($5::FLOAT, $4::FLOAT)::GEOGRAPHY
    FROM @GPS_RAW_STAGE/stores.csv
)
FILE_FORMAT = (FORMAT_NAME = 'GPS_CSV_FORMAT');




-- Check row counts of both tables
SELECT 
    (SELECT COUNT(*) FROM RAW_GPS_PINGS) AS total_gps_pings,
    (SELECT COUNT(*) FROM RAW_STORES) AS total_stores;

-- View the loaded stores and their GEOGRAPHY points
SELECT store_id, store_name, city, location FROM RAW_STORES LIMIT 5;