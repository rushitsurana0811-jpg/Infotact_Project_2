USE WAREHOUSE GEOPULSE_WH;
USE DATABASE GEOPULSE_DB;
USE SCHEMA RAW;

-- 1. Check all files inside the stage
LIST @GPS_RAW_STAGE;

-- 2. Load prepared GPS pings (skips automatically if already loaded in Week 1)
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

-- 3. Load prepared stores (skips automatically if already loaded in Week 1)
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

-- 4. Load spatial UTM store points (store_points_utm.csv)
COPY INTO STORE_POINTS_UTM (
    store_id, store_name, store_category, latitude, longitude,
    address, city, neighborhood, opening_time, closing_time,
    store_area_sqft, is_active, utm_x, utm_y, geom_wkt, location
)
FROM (
    SELECT 
        $1, $2, $3, $4::FLOAT, $5::FLOAT,
        $6, $7, $8, $9::TIME, $10::TIME,
        $11::INT, $12::BOOLEAN, $13::FLOAT, $14::FLOAT, $15,
        ST_MAKEPOINT($5::FLOAT, $4::FLOAT)::GEOGRAPHY
    FROM @GPS_RAW_STAGE/store_points_utm.csv
)
FILE_FORMAT = (FORMAT_NAME = 'GPS_CSV_FORMAT');

-- 5. Load data preparation summary (preparation_summary.csv)
COPY INTO PREPARATION_SUMMARY (metric, record_count)
FROM @GPS_RAW_STAGE/preparation_summary.csv
FILE_FORMAT = (FORMAT_NAME = 'GPS_CSV_FORMAT');

-- 6. Load audit/quarantine files (0 rows expected, keeps pipeline complete)
COPY INTO GPS_REJECTED (
    ping_id, device_id, session_id, latitude, longitude, ping_timestamp,
    accuracy_meters, speed_kmh, heading_degrees, altitude_meters,
    device_type, movement_mode, location_type, event_date, hour_of_day,
    day_of_week, is_weekend, data_source
)
FROM @GPS_RAW_STAGE/gps_rejected.csv
FILE_FORMAT = (FORMAT_NAME = 'GPS_CSV_FORMAT');

COPY INTO GPS_DUPLICATES (
    ping_id, device_id, session_id, latitude, longitude, ping_timestamp,
    accuracy_meters, speed_kmh, heading_degrees, altitude_meters,
    device_type, movement_mode, location_type, event_date, hour_of_day,
    day_of_week, is_weekend, data_source
)
FROM @GPS_RAW_STAGE/gps_duplicates.csv
FILE_FORMAT = (FORMAT_NAME = 'GPS_CSV_FORMAT');

COPY INTO STORES_REJECTED (
    store_id, store_name, store_category, latitude, longitude,
    address, city, neighborhood, opening_time, closing_time,
    store_area_sqft, is_active
)
FROM @GPS_RAW_STAGE/stores_rejected.csv
FILE_FORMAT = (FORMAT_NAME = 'GPS_CSV_FORMAT');

COPY INTO STORES_DUPLICATES (
    store_id, store_name, store_category, latitude, longitude,
    address, city, neighborhood, opening_time, closing_time,
    store_area_sqft, is_active
)
FROM @GPS_RAW_STAGE/stores_duplicates.csv
FILE_FORMAT = (FORMAT_NAME = 'GPS_CSV_FORMAT');