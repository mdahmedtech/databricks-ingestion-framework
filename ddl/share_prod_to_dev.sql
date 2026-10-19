
-- 1. Create the shared catalog (no-op if it already exists)
CREATE CATALOG IF NOT EXISTS preprod_shared_customers
  COMMENT 'Masked prod data exposed to non-prod via view or share';

-- 2. Create the gold schema inside the shared catalog
CREATE SCHEMA IF NOT EXISTS preprod_shared_customers.gold;

-- 3. Build the masked snapshot of prod: keep safe columns, mask units_sold, drop revenue
CREATE OR REPLACE TABLE preprod_shared_customers.gold.daily_sales_by_category_masked AS
SELECT order_date, category, total_orders, '***' AS units_sold
FROM prod_customers.gold.daily_sales_by_category;

-- 4. Remove the dev table from the share (skip this if you never added it)
ALTER SHARE prod_sales_masked_share
  REMOVE TABLE dev_customers.gold.daily_sales_by_category;

-- 5. Add the masked table to the share (the only object consumers can read)
ALTER SHARE prod_sales_masked_share
  ADD TABLE preprod_shared_customers.gold.daily_sales_by_category_masked;

-- 6. Verify the share contains only the masked table
SHOW ALL IN SHARE prod_sales_masked_share;

-- 7. Query the masked table (the same data the share exposes)
SELECT * FROM preprod_shared_customers.gold.daily_sales_by_category_masked;
