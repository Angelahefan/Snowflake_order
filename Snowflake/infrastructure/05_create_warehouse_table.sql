-- =====================================================
-- 1. Create Warehouse Tables
-- =====================================================
USE database ORDER_DB;
USE SCHEMA ORDER_DB.WAREHOUSE;
USE ROLE SYSADMIN;
GRANT CREATE TABLE ON SCHEMA ORDER_DB.WAREHOUSE TO ROLE SYSADMIN;

CREATE TABLE IF NOT EXISTS WAREHOUSE.DIM_CUSTOMER
(
customer_key NUMBER AUTOINCREMENT,
customer_id NUMBER,
customer_name STRING,
country STRING
);



CREATE TABLE IF NOT EXISTS WAREHOUSE.DIM_PRODUCT
(
product_key NUMBER AUTOINCREMENT,
product_id NUMBER,
product_name STRING,
category STRING
);



CREATE TABLE IF NOT EXISTS WAREHOUSE.FACT_ORDER
(
order_key NUMBER AUTOINCREMENT,
order_id NUMBER,
customer_key NUMBER,
order_date DATE,
amount NUMBER(10,2)
);
