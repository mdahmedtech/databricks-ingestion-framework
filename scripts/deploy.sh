#!/usr/bin/env bash
# Validate, deploy and run the medallion pipeline for one environment.
# Usage:  ./scripts/deploy.sh [dev|uat|prod]     (defaults to dev)
#
# One-time prerequisite (opens a browser, so it is not scripted):
#   databricks auth login --host https://<your-workspace-url>
set -euo pipefail

TARGET="${1:-dev}"

# Always run from the project root, wherever the script is called from.
cd "$(dirname "$0")/.."

echo ">> Validating bundle (target: ${TARGET})"
databricks bundle validate -t "${TARGET}"

echo ">> Deploying bundle (target: ${TARGET})"
databricks bundle deploy -t "${TARGET}"

echo ">> Running job medallion_pipeline (target: ${TARGET})"
databricks bundle run -t "${TARGET}" medallion_pipeline


rm -rf /Users/ahmed/m2/git/databricks-ingestion-framework/src/*.egg-info build