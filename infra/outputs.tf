output "workspace_url" {
  description = "Put this in the host: field of each target in databricks.yml."
  value       = databricks_mws_workspaces.this.workspace_url
}

output "workspace_id" {
  value = databricks_mws_workspaces.this.workspace_id
}

output "root_bucket" {
  value = aws_s3_bucket.root.bucket
}
