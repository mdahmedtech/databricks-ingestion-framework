
CREATE EXTERNAL LOCATION IF NOT EXISTS ingestion_customers_deployment
  URL 's3://databricks-ingestion-customers-deployment/'
  WITH (STORAGE CREDENTIAL `databricks-ingestion-customers-s3-role`);

CREATE EXTERNAL VOLUME IF NOT EXISTS dev_customers.default.deployment
  LOCATION 's3://databricks-ingestion-customers-deployment/dev/';
