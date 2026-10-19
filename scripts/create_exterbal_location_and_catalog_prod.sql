-- PROD
CREATE EXTERNAL LOCATION IF NOT EXISTS ingestion_customers_prod
  URL 's3://databricks-ingestion-customers-prod/'
  WITH (STORAGE CREDENTIAL `databricks-ingestion-customers-s3-role`);

CREATE CATALOG IF NOT EXISTS prod_customers
  MANAGED LOCATION 's3://databricks-ingestion-customers-prod/';