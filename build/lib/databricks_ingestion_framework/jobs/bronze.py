"""Bronze job: load raw order JSON files from the landing folder into the bronze table, as received."""
from pyspark.sql import functions as F
from pyspark.sql.types import StructType

from ..base import run_job
from ..spark_utils import ensure_schema, fq_name, run_ddl

LINEAGE_COLUMNS = ("source_file", "ingested_at")


def run(spark, cfg, ddl_dir, log):
    catalog, schema, table = cfg["catalog"], cfg["schema"], cfg["target_table"]
    target = fq_name(catalog, schema, table)

    # 1. Make sure the schema and table exist (the DDL file is the single source of truth for the structure).
    ensure_schema(spark, catalog, schema)
    run_ddl(spark, ddl_dir, cfg["ddl_file"], catalog, schema)

    # 2. Read the files with the structure the DDL declares, minus the lineage columns we add ourselves.
    #    An explicit schema keeps nested field order identical to the table, which JSON inference would not.
    table_fields = spark.table(target).schema.fields
    source_schema = StructType([f for f in table_fields if f.name not in LINEAGE_COLUMNS])

    log.info("Reading %s files from %s", cfg["file_format"], cfg["source_path"])
    df = (
        spark.read.format(cfg["file_format"])
        .option("multiLine", cfg["multi_line"])
        .schema(source_schema)
        .load(cfg["source_path"])
        .withColumn("source_file", F.col("_metadata.file_path"))
        .withColumn("ingested_at", F.current_timestamp())
        .select([f.name for f in table_fields])
    )

    # 3. Write.
    df.write.format(cfg.get("write", {}).get("format", "delta")).mode(cfg["write_mode"]).saveAsTable(target)
    log.info("Wrote %s rows to %s (mode=%s)", spark.table(target).count(), target, cfg["write_mode"])


def main():
    run_job("bronze", run)


if __name__ == "__main__":
    main()
