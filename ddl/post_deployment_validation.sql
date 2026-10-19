--dev
- Bronze: raw rows with nested structure. Expect 4 rows.
SELECT order_id, status, customer.customer_id, size(items) AS item_count, source_file, ingested_at
FROM dev_customers.bronze.orders
ORDER BY order_id;

-- Silver dimensions. Expect 3 customers and 4 products.
SELECT * FROM dev_customers.silver.dim_customer ORDER BY customer_id;
SELECT * FROM dev_customers.silver.dim_product  ORDER BY product_id;

-- Silver fact: one row per order line. Expect 6 rows.
SELECT * FROM dev_customers.silver.fact_order_items ORDER BY order_id, product_id;

-- Gold: completed orders only. The cancelled furniture order must be absent.
SELECT * FROM dev_customers.gold.daily_sales_by_category ORDER BY order_date, category;


--prod
- Bronze: raw rows with nested structure. Expect 4 rows.
SELECT order_id, status, customer.customer_id, size(items) AS item_count, source_file, ingested_at
FROM prod_customers.bronze.orders
ORDER BY order_id;

-- Silver dimensions. Expect 3 customers and 4 products.
SELECT * FROM prod_customers.silver.dim_customer ORDER BY customer_id;
SELECT * FROM prod_customers.silver.dim_product  ORDER BY product_id;

-- Silver fact: one row per order line. Expect 6 rows.
SELECT * FROM prod_customers.silver.fact_order_items ORDER BY order_id, product_id;

-- Gold: completed orders only. The cancelled furniture order must be absent.
SELECT * FROM prod_customers.gold.daily_sales_by_category ORDER BY order_date, category;