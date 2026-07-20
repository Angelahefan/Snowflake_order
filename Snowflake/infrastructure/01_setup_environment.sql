-- =====================================================
-- 1. Create Roles and grants
-- =====================================================

CREATE ROLE ORDER_ENGINEER_ROLE;

GRANT USAGE ON DATABASE ORDER_DB
TO ROLE ORDER_ENGINEER_ROLE;

-- =====================================================
-- 2. Create Warehouse
-- =====================================================

USE ROLE SYSADMIN;

CREATE WAREHOUSE IF NOT EXISTS ORDER_PIPELINE_WH

WITH

WAREHOUSE_SIZE = 'XSMALL'

AUTO_SUSPEND = 300

AUTO_RESUME = TRUE

INITIALLY_SUSPENDED = TRUE;


-- Check warehouse
SHOW WAREHOUSES;


-- =====================================================
-- 3. Create Database
-- =====================================================

CREATE DATABASE IF NOT EXISTS ORDER_DB;


USE DATABASE ORDER_DB;



-- =====================================================
-- 4. Create Schemas
-- =====================================================
GRANT CREATE SCHEMA ON DATABASE ORDER_DB TO ROLE SYSADMIN;

-- Raw layer
CREATE SCHEMA IF NOT EXISTS RAW;

--GRANT CREATE STAGE ON SCHEMA ORDER_DB.RAW TO ROLE SYSADMIN;


-- Staging layer
CREATE SCHEMA IF NOT EXISTS STAGING;

-- Warehouse layer
CREATE SCHEMA IF NOT EXISTS WAREHOUSE;

-- Business mart layer
CREATE SCHEMA IF NOT EXISTS MART;



-- =====================================================
-- 5. Create File Format
-- =====================================================

USE ROLE SYSADMIN;

USE DATABASE ORDER_DB;

USE SCHEMA RAW;


CREATE FILE FORMAT IF NOT EXISTS CSV_FORMAT

TYPE = CSV


FIELD_DELIMITER = ','

SKIP_HEADER = 1

FIELD_OPTIONALLY_ENCLOSED_BY = '"'

NULL_IF = ('NULL', 'null', '')

TRIM_SPACE = TRUE

REPLACE_INVALID_CHARACTERS = TRUE

SKIP_BYTE_ORDER_MARK = TRUE;


COMMENT ON FILE FORMAT CSV_FORMAT IS
'CSV file format used for daily batch ingestion from source order systems';

SHOW FILE FORMATS IN SCHEMA ORDER_DB.RAW;




