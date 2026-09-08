-- Sierra Circuits replication: reproduce the zero-copy "column does not exist" problem.
-- Run ONLY after the ACCOUNTS data stream is created, mapped, and refreshed once in Data Cloud.
-- Bikramaditya's example columns were "quote count" and "fames order exist".

USE ROLE ACCOUNTADMIN;
USE SCHEMA SIERRA_REPLICA.CRM;

-- Drift 1: rename a mapped column. The DLO field ORDER_EXISTS should now show as unavailable.
ALTER TABLE ACCOUNTS RENAME COLUMN ORDER_EXISTS TO FAMES_ORDER_EXIST;

-- Drift 2: change a mapped column's type. Snowflake cannot alter NUMBER to VARCHAR in place,
-- so drop and re-add, which is what an upstream ELT job typically does.
ALTER TABLE ACCOUNTS DROP COLUMN QUOTE_COUNT;
ALTER TABLE ACCOUNTS ADD COLUMN QUOTE_COUNT VARCHAR(10);
UPDATE ACCOUNTS SET QUOTE_COUNT = CASE ACCOUNT_ID
  WHEN 'A-1001' THEN '7' WHEN 'A-1002' THEN '3' WHEN 'A-1003' THEN '1'
  WHEN 'A-1004' THEN '0' WHEN 'A-1005' THEN '2' END;

-- Drift 3: add a brand-new column. This one should appear as addable, matching what he saw.
ALTER TABLE ACCOUNTS ADD COLUMN ANNUAL_REVENUE_USD NUMBER(14,0);

DESC TABLE ACCOUNTS;

-- To undo and start over:
-- ALTER TABLE ACCOUNTS RENAME COLUMN FAMES_ORDER_EXIST TO ORDER_EXISTS;
-- ALTER TABLE ACCOUNTS DROP COLUMN ANNUAL_REVENUE_USD;
-- ALTER TABLE ACCOUNTS DROP COLUMN QUOTE_COUNT; ALTER TABLE ACCOUNTS ADD COLUMN QUOTE_COUNT NUMBER(10,0);
