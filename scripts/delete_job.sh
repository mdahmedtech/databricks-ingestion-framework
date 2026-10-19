cd /Users/ahmed/m2/git/databricks-ingestion-framework
databricks bundle destroy -t dev

databricks jobs list                      # find the job ID
databricks jobs delete <job_id>