-- Silver: order line fact, one row per item per order.
CREATE TABLE IF NOT EXISTS {catalog}.{schema}.silver_fact_order_items (
  order_id     STRING NOT NULL,
  customer_id  STRING NOT NULL,
  product_id   STRING NOT NULL,
  order_ts     TIMESTAMP,
  order_date   DATE,
  status       STRING,
  currency     STRING,
  quantity     BIGINT,
  unit_price   DECIMAL(10,2),
  line_total   DECIMAL(12,2)
)
USING DELTA
COMMENT 'Exploded and deduplicated order lines. Joins to the customer and product dimensions.';
