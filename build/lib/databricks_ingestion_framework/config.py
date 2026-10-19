"""Configuration loading.

Settings come from two YAML files that are merged:
  1. <config_dir>/medallion.yml          shared defaults for every job and environment
  2. <config_dir>/<env>/<job>.yml        job-specific settings; wins on conflicts
"""
from pathlib import Path

import yaml


def _read(path: Path) -> dict:
    if not path.is_file():
        raise FileNotFoundError(f"Config file not found: {path}")
    with path.open() as f:
        return yaml.safe_load(f) or {}


def deep_merge(base: dict, override: dict) -> dict:
    """Return base updated with override; nested dicts are merged, everything else is replaced."""
    merged = dict(base)
    for key, value in override.items():
        if isinstance(value, dict) and isinstance(merged.get(key), dict):
            merged[key] = deep_merge(merged[key], value)
        else:
            merged[key] = value
    return merged


def load_config(config_dir: str, env: str, job: str) -> dict:
    root = Path(config_dir)
    shared = _read(root / "medallion.yml")
    specific = _read(root / env / f"{job}.yml")
    return deep_merge(shared, specific)
