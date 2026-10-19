"""Silver job: clean bronze orders into two dimension tables and one fact table (all plain SQL)."""
from .common import run_ddl, setup


def main():
    spark, cfg, log, ddl_dir = setup("silver")
    catalog, schema = cfg["catalog"], cfg["schema"]

    source = f"{catalog}.{cfg['source_schema']}.{cfg['source_table']}"
    dim_customer = f"{catalog}.{schema}.{cfg['tables']['dim_customer']}"
    dim_product = f"{catalog}.{schema}.{cfg['tables']['dim_product']}"
    fact_items = f"{catalog}.{schema}.{cfg['tables']['fact_order_items']}"
    insert = "INSERT OVERWRITE" if cfg["write_mode"] == "overwrite" else "INSERT INTO"

    # 1. Create the tables.
    for ddl_file in cfg["ddl_files"]:
        run_ddl(spark, ddl_dir, ddl_file, catalog, schema)

    # 2. Keep one row per order (the most recently loaded one).
    spark.sql(f"""
        CREATE OR REPLACE TEMP VIEW orders_latest AS
        SELECT * EXCEPT (rn) FROM (
            SELECT *, ROW_NUMBER() OVER (PARTITION BY order_id ORDER BY ingested_at DESC) AS rn
            FROM {source}
        ) WHERE rn = 1
    """)

    # 3. Customer dimension: one row per customer, from their latest order.
    spark.sql(f"""
        {insert} {dim_customer}
        SELECT customer_id, first_name, last_name, email, country, state, updated_at FROM (
            SELECT customer.customer_id AS customer_id,
                   customer.first_name  AS first_name,
                   customer.last_name   AS last_name,
                   lower(customer.email) AS email,
                   customer.country     AS country,
                   customer.state       AS state,
                   CAST(order_ts AS TIMESTAMP) AS updated_at,
                   ROW_NUMBER() OVER (PARTITION BY customer.customer_id
                                      ORDER BY CAST(order_ts AS TIMESTAMP) DESC) AS rn
            FROM orders_latest
        ) WHERE rn = 1
    """)

    # 4. Product dimension: one row per product.
    spark.sql(f"""
        {insert} {dim_product}
        SELECT product_id, product_name, category FROM (
            SELECT item.product_id   AS product_id,
                   item.product_name AS product_name,
                   item.category     AS category,
                   ROW_NUMBER() OVER (PARTITION BY item.product_id ORDER BY order_ts DESC) AS rn
            FROM orders_latest LATERAL VIEW explode(items) t AS item
        ) WHERE rn = 1
    """)

    # 5. Fact table: one row per order line.
    spark.sql(f"""
        {insert} {fact_items}
        SELECT order_id,
               customer.customer_id,
               item.product_id,
               CAST(order_ts AS TIMESTAMP),
               CAST(CAST(order_ts AS TIMESTAMP) AS DATE),
               status,
               currency,
               item.quantity,
               CAST(item.unit_price AS DECIMAL(10,2)),
               CAST(item.quantity * item.unit_price AS DECIMAL(12,2))
        FROM orders_latest LATERAL VIEW explode(items) t AS item
    """)

    for table in (dim_customer, dim_product, fact_items):
        log.info("%s now has %s rows", table, spark.table(table).count())


if __name__ == "__main__":
    main()
