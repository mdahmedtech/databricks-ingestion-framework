-- UAT
CREATE EXTERNAL LOCATION IF NOT EXISTS ingestion_customers_uat
  URL 's3://databricks-ingestion-customers-uat/'
  WITH (STORAGE CREDENTIAL `databricks-ingestion-customers-s3-role`);

CREATE CATALOG IF NOT EXISTS uat_customers
  MANAGED LOCATION 's3://databricks-ingestion-customers-uat/';


  -- Schemas

CREATE SCHEMA IF NOT EXISTS uat_customers.bronze;
CREATE SCHEMA IF NOT EXISTS uat_customers.silver;
CREATE SCHEMA IF NOT EXISTS uat_customers.gold;

-- Confirm the storage root of each catalog (look for the matching bucket)
DESCRIBE CATALOG EXTENDED uat_customers;
DESCRIBE schema EXTENDED uat_customers.bronze


