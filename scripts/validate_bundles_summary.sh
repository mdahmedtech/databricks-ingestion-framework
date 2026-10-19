cd /Users/ahmed/m2/git/databricks-ingestion-framework
databricks bundle validate -t dev
databricks bundle validate -t prod
databricks bundle summary -t dev
databricks bundle summary -t prod