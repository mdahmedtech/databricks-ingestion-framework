
# Job ID: Identifies the configured job, such as daily_orders_pipeline. It stays the same across multiple executions.
# Use it when: checking job configuration, schedule, tasks, or settings.

# Job Run ID: Identifies one time the job was executed. Each new execution gets a different run ID.
# Use it when: checking whether the overall run succeeded, failed, or is still running.

# Task Run ID: Identifies one task execution inside a multi-task job. Each task execution has its own run ID.
# Use it when: retrieving output for a specific task, such as a failed PySpark task.

## Troubleshooting Workflow
#1. Use the **Job ID** to list the job's executions.
#2. Use the **Job Run ID** to inspect the overall run and identify the failed task.
#3. Use the **Task Run ID** to retrieve the failed task's output.

# Remember: `get-run` uses the Job Run ID; `get-run-output` uses the Task Run ID.

# list of jobs
databricks jobs list --limit 20

# For all jobs and their recent runs, use:
databricks jobs list-runs --limit 20

# For only active runs:
databricks jobs list-runs --active-only  --limit 20


# 1. List runs for a specific job
databricks jobs list-runs --job-id <JOB_ID> # databricks jobs list-runs --job-id 445375499857587

# 2. Get overall job run details and identify failed tasks
databricks jobs get-run <JOB_RUN_ID> # databricks jobs get-run 908321664354562

# 3. Get output for a specific task run
databricks jobs get-run-output <TASK_RUN_ID> # databricks jobs get-run-output 284441034544055