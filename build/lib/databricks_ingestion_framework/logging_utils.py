"""Logging setup. Output goes to stdout, which Databricks captures in the job run's logs."""
import logging
import sys

DEFAULT_FORMAT = "%(asctime)s | %(levelname)s | %(name)s | %(message)s"


def get_logger(name: str, level: str = "INFO", fmt: str = DEFAULT_FORMAT) -> logging.Logger:
    logger = logging.getLogger(name)
    logger.setLevel(level.upper())
    if not logger.handlers:  # avoid duplicate handlers if called twice in one process
        handler = logging.StreamHandler(sys.stdout)
        handler.setFormatter(logging.Formatter(fmt))
        logger.addHandler(handler)
    logger.propagate = False
    return logger
