"""Bronze job: load the raw JSON files from S3 into the bronze table, exactly as received."""
from pyspark.sql import functions as F
from pyspark.sql.types import StructType

from .common import run_ddl, setup

LINEAGE_COLUMNS = ("source_file", "ingested_at")


def main():
    spark, cfg, log, ddl_dir = setup("bronze")
    catalog, schema = cfg["catalog"], cfg["schema"]
    target = f"{catalog}.{schema}.{cfg['target_table']}"

    # 1. Create the schema and the table (structure comes from the DDL file).
    run_ddl(spark, ddl_dir, cfg["ddl_file"], catalog, schema)

    # 2. Read the raw files. We reuse the table's structure as the file schema, minus the two
    #    columns we add ourselves, so nested fields line up with the table.
    table_fields = spark.table(target).schema.fields
    file_schema = StructType([f for f in table_fields if f.name not in LINEAGE_COLUMNS])

    log.info("Reading files from %s", cfg["source_path"])
    df = (
        spark.read.format(cfg["file_format"])
        .option("multiLine", cfg["multi_line"])
        .schema(file_schema)
        .load(cfg["source_path"])
        .withColumn("source_file", F.col("_metadata.file_path"))
        .withColumn("ingested_at", F.current_timestamp())
    )

    # 3. Write to the bronze table.
    df.write.mode(cfg["write_mode"]).saveAsTable(target)
    log.info("Bronze table %s now has %s rows", target, spark.table(target).count())


if __name__ == "__main__":
    main()
