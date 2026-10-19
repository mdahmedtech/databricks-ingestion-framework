-- Silver: product dimension, one row per product.
CREATE TABLE IF NOT EXISTS {catalog}.{schema}.dim_product (
  product_id    STRING NOT NULL,
  product_name  STRING,
  category      STRING
)
USING DELTA
LOCATION 's3://databricks-ingestion-customers-{env}/{schema}/dim_product'
COMMENT 'Product dimension derived from order line items.';