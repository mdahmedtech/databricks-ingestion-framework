-- Bronze: raw orders exactly as received, nested structure preserved.
-- Placeholders {catalog} and {schema} are filled from config/<env>/bronze.yml
CREATE TABLE IF NOT EXISTS {catalog}.{schema}.orders (
  order_id     STRING,
  order_ts     STRING,
  status       STRING,
  currency     STRING,
  customer     STRUCT<
                 customer_id: STRING,
                 first_name:  STRING,
                 last_name:   STRING,
                 email:       STRING,
                 country:     STRING,
                 state:       STRING
               >,
  items        ARRAY<STRUCT<
                 product_id:   STRING,
                 product_name: STRING,
                 category:     STRING,
                 quantity:     BIGINT,
                 unit_price:   DOUBLE
               >>,
  source_file  STRING    COMMENT 'Path of the file the row came from',
  ingested_at  TIMESTAMP COMMENT 'Time the row was loaded into bronze'
)
USING DELTA
COMMENT 'Raw customer orders, as received. No cleaning applied.'
TBLPROPERTIES (
  'delta.enableChangeDataFeed' = 'true',
  'delta.autoOptimize.optimizeWrite' = 'true'
);
