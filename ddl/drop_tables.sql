DROP TABLE IF EXISTS dev_customers.bronze.orders;
DROP TABLE IF EXISTS dev_customers.silver.dim_customer;
DROP TABLE IF EXISTS dev_customers.silver.dim_product;
DROP TABLE IF EXISTS dev_customers.silver.fact_order_items;
DROP TABLE IF EXISTS dev_customers.gold.daily_sales_by_category;


DROP TABLE IF EXISTS prod_customers.bronze.orders;
DROP TABLE IF EXISTS prod_customers.silver.dim_customer;
DROP TABLE IF EXISTS prod_customers.silver.dim_product;
DROP TABLE IF EXISTS prod_customers.silver.fact_order_items;
DROP TABLE IF EXISTS prod_customers.gold.daily_sales_by_category;