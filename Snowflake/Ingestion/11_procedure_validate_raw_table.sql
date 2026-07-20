USE DATABASE ORDER_DB;
USE SCHEMA RAW;
USE ROLE SYSADMIN;
GRANT CREATE PROCEDURE
ON SCHEMA ORDER_DB.RAW
TO ROLE SYSADMIN;

CREATE OR REPLACE PROCEDURE ORDER_DB.RAW.VALIDATE_RAW_TABLE()
RETURNS STRING
LANGUAGE SQL
AS
$$
DECLARE

    current_run_id STRING DEFAULT UUID_STRING();

    failed_checks NUMBER DEFAULT 0;

    RAW_VALIDATION_FAILED EXCEPTION
    (
        -20001,
        'RAW validation failed. Check DATA_QUALITY_LOG'
    );

BEGIN

    -- ============================================================
    -- Validate CUSTOMERS - customer_id unique check
    -- ============================================================
    INSERT INTO ORDER_DB.RAW.DATA_QUALITY_LOG
    (
        run_id,
        table_name,
        check_name,
        check_result,
        failed_count
    )
    SELECT
        :current_run_id,
        'CUSTOMERS',
        'CUSTOMER_ID_UNIQUE',
        CASE
            WHEN COUNT(*) = 0 THEN 'PASS'
            ELSE 'FAIL'
        END,
        COUNT(*)
    FROM
    (
        SELECT customer_id
        FROM ORDER_DB.RAW.CUSTOMERS
        GROUP BY customer_id
        HAVING COUNT(*) > 1
    );


    -- ============================================================
    -- Validate ORDERS - order_id duplicate check
    -- ============================================================
    INSERT INTO ORDER_DB.RAW.DATA_QUALITY_LOG
    (
        run_id,
        table_name,
        check_name,
        check_result,
        failed_count
    )
    SELECT
        :current_run_id,
        'ORDERS',
        'ORDER_ID_DUPLICATE_CHECK',
        CASE
            WHEN COUNT(*) = 0 THEN 'PASS'
            ELSE 'FAIL'
        END,
        COUNT(*)
    FROM
    (
        SELECT order_id
        FROM ORDER_DB.RAW.ORDERS
        GROUP BY order_id
        HAVING COUNT(*) > 1
    );


    -- ============================================================
    -- Validate ORDER_ITEMS - order_item_id duplicate check
    -- ============================================================
    INSERT INTO ORDER_DB.RAW.DATA_QUALITY_LOG
    (
        run_id,
        table_name,
        check_name,
        check_result,
        failed_count
    )
    SELECT
        :current_run_id,
        'ORDER_ITEMS',
        'ORDER_ITEM_ID_DUPLICATE_CHECK',
        CASE
            WHEN COUNT(*) = 0 THEN 'PASS'
            ELSE 'FAIL'
        END,
        COUNT(*)
    FROM
    (
        SELECT order_item_id
        FROM ORDER_DB.RAW.ORDER_ITEMS
        GROUP BY order_item_id
        HAVING COUNT(*) > 1
    );


     -- ============================================================
    -- Check validation result
    -- ============================================================

    SELECT COUNT(*)
    INTO :failed_checks
    FROM ORDER_DB.RAW.DATA_QUALITY_LOG
    WHERE run_id = :current_run_id
    AND check_result = 'FAIL';


    -- ============================================================
    -- Stop pipeline if validation failed
    -- ============================================================

    IF (failed_checks > 0) THEN

        RAISE RAW_VALIDATION_FAILED;
        
    END IF;


    RETURN 
    'RAW validation completed successfully. Run ID: '
    || current_run_id;


END;
$$;
