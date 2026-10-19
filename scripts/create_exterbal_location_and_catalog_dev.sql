-- DEV
CREATE EXTERNAL LOCATION IF NOT EXISTS ingestion_customers_dev
  URL 's3://databricks-ingestion-customers-dev/'
  WITH (STORAGE CREDENTIAL `databricks-ingestion-customers-s3-role`);

CREATE CATALOG IF NOT EXISTS dev_customers
  MANAGED LOCATION 's3://databricks-ingestion-customers-dev/';



