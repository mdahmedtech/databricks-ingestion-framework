
-- 1. Failed SQL queries in the last 24 hours
SELECT start_time, executed_by, error_message, statement_text
FROM system.query.history
WHERE start_time >= CURRENT_TIMESTAMP() - INTERVAL 24 HOURS
  AND execution_status = 'FAILED'
ORDER BY start_time DESC
LIMIT 50;


-- 2. Slowest SQL queries in the last 24 hours
SELECT start_time, executed_by, total_duration_ms, statement_text
FROM system.query.history
WHERE start_time >= CURRENT_TIMESTAMP() - INTERVAL 24 HOURS
ORDER BY total_duration_ms DESC
LIMIT 20;


-- 3. Failed job runs in the last 24 hours
SELECT workspace_id, job_id, run_id, period_start_time,
       result_state, termination_code
FROM system.lakeflow.job_run_timeline
WHERE period_start_time >= CURRENT_TIMESTAMP() - INTERVAL 24 HOURS
  AND result_state = 'FAILED'
ORDER BY period_start_time DESC
LIMIT 50;


-- 4. Job run counts by status in the last 24 hours
SELECT result_state, COUNT(DISTINCT run_id) AS run_count
FROM system.lakeflow.job_run_timeline
WHERE period_start_time >= CURRENT_TIMESTAMP() - INTERVAL 24 HOURS
GROUP BY result_state
ORDER BY run_count DESC;


-- 5. Recent SQL warehouse events
SELECT *
FROM system.compute.warehouse_events
WHERE event_time >= CURRENT_TIMESTAMP() - INTERVAL 24 HOURS
ORDER BY event_time DESC
LIMIT 50;


-- 6. Recent audit events for administrative troubleshooting
SELECT event_time, user_identity.email AS user_email,
       service_name, action_name
FROM system.access.audit
WHERE event_time >= CURRENT_TIMESTAMP() - INTERVAL 24 HOURS
ORDER BY event_time DESC
LIMIT 100;


-- 7. Check current SQL user and context
SELECT current_user() AS current_user,
       current_catalog() AS current_catalog,
       current_schema() AS current_schema,
       current_timezone() AS current_timezone;


-- 8. List available system schemas
SHOW SCHEMAS IN system;


-- 9. List available query monitoring tables
SHOW TABLES IN system.query;


-- 10. List available job monitoring tables
SHOW TABLES IN system.lakeflow;


-- 11. List available compute monitoring tables
SHOW TABLES IN system.compute;


-- 12. List available audit tables
SHOW TABLES IN system.access;