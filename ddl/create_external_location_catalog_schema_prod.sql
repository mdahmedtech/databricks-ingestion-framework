-- PROD
CREATE EXTERNAL LOCATION IF NOT EXISTS ingestion_customers_prod
  URL 's3://databricks-ingestion-customers-prod/'
  WITH (STORAGE CREDENTIAL `databricks-ingestion-customers-s3-role`);

CREATE CATALOG IF NOT EXISTS prod_customers
  MANAGED LOCATION 's3://databricks-ingestion-customers-prod/';


CREATE SCHEMA IF NOT EXISTS prod_customers.bronze;
CREATE SCHEMA IF NOT EXISTS prod_customers.silver;
CREATE SCHEMA IF NOT EXISTS prod_customers.gold;

-- Confirm the storage root of each catalog (look for the matching bucket)
DESCRIBE CATALOG EXTENDED prod_customers;
DESCRIBE schema EXTENDED prod_customers.bronze
