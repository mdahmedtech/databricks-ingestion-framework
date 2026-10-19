databricks.yml (bundle configuration file)

Definition: the root file of a Databricks bundle. It describes the project as a whole: its name, what to build, which other files to include, and which environments it can be deployed to.
Purpose: to answer where and how do we deploy? It builds the wheel through the artifacts section and defines the dev, uat and prod targets, each with its own workspace settings and deployment mode. It also pulls in the resource files through include. The Databricks CLI needs this file in the project root, and without it no bundle command works.

resources/ingestion_job.yml (job resource definition)

Definition: a file that declares one Databricks job as code: its name, compute, tasks, and the order in which tasks run.
Purpose: to answer what do we deploy? It defines the medallion_pipeline job with three tasks (bronze, silver and gold). depends_on sets their order, and each task runs one entry point from the wheel on serverless compute. It uses ${bundle.target} so the same definition works in every environment, giving jobs named medallion_pipeline_dev, _uat and _prod.