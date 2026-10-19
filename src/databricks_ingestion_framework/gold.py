"""Gold job: daily sales by product category, completed orders only (plain SQL)."""
from .common import run_ddl, setup


def main():
    spark, cfg, log, ddl_dir = setup("gold")
    catalog, schema = cfg["catalog"], cfg["schema"]

    fact = f"{catalog}.{cfg['source_schema']}.{cfg['source_tables']['fact_order_items']}"
    product = f"{catalog}.{cfg['source_schema']}.{cfg['source_tables']['dim_product']}"
    target = f"{catalog}.{schema}.{cfg['target_table']}"
    insert = "INSERT OVERWRITE" if cfg["write_mode"] == "overwrite" else "INSERT INTO"

    # 1. Create the table.
    run_ddl(spark, ddl_dir, cfg["ddl_file"], catalog, schema)

    # 2. Aggregate.
    spark.sql(f"""
        {insert} {target}
        SELECT f.order_date,
               p.category,
               COUNT(DISTINCT f.order_id)                AS total_orders,
               SUM(f.quantity)                           AS units_sold,
               CAST(SUM(f.line_total) AS DECIMAL(14,2))  AS revenue
        FROM {fact} f
        JOIN {product} p ON f.product_id = p.product_id
        WHERE f.status = '{cfg['order_status_filter']}'
        GROUP BY f.order_date, p.category
    """)

    log.info("%s now has %s rows", target, spark.table(target).count())


if __name__ == "__main__":
    main()
