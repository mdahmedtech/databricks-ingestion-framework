CREATE SCHEMA IF NOT EXISTS preprod_shared_customers.gold;

CREATE OR REPLACE VIEW preprod_shared_customers.gold.daily_sales_by_category AS
SELECT  category, total_orders, '***' AS units_sold
FROM prod_customers.gold.daily_sales_by_category;



select * from preprod_shared_customers.gold.daily_sales_by_category limit 10;