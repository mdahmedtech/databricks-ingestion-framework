terraform {
  backend "s3" {
    bucket       = "databricks-ingestion-customers-backup-prod"
    key          = "backup/terraform.tfstate"
    region       = "us-east-1"
    use_lockfile = true   # state locking, needs Terraform 1.10+
  }
}