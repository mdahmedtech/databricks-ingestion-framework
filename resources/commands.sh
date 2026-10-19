####### 1. Jobs and workflow troubleshooting
### Run in a terminal with the Databricks CLI configured. ##########


databricks jobs list                                      Find jobs in the workspace
databricks jobs get <JOB_ID>                              Inspect job configuration and tasks
databricks jobs list-runs --job-id <JOB_ID>               Check recent runs for a job
databricks jobs get-run <RUN_ID>                          Investigate a failed or slow run
databricks jobs get-run-output <RUN_ID>                   Inspect notebook task output


####### 2. SQL warehouses and compute
### Run in a terminal with the Databricks CLI configured. ##########

databricks warehouses list                                Find SQL warehouses and their states
databricks warehouses get <WAREHOUSE_ID>                 Inspect warehouse configuration and state
databricks warehouses get-permissions <WAREHOUSE_ID>     Check warehouse permissions
databricks clusters list                                  Find compute clusters
databricks clusters get <CLUSTER_ID>                     Inspect cluster configuration and state


####### 3. Catalogs, schemas, tables, and permissions
### Run in a terminal with the Databricks CLI configured. ##########

databricks catalogs list                                  List Unity Catalog catalogs
databricks schemas list <CATALOG>                         List schemas in a catalog
databricks tables list <CATALOG> <SCHEMA>                 List tables in a schema
databricks tables get <FULL_TABLE_NAME>                  Inspect table metadata
databricks grants get TABLE <FULL_TABLE_NAME>            Inspect table permissions


Example full table name: dev_catalog.sales.orders

####### 4. Authentication and Asset Bundles
### Run in a terminal with the Databricks CLI configured. ##########

text
databricks auth profiles                                  List configured authentication profiles
databricks bundle validate -t dev                        Validate bundle configuration
databricks bundle plan -t dev                            Preview deployment changes
databricks bundle deploy -t dev                          Deploy resources to dev
databricks bundle run <JOB_KEY> -t dev                   Run a job defined in the bundle


####### 5. SQL commands for daily data checks
### Run in Databricks SQL Editor or a notebook SQL cell. ##########

sql
SHOW CATALOGS;
-- List accessible catalogs

SHOW SCHEMAS IN dev_catalog;
-- List schemas in dev

SHOW TABLES IN dev_catalog.sales;
-- Verify tables exist

DESCRIBE TABLE dev_catalog.sales.orders;
-- Check columns and data types

SELECT MAX(load_timestamp)
FROM dev_catalog.sales.orders;
-- Check the latest data load timestamp


####### 6. Data quality and troubleshooting SQL
### Run in Databricks SQL Editor or a notebook SQL cell. ##########

sql
-- Check total row count
SELECT COUNT(*)
FROM dev_catalog.sales.orders;

-- Find duplicate order IDs
SELECT order_id, COUNT(*) AS row_count
FROM dev_catalog.sales.orders
GROUP BY order_id
HAVING COUNT(*) > 1;

-- Find missing order IDs
SELECT COUNT(*) AS missing_ids
FROM dev_catalog.sales.orders
WHERE order_id IS NULL;

-- Compare production and dev row counts
SELECT 'prod' AS environment, COUNT(*) AS row_count
FROM prod_catalog.sales.orders
UNION ALL
SELECT 'dev' AS environment, COUNT(*) AS row_count
FROM dev_catalog.sales.orders;

-- Inspect recent records
SELECT *
FROM dev_catalog.sales.orders
ORDER BY load_timestamp DESC
LIMIT 10;


####### 7. CLI help and diagnostics
### Run in a terminal with the Databricks CLI configured. ##########

text
databricks -h                                           List CLI commands
databricks jobs -h                                      Get jobs command help
databricks warehouses -h                                Get warehouse command help
databricks bundle -h                                    Get bundle command help
databricks bundle summary -t dev                        Show deployed bundle resources


**Note:** Replace placeholder IDs, catalog names, schemas, tables, and column names with your actual values. Check databricks <command> -h if a command's arguments differ in your installed CLI version.