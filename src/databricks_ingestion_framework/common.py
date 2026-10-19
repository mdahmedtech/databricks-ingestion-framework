"""Shared helpers used by the bronze, silver and gold jobs.

The config files (conf/) and DDL files (ddl/) live inside this package, so they are shipped
in the wheel together with the code. Both folders can be overridden on the command line.
"""
import argparse
import logging
import sys
from importlib import resources
from pathlib import Path

import yaml

PACKAGE = "databricks_ingestion_framework"


def package_path(folder):
    """Path of a folder (conf or ddl) inside the installed package."""
    return str(resources.files(PACKAGE).joinpath(folder))


def load_config(config_dir, env, job):
    """Read medallion.yml (shared) and <env>/<job>.yml (job specific); the job file wins."""
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
    parser.add_argument("--env", required=True)  # dev | uat | prod
    parser.add_argument("--config_dir", default=package_path("conf"))  # optional override
    parser.add_argument("--ddl_dir", default=package_path("ddl"))  # optional override
    args = parser.parse_args()

    cfg = load_config(args.config_dir, args.env, job_name)

    logging.basicConfig(
        stream=sys.stdout,
        level=cfg["logging"]["level"],
        format=cfg["logging"]["format"],
    )
    log = logging.getLogger(job_name)
    log.info("Starting job=%s env=%s config_dir=%s", job_name, args.env, args.config_dir)

    from pyspark.sql import SparkSession  # imported here so the helpers load without Spark installed

    spark = SparkSession.builder.getOrCreate()
    return spark, cfg, log, args.ddl_dir


def run_ddl(spark, ddl_dir, filename, catalog, schema):
    """Create the schema if needed, then run one DDL file ({catalog} and {schema} are filled in)."""
    spark.sql(f"CREATE SCHEMA IF NOT EXISTS {catalog}.{schema}")
    sql = (Path(ddl_dir) / filename).read_text().format(catalog=catalog, schema=schema, env=catalog.split("_")[0])
    spark.sql(sql.strip().rstrip(";"))
