USE WAREHOUSE GEOPULSE_WH;

-- 1. Ensure Project Database & RAW Schema exist
CREATE DATABASE IF NOT EXISTS GEOPULSE_DB;
CREATE SCHEMA IF NOT EXISTS GEOPULSE_DB.RAW;

USE DATABASE GEOPULSE_DB;
USE SCHEMA RAW;

-- 2. Raw GPS Pings Table (Matches gps_pings.csv + GEOGRAPHY)
CREATE TABLE IF NOT EXISTS RAW_GPS_PINGS (
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

-- 3. Raw Stores Table (Matches stores.csv + GEOGRAPHY)
CREATE TABLE IF NOT EXISTS RAW_STORES (
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

-- 4. Spatial Processing Output: Store Points in UTM Coordinates (Matches store_points_utm.csv)
CREATE OR REPLACE TABLE STORE_POINTS_UTM (
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
    utm_x FLOAT,
    utm_y FLOAT,
    geom_wkt VARCHAR(255),
    location GEOGRAPHY
);

-- 5. Data Preparation Audit Summary (Matches preparation_summary.csv)
CREATE OR REPLACE TABLE PREPARATION_SUMMARY (
    metric VARCHAR(100),
    record_count INT
);

-- 6. Quarantine / Audit Tables (Matches rejected & duplicate CSVs - 0 rows currently)
CREATE OR REPLACE TABLE GPS_REJECTED LIKE RAW_GPS_PINGS;
CREATE OR REPLACE TABLE GPS_DUPLICATES LIKE RAW_GPS_PINGS;
CREATE OR REPLACE TABLE STORES_REJECTED LIKE RAW_STORES;
CREATE OR REPLACE TABLE STORES_DUPLICATES LIKE RAW_STORES;