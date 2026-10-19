-- Silver: customer dimension, one row per customer (latest record wins).
CREATE TABLE IF NOT EXISTS {catalog}.{schema}.dim_customer (
  customer_id  STRING NOT NULL,
  first_name   STRING,
  last_name    STRING,
  email        STRING COMMENT 'Lower-cased. PII: restrict access or mask.',
  country      STRING,
  state        STRING,
  updated_at   TIMESTAMP COMMENT 'Timestamp of the order the record came from'
)
USING DELTA
COMMENT 'Customer dimension, deduplicated to the latest record per customer.';
