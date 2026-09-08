-- Sierra Circuits replication: tables shaped like their Snowflake sources.
-- Every table carries at least one of the three keys they described:
--   LEAD_ID, MID (member id), EMAIL_ID
-- plus the Salesforce record ID they write back into Snowflake (SFDC_*_ID).
-- Data is invented. A few people appear as both a Lead and a Contact with
-- slightly different formatting so fuzzy identity resolution has work to do.

USE ROLE ACCOUNTADMIN;
USE WAREHOUSE SIERRA_WH;
USE SCHEMA SIERRA_REPLICA.CRM;

CREATE OR REPLACE TABLE ACCOUNTS (
  ACCOUNT_ID        VARCHAR(20)  NOT NULL,   -- primary key
  SFDC_ACCOUNT_ID   VARCHAR(18),
  COMPANY_NAME      VARCHAR(200),
  DOMAIN            VARCHAR(100),
  INDUSTRY          VARCHAR(60),
  QUOTE_COUNT       NUMBER(10,0),            -- drift target
  ORDER_EXISTS      BOOLEAN,                 -- drift target ("fames order exist")
  LAST_MODIFIED_TS  TIMESTAMP_NTZ
);

CREATE OR REPLACE TABLE CONTACTS (
  MID               VARCHAR(20)  NOT NULL,   -- primary key (member id)
  SFDC_CONTACT_ID   VARCHAR(18),
  ACCOUNT_ID        VARCHAR(20),
  FIRST_NAME        VARCHAR(80),
  LAST_NAME         VARCHAR(80),
  EMAIL_ID          VARCHAR(200),
  PHONE             VARCHAR(40),
  TITLE             VARCHAR(120),
  LAST_MODIFIED_TS  TIMESTAMP_NTZ
);

CREATE OR REPLACE TABLE LEADS (
  LEAD_ID           VARCHAR(20)  NOT NULL,   -- primary key
  SFDC_LEAD_ID      VARCHAR(18),
  MID               VARCHAR(20),             -- populated when the lead was matched to a member
  FIRST_NAME        VARCHAR(80),
  LAST_NAME         VARCHAR(80),
  EMAIL_ID          VARCHAR(200),
  PHONE             VARCHAR(40),
  COMPANY           VARCHAR(200),
  LEAD_SOURCE       VARCHAR(60),
  STATUS            VARCHAR(40),
  LAST_MODIFIED_TS  TIMESTAMP_NTZ
);

CREATE OR REPLACE TABLE ENGAGEMENT_ACTIVITY (
  ACTIVITY_ID       VARCHAR(20)  NOT NULL,   -- primary key
  LEAD_ID           VARCHAR(20),
  MID               VARCHAR(20),
  EMAIL_ID          VARCHAR(200),
  ACTIVITY_TYPE     VARCHAR(40),             -- web_visit, quote_started, quote_submitted, file_upload
  CHANNEL           VARCHAR(40),
  PAGE_OR_TOOL      VARCHAR(200),
  ACTIVITY_TS       TIMESTAMP_NTZ NOT NULL   -- event time field for the Engagement category
);

CREATE OR REPLACE TABLE OUTREACH_ACTIVITY (
  OUTREACH_ID       VARCHAR(20)  NOT NULL,   -- primary key
  LEAD_ID           VARCHAR(20),
  EMAIL_ID          VARCHAR(200),
  SEQUENCE_NAME     VARCHAR(120),
  STEP_NUMBER       NUMBER(3,0),
  SENT_TS           TIMESTAMP_NTZ NOT NULL,  -- event time
  OPENED            BOOLEAN,
  CLICKED           BOOLEAN,
  REPLIED           BOOLEAN
);

CREATE OR REPLACE TABLE MARKETING_ACTIVITY (
  TOUCH_ID          VARCHAR(20)  NOT NULL,   -- primary key
  EMAIL_ID          VARCHAR(200),
  MID               VARCHAR(20),
  CAMPAIGN_NAME     VARCHAR(120),
  TOUCH_TYPE        VARCHAR(40),             -- email_open, webinar, ebook, tradeshow
  TOUCH_TS          TIMESTAMP_NTZ NOT NULL,  -- event time
  INTENT_POINTS     NUMBER(5,0)
);

INSERT INTO ACCOUNTS VALUES
 ('A-1001','001Dn00000AaAa1AAF','Halcyon Avionics','halcyonavionics.com','Aerospace & Defense',7,TRUE, '2026-08-30 10:00:00'),
 ('A-1002','001Dn00000AaAa2AAF','Northwind Medical Devices','northwindmed.com','Medical Devices',3,TRUE, '2026-08-28 09:15:00'),
 ('A-1003','001Dn00000AaAa3AAF','Kestrel Robotics','kestrelrobotics.io','Industrial Automation',1,FALSE,'2026-09-01 14:20:00'),
 ('A-1004','001Dn00000AaAa4AAF','Tidewater Sensor Labs','tidewatersensors.com','IoT',0,FALSE,'2026-09-02 08:05:00'),
 ('A-1005',NULL,               'Pinecrest Labs','pinecrestlabs.org','Research',2,TRUE, '2026-09-03 16:40:00');

INSERT INTO CONTACTS VALUES
 ('M-5001','003Dn00000BbBb1AAF','A-1001','Priya','Raman','priya.raman@halcyonavionics.com','+1 408-555-0101','Hardware Engineering Manager','2026-08-30 10:00:00'),
 ('M-5002','003Dn00000BbBb2AAF','A-1001','Daniel','Okafor','daniel.okafor@halcyonavionics.com','+1 408-555-0102','Procurement Lead','2026-08-30 10:00:00'),
 ('M-5003','003Dn00000BbBb3AAF','A-1002','Mei','Tanaka','mei.tanaka@northwindmed.com','+1 650-555-0103','PCB Designer','2026-08-28 09:15:00'),
 ('M-5004','003Dn00000BbBb4AAF','A-1002','Luis','Herrera','l.herrera@northwindmed.com','+1 650-555-0104','Director of Engineering','2026-08-28 09:15:00'),
 ('M-5005','003Dn00000BbBb5AAF','A-1003','Sasha','Petrov','sasha@kestrelrobotics.io','+1 510-555-0105','Founder','2026-09-01 14:20:00'),
 ('M-5006','003Dn00000BbBb6AAF','A-1004','Jordan','Whitfield','jordan.whitfield@tidewatersensors.com','+1 831-555-0106','Electrical Engineer','2026-09-02 08:05:00'),
 ('M-5007',NULL,               'A-1005','Amara','Osei','amara.osei@pinecrestlabs.org','+1 415-555-0107','Lab Manager','2026-09-03 16:40:00'),
 ('M-5008','003Dn00000BbBb8AAF','A-1001','Tomás','Silva','tomas.silva@halcyonavionics.com',NULL,'Test Engineer','2026-08-30 10:00:00');

INSERT INTO LEADS VALUES
 -- Same person as contact M-5003, different casing and phone format. Should unify.
 ('L-9001','00QDn00000CcCc1AAF',NULL,  'MEI','TANAKA','Mei.Tanaka@NorthwindMed.com','6505550103','Northwind Medical','Web Quote','Working','2026-09-01 11:00:00'),
 -- Same person as contact M-5006, already matched to member.
 ('L-9002','00QDn00000CcCc2AAF','M-5006','Jordan','Whitfield','jordan.whitfield@tidewatersensors.com','+1 (831) 555-0106','Tidewater Sensor Labs','Trade Show','Qualified','2026-09-02 08:05:00'),
 -- Net-new leads, no contact yet.
 ('L-9003','00QDn00000CcCc3AAF',NULL,  'Hannah','Brooks','hannah.brooks@orbitalcomms.net','+1 303-555-0110','Orbital Comms','Webinar','New','2026-09-04 13:30:00'),
 ('L-9004','00QDn00000CcCc4AAF',NULL,  'Wei','Zhang','wei.zhang@lumenfab.com','+1 206-555-0111','LumenFab','Web Quote','New','2026-09-05 09:45:00'),
 ('L-9005',NULL,               NULL,  'Ravi','Menon','ravi.menon@gmail.com',NULL,'Independent','Ebook Download','New','2026-09-05 17:10:00'),
 -- Duplicate of L-9003 with a typo. Fuzzy name + exact email should still unify.
 ('L-9006','00QDn00000CcCc6AAF',NULL,  'Hanna','Brooks','hannah.brooks@orbitalcomms.net',NULL,'Orbital Communications','Web Quote','New','2026-09-06 10:00:00');

