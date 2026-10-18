terraform {
  required_version = ">= 1.5"

  required_providers {
    databricks = {
      source  = "databricks/databricks"
      version = "~> 1.50"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    time = {
      source  = "hashicorp/time"
      version = "~> 0.11"
    }
  }
}

provider "aws" {
  region = var.region
}

# Account-level provider (creates the workspace).
# Authenticate one of two ways:
#   1) CLI login:  databricks auth login --host https://accounts.cloud.databricks.com --account-id <ID>
#      (then keep auth_type below)
#   2) Account-level service principal: export DATABRICKS_CLIENT_ID and DATABRICKS_CLIENT_SECRET
#      and remove the auth_type line.
provider "databricks" {
  alias      = "mws"
  host       = "https://accounts.cloud.databricks.com"
  account_id = var.databricks_account_id
  auth_type  = "databricks-cli"
}
