"""Shared helpers used by the bronze, silver and gold jobs."""
import argparse
import logging
import sys
from pathlib import Path

import yaml


def load_config(config_dir, env, job):
    """Read config/medallion.yml (shared) and config/<env>/<job>.yml (job specific); job file wins."""
    root = Path(config_dir)
    with open(root / "medallion.yml") as f:
        shared = yaml.safe_load(f) or {}
    with open(root / env / f"{job}.yml") as f:
        specific = yaml.safe_load(f) or {}
    return {**shared, **specific}


def setup(job_name):
    """Parse arguments, load config, create the logger and the Spark session.

    Returns: spark, cfg, log, ddl_dir
    """
    parser = argparse.ArgumentParser()
    parser.add_argument("--env", required=True)         # dev | uat | prod
    parser.add_argument("--config_dir", required=True)  # folder with the config files
    parser.add_argument("--ddl_dir", required=True)     # folder with the DDL files
    args = parser.parse_args()

    cfg = load_config(args.config_dir, args.env, job_name)

    logging.basicConfig(
        stream=sys.stdout,
        level=cfg["logging"]["level"],
        format=cfg["logging"]["format"],
    )
    log = logging.getLogger(job_name)
    log.info("Starting job=%s env=%s", job_name, args.env)

    from pyspark.sql import SparkSession  # imported here so the helpers load without Spark installed

    spark = SparkSession.builder.getOrCreate()
    return spark, cfg, log, args.ddl_dir


def run_ddl(spark, ddl_dir, filename, catalog, schema):
    """Create the schema if needed, then run one DDL file ({catalog} and {schema} are filled in)."""
    spark.sql(f"CREATE SCHEMA IF NOT EXISTS {catalog}.{schema}")
    sql = (Path(ddl_dir) / filename).read_text().format(catalog=catalog, schema=schema)
    spark.sql(sql.strip().rstrip(";"))
