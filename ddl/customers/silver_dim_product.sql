-- Silver: product dimension, one row per product.
CREATE TABLE IF NOT EXISTS {catalog}.{schema}.silver_dim_product (
  product_id    STRING NOT NULL,
  product_name  STRING,
  category      STRING
)
USING DELTA
COMMENT 'Product dimension derived from order line items.';
