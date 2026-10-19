"""Common job scaffolding.

Every job (bronze, silver, gold) follows the same contract:
    run(spark, cfg, ddl_dir, log)  -> does the work
    main()                         -> run_job("<job name>", run)
so argument parsing, config loading, logging and error handling live in one place.
"""
import argparse
from typing import Callable, Optional, Sequence

from .config import load_config
from .logging_utils import get_logger
from .spark_utils import get_spark


def parse_args(argv: Optional[Sequence[str]] = None) -> argparse.Namespace:
    parser = argparse.ArgumentParser()
    parser.add_argument("--env", required=True, help="dev | uat | prod")
    parser.add_argument("--config_dir", required=True, help="Folder containing medallion.yml and <env>/<job>.yml")
    parser.add_argument("--ddl_dir", required=True, help="Folder containing the DDL .sql files")
    return parser.parse_args(argv)


def run_job(job_name: str, run: Callable, argv: Optional[Sequence[str]] = None) -> None:
    args = parse_args(argv)
    cfg = load_config(args.config_dir, args.env, job_name)
    log_cfg = cfg.get("logging", {})
    log = get_logger(job_name, log_cfg.get("level", "INFO"), log_cfg.get("format", "%(message)s"))

    log.info("Starting job=%s env=%s", job_name, args.env)
    spark = get_spark()
    try:
        run(spark, cfg, args.ddl_dir, log)
    except Exception:
        log.exception("Job %s failed", job_name)
        raise
    log.info("Job %s finished", job_name)
