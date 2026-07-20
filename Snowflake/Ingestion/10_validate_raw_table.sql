USE DATABASE ORDER_DB;
USE SCHEMA ORDER_DB.RAW;
USE ROLE SYSADMIN;

-- ============================================================
-- Validate CUSTOMERS- customer_id unique check
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

/*
-- ============================================================
-- Validate CUSTOMERS- orther checks
-- ============================================================
-- Row count
SELECT 'CUSTOMERS Row Count' AS check_name,
       COUNT(*) AS result
FROM CUSTOMERS;

-- Null check
SELECT 'CUSTOMERS Null Customer ID' AS check_name,
       COUNT(*) AS result
FROM CUSTOMERS
WHERE customer_id IS NULL;

-- Duplicate check
SELECT customer_id,
       COUNT(*) AS duplicate_count
FROM CUSTOMERS
GROUP BY customer_id
HAVING COUNT(*) > 1;

*/

-- ============================================================
-- Validate ORDERS - Duplicate check
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
    'ORDERS' AS table_name,
    'ORDER_ID_DUPLICATE_CHECK' AS check_name,
    CASE
        WHEN COUNT(*) = 0 THEN 'PASS'
        ELSE 'FAIL'
    END AS check_result,
    COUNT(*) AS failed_count
FROM
(
    SELECT order_id
    FROM ORDER_DB.RAW.ORDERS
    GROUP BY order_id
    HAVING COUNT(*) > 1
);

/*
-- ============================================================
-- Validate Orders - orther checks
-- ============================================================
-- Row count
SELECT 'ORDERS Row Count' AS check_name,
       COUNT(*) AS result
FROM ORDERS;

-- Null check
SELECT 'ORDERS Null Order ID' AS check_name,
       COUNT(*) AS result
FROM ORDERS
WHERE order_id IS NULL;
*/

/*
-- ============================================================
-- Validate ORDER_ITEMS
-- ============================================================

-- Row count
SELECT 'ORDER_ITEMS Row Count' AS check_name,
       COUNT(*) AS result
FROM ORDER_ITEMS;

-- Null check
SELECT 'ORDER_ITEMS Null Order Item ID' AS check_name,
       COUNT(*) AS result
FROM ORDER_ITEMS
WHERE order_item_id IS NULL;

-- Duplicate check
SELECT order_item_id,
       COUNT(*) AS duplicate_count
FROM ORDER_ITEMS
GROUP BY order_item_id
HAVING COUNT(*) > 1;
*/
