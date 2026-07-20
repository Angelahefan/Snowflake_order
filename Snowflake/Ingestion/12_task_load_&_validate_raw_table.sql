-- =====================================================================
-- 1. declare warehouse， database and schema
-- =====================================================================
USE DATABASE ORDER_DB;
USE SCHEMA ORDER_DB.RAW;
USE ROLE SYSADMIN;
GRANT CREATE TASK
ON SCHEMA ORDER_DB.RAW
TO ROLE SYSADMIN;
-- =====================================================================
-- 2. create root task
-- =====================================================================
CREATE OR REPLACE TASK t_root
  warehouse = ORDER_PIPELINE_WH
  schedule = 'USING CRON 0 2 * * * Australia/Melbourne'
as
    SELECT 1;
-- =====================================================================
-- 3. load Raw 
-- =====================================================================
    CREATE OR REPLACE TASK ORDER_DB.RAW.LOAD_TO_RAW_TABLE_TASK
    WAREHOUSE = ORDER_PIPELINE_WH
    AFTER t_root
AS
BEGIN
    CALL ORDER_DB.RAW.LOAD_TO_RAW_TABLE();
END;
-- =====================================================================
-- 4. Validate Raw Table Task
-- =====================================================================
    CREATE OR REPLACE TASK ORDER_DB.RAW.VALIDATE_RAW_TABLE_TASK
    WAREHOUSE = ORDER_PIPELINE_WH
    AFTER ORDER_DB.RAW.LOAD_TO_RAW_TABLE_TASK
AS
BEGIN
  CALL ORDER_DB.RAW.VALIDATE_RAW_TABLE();
END;

