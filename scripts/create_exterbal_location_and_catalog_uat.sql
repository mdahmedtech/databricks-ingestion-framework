-- UAT
CREATE EXTERNAL LOCATION IF NOT EXISTS ingestion_customers_uat
  URL 's3://databricks-ingestion-customers-uat/'
  WITH (STORAGE CREDENTIAL `databricks-ingestion-customers-s3-role`);

CREATE CATALOG IF NOT EXISTS uat_customers
  MANAGED LOCATION 's3://databricks-ingestion-customers-uat/';