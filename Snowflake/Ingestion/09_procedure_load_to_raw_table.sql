USE DATABASE ORDER_DB;
USE SCHEMA RAW;
USE ROLE SYSADMIN;
GRANT CREATE PROCEDURE
ON SCHEMA ORDER_DB.RAW
TO ROLE SYSADMIN;

CREATE OR REPLACE PROCEDURE ORDER_DB.RAW.LOAD_TO_RAW_TABLE()
RETURNS STRING
LANGUAGE SQL
AS
$$
BEGIN
    truncate table BAKERY_DB.ORDERS.RAW.CUSTOMERS;
    truncate table BAKERY_DB.ORDERS.RAW.ORDERS;
    truncate table BAKERY_DB.ORDERS.RAW.order_item;
    -- ============================================================
    -- 1. COPY INTO CUSTOMERS
    -- ============================================================
    COPY INTO ORDER_DB.RAW.CUSTOMERS
    (
        customer_id,
        customer_name,
        country,
        created_date,
        load_filename
    )
    FROM (
        SELECT 
            $1,
            $2,
            $3,
            $4,
            METADATA$FILENAME
        FROM @ORDER_DB.RAW.ORDER_STAGE/customers.csv
    )
    FILE_FORMAT = (
        FORMAT_NAME = ORDER_DB.RAW.CSV_FORMAT,
        SKIP_HEADER = 1
    )
    ON_ERROR = 'ABORT_STATEMENT';


    -- ============================================================
    -- 2. COPY INTO ORDERS
    -- ============================================================
    COPY INTO ORDER_DB.RAW.ORDERS
    (
        order_id,
        customer_id,
        order_date,
        status,
        amount,
        load_filename
    )
    FROM (
        SELECT 
            $1,
            $2,
            $3,
            $4,
            $5,
            METADATA$FILENAME
        FROM @ORDER_DB.RAW.ORDER_STAGE/orders.csv
    )
    FILE_FORMAT = (
        FORMAT_NAME = ORDER_DB.RAW.CSV_FORMAT
    )
    ON_ERROR = 'ABORT_STATEMENT';


    -- ============================================================
    -- 3. COPY INTO ORDER_ITEMS
    -- ============================================================
    COPY INTO ORDER_DB.RAW.ORDER_ITEMS
    (
        order_item_id,
        order_id,
        product_id,
        quantity,
        price,
        load_filename
    )
    FROM (
        SELECT 
            $1,
            $2,
            $3,
            $4,
            $5,
            METADATA$FILENAME
        FROM @ORDER_DB.RAW.ORDER_STAGE/order_items.csv
    )
    FILE_FORMAT = (
        FORMAT_NAME = ORDER_DB.RAW.CSV_FORMAT
    )
    ON_ERROR = 'ABORT_STATEMENT';


    RETURN 'Procedure - RAW tables loaded successfully';

END;
$$;
