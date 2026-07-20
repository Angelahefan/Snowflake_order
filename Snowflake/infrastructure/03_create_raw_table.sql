-- =====================================================
-- 1. Create Tables in Raw layer
-- =====================================================
USE database ORDER_DB;
USE SCHEMA ORDER_DB.RAW;
USE ROLE SYSADMIN;
GRANT CREATE TABLE ON SCHEMA ORDER_DB.RAW TO ROLE SYSADMIN;

CREATE TABLE IF NOT EXISTS ORDER_DB.RAW.CUSTOMERS
(
    customer_id NUMBER,
    customer_name STRING,
    country STRING,
    created_date TIMESTAMP,
    load_filename VARCHAR,
    load_timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP()
);


CREATE TABLE IF NOT EXISTS ORDER_DB.RAW.ORDERS
(
    order_id NUMBER,
    customer_id NUMBER,
    order_date DATE,
    status STRING,
    amount NUMBER(10,2),
    load_filename VARCHAR,
    load_timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP()
);


CREATE TABLE IF NOT EXISTS ORDER_DB.RAW.ORDER_ITEMS
(
    order_item_id NUMBER,
    order_id NUMBER,
    product_id NUMBER,
    quantity NUMBER,
    price NUMBER(10,2),
    load_filename VARCHAR,
    load_timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP()
);

-- =====================================================
-- 2. schema migration- add COLUMN load_filename
-- =====================================================
ALTER TABLE RAW.CUSTOMERS
ADD COLUMN load_filename VARCHAR;

ALTER TABLE RAW.ORDER_ITEMS
ADD COLUMN load_filename VARCHAR;

ALTER TABLE RAW.ORDERS
ADD COLUMN load_filename VARCHAR;
