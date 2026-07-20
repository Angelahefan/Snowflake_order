-- =====================================================
-- 1. Create Quality Log Table for Data Validation
-- =====================================================
USE DATABASE ORDER_DB;
USE SCHEMA ORDER_DB.RAW;
USE ROLE SYSADMIN;

CREATE TABLE IF NOT EXISTS ORDER_DB.RAW.DATA_QUALITY_LOG
(
    run_id STRING,
    check_id NUMBER AUTOINCREMENT,
    table_name STRING,
    check_name STRING,
    check_result STRING,
    failed_count NUMBER,
    check_timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP()
);
