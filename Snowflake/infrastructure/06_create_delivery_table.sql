-- =====================================================
-- 1. Create Mart Tables
-- =====================================================
USE database ORDER_DB;
USE SCHEMA ORDER_DB.MART;
USE ROLE SYSADMIN;
GRANT CREATE TABLE ON SCHEMA ORDER_DB.MART TO ROLE SYSADMIN;

CREATE TABLE IF NOT EXISTS MART.DAILY_SALES_SUMMARY
(
sales_date DATE,
total_orders NUMBER,
total_revenue NUMBER(12,2)
);
