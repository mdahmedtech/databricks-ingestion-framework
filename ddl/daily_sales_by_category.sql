CREATE TABLE IF NOT EXISTS {catalog}.{schema}.daily_sales_by_category (
  order_date    DATE,
  category      STRING,
  total_orders  BIGINT,
  units_sold    BIGINT,
  revenue       DECIMAL(14,2)
)
USING DELTA
LOCATION 's3://databricks-ingestion-customers-{env}/{schema}/daily_sales_by_category'
COMMENT 'Daily sales aggregate by product category (COMPLETED orders only).';