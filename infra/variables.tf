variable "databricks_account_id" {
  type        = string
  description = "Databricks account ID (account console, top-right menu)."
}

variable "region" {
  type        = string
  default     = "us-east-1"
  description = "AWS region. Keep it the same as your S3 data buckets."
}

variable "prefix" {
  type        = string
  default     = "ingestion-demo"
  description = "Prefix for AWS resource names. Must be lowercase."
}

variable "workspace_name" {
  type        = string
  default     = "ingestion-demo"
  description = "Display name of the Databricks workspace."
}

variable "metastore_id" {
  type        = string
  default     = ""
  description = "Existing Unity Catalog metastore ID to attach. Leave empty to skip assignment."
}