INSERT INTO ENGAGEMENT_ACTIVITY VALUES
 ('E-1','L-9001',NULL,   'Mei.Tanaka@NorthwindMed.com','web_visit','web','/pcb-quote','2026-09-01 10:52:00'),
 ('E-2','L-9001',NULL,   'Mei.Tanaka@NorthwindMed.com','quote_started','web','Quote Tool','2026-09-01 10:58:00'),
 ('E-3',NULL,   'M-5003','mei.tanaka@northwindmed.com','quote_submitted','web','Quote Tool','2026-09-01 11:20:00'),
 ('E-4',NULL,   'M-5001','priya.raman@halcyonavionics.com','file_upload','web','Gerber Upload','2026-08-30 09:30:00'),
 ('E-5',NULL,   'M-5001','priya.raman@halcyonavionics.com','quote_submitted','web','Quote Tool','2026-08-30 09:48:00'),
 ('E-6','L-9004',NULL,   'wei.zhang@lumenfab.com','web_visit','web','/capabilities/hdi','2026-09-05 09:40:00'),
 ('E-7','L-9004',NULL,   'wei.zhang@lumenfab.com','quote_started','web','Quote Tool','2026-09-05 09:44:00'),
 ('E-8','L-9002','M-5006','jordan.whitfield@tidewatersensors.com','web_visit','web','/design-guides','2026-09-02 07:55:00'),
 ('E-9',NULL,   'M-5005','sasha@kestrelrobotics.io','quote_started','web','Quote Tool','2026-09-01 14:00:00'),
 ('E-10','L-9005',NULL,  'ravi.menon@gmail.com','web_visit','web','/blog/impedance','2026-09-05 17:05:00');

INSERT INTO OUTREACH_ACTIVITY VALUES
 ('O-1','L-9003','hannah.brooks@orbitalcomms.net','Webinar Follow-up',1,'2026-09-04 15:00:00',TRUE,TRUE,FALSE),
 ('O-2','L-9003','hannah.brooks@orbitalcomms.net','Webinar Follow-up',2,'2026-09-06 15:00:00',TRUE,FALSE,FALSE),
 ('O-3','L-9004','wei.zhang@lumenfab.com','Abandoned Quote',1,'2026-09-05 12:00:00',TRUE,TRUE,TRUE),
 ('O-4','L-9005','ravi.menon@gmail.com','Ebook Nurture',1,'2026-09-06 09:00:00',FALSE,FALSE,FALSE),
 ('O-5','L-9001','Mei.Tanaka@NorthwindMed.com','Abandoned Quote',1,'2026-09-02 12:00:00',TRUE,FALSE,FALSE),
 ('O-6',NULL,    'daniel.okafor@halcyonavionics.com','Customer QBR',1,'2026-08-31 10:00:00',TRUE,FALSE,TRUE);

INSERT INTO MARKETING_ACTIVITY VALUES
 ('T-1','hannah.brooks@orbitalcomms.net',NULL,'RF Design Webinar Q3','webinar','2026-09-04 12:00:00',25),
 ('T-2','ravi.menon@gmail.com',NULL,'Impedance Control Ebook','ebook','2026-09-05 17:08:00',10),
 ('T-3','jordan.whitfield@tidewatersensors.com','M-5006','PCB West 2026','tradeshow','2026-09-02 07:30:00',40),
 ('T-4','priya.raman@halcyonavionics.com','M-5001','HDI Newsletter Aug','email_open','2026-08-29 08:10:00',5),
 ('T-5','mei.tanaka@northwindmed.com','M-5003','HDI Newsletter Aug','email_open','2026-08-29 08:12:00',5),
 ('T-6','wei.zhang@lumenfab.com',NULL,'HDI Newsletter Sep','email_open','2026-09-05 08:00:00',5);

-- Row counts for the runbook.
SELECT 'ACCOUNTS' t, COUNT(*) n FROM ACCOUNTS
UNION ALL SELECT 'CONTACTS', COUNT(*) FROM CONTACTS
UNION ALL SELECT 'LEADS', COUNT(*) FROM LEADS
UNION ALL SELECT 'ENGAGEMENT_ACTIVITY', COUNT(*) FROM ENGAGEMENT_ACTIVITY
UNION ALL SELECT 'OUTREACH_ACTIVITY', COUNT(*) FROM OUTREACH_ACTIVITY
UNION ALL SELECT 'MARKETING_ACTIVITY', COUNT(*) FROM MARKETING_ACTIVITY;
