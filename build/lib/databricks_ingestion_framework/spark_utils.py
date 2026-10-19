"""Spark helpers shared by all jobs."""
from pathlib import Path

from pyspark.sql import SparkSession


def get_spark() -> SparkSession:
    return SparkSession.builder.getOrCreate()


def fq_name(catalog: str, schema: str, table: str) -> str:
    """Fully qualified, backtick-quoted table name."""
    return f"`{catalog}`.`{schema}`.`{table}`"


def ensure_schema(spark: SparkSession, catalog: str, schema: str) -> None:
    spark.sql(f"CREATE SCHEMA IF NOT EXISTS `{catalog}`.`{schema}`")


def run_ddl(spark: SparkSession, ddl_dir: str, filename: str, catalog: str, schema: str) -> None:
    """Run one DDL file after filling its {catalog} and {schema} placeholders."""
    path = Path(ddl_dir) / filename
    if not path.is_file():
        raise FileNotFoundError(f"DDL file not found: {path}")
    sql = path.read_text().format(catalog=catalog, schema=schema).strip().rstrip(";")
    spark.sql(sql)
