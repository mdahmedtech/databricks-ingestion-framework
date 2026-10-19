

databricks jobs list-runs --job-id <JOB_ID>               List recent runs for a job
databricks jobs get-run <RUN_ID>                          Inspect run status and task details
databricks jobs get-run-output <RUN_ID>                   Get notebook task output and errors
databricks jobs cancel-run <RUN_ID>                       Cancel a running job
databricks clusters list                                  Check cluster states
databricks clusters get <CLUSTER_ID>                     Inspect cluster configuration


# get logs locally
databricks jobs get-run-output <RUN_ID>  # sample databricks jobs get-run-output 445375499857587

# get logs local
databricks jobs get-run-output 412130722289413 > logs.json    # sample databricks jobs get-run-output 412130722289413 > logs.json