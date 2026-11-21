USE WAREHOUSE GEOPULSE_WH;
USE DATABASE GEOPULSE_DB;
USE SCHEMA RAW;

-- 1. Table for gps_pings.csv (18 CSV columns + 1 GEOGRAPHY column)
CREATE OR REPLACE TABLE RAW_GPS_PINGS (
    ping_id VARCHAR(30),
    device_id VARCHAR(30),
    session_id VARCHAR(30),
    latitude FLOAT,
    longitude FLOAT,
    ping_timestamp TIMESTAMP_NTZ,
    accuracy_meters FLOAT,
    speed_kmh FLOAT,
    heading_degrees FLOAT,
    altitude_meters FLOAT,
    device_type VARCHAR(30),
    movement_mode VARCHAR(30),
    location_type VARCHAR(30),
    event_date DATE,
    hour_of_day INT,
    day_of_week VARCHAR(15),
    is_weekend BOOLEAN,
    data_source VARCHAR(50),
    location GEOGRAPHY
);

-- 2. Table for stores.csv (12 CSV columns + 1 GEOGRAPHY column)
CREATE OR REPLACE TABLE RAW_STORES (
    store_id VARCHAR(20),
    store_name VARCHAR(100),
    store_category VARCHAR(50),
    latitude FLOAT,
    longitude FLOAT,
    address VARCHAR(255),
    city VARCHAR(50),
    neighborhood VARCHAR(50),
    opening_time TIME,
    closing_time TIME,
    store_area_sqft INT,
    is_active BOOLEAN,
    location GEOGRAPHY
);