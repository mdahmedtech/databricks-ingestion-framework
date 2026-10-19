TRUNCATE TABLE dev_customers.bronze.orders;
TRUNCATE TABLE dev_customers.silver.dim_customer;
TRUNCATE TABLE dev_customers.silver.dim_product;
TRUNCATE TABLE dev_customers.silver.fact_order_items;
TRUNCATE TABLE dev_customers.gold.daily_sales_by_category;