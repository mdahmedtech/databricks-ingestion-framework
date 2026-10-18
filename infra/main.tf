data "aws_caller_identity" "current" {}

# ---------------------------------------------------------------
# Cross-account IAM role that lets Databricks launch compute
# ---------------------------------------------------------------
data "databricks_aws_assume_role_policy" "this" {
  external_id = var.databricks_account_id
}

resource "aws_iam_role" "cross_account" {
  name               = "${var.prefix}-cross-account-role"
  assume_role_policy = data.databricks_aws_assume_role_policy.this.json
}

data "databricks_aws_crossaccount_policy" "this" {}

resource "aws_iam_role_policy" "cross_account" {
  name   = "${var.prefix}-cross-account-policy"
  role   = aws_iam_role.cross_account.id
  policy = data.databricks_aws_crossaccount_policy.this.json
}

# IAM is eventually consistent; give it time before Databricks validates the role.
resource "time_sleep" "iam_propagation" {
  depends_on      = [aws_iam_role_policy.cross_account]
  create_duration = "30s"
}

resource "databricks_mws_credentials" "this" {
  provider         = databricks.mws
  account_id       = var.databricks_account_id
  credentials_name = "${var.prefix}-credentials"
  role_arn         = aws_iam_role.cross_account.arn
  depends_on       = [time_sleep.iam_propagation]
}

# ---------------------------------------------------------------
# Workspace root storage bucket (DBFS root / workspace system data)
# ---------------------------------------------------------------
resource "aws_s3_bucket" "root" {
  # Bucket names are global; the account ID keeps this one unique.
  bucket        = "${var.prefix}-root-${data.aws_caller_identity.current.account_id}"
  force_destroy = true
}

resource "aws_s3_bucket_public_access_block" "root" {
  bucket                  = aws_s3_bucket.root.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_versioning" "root" {
  bucket = aws_s3_bucket.root.id
  versioning_configuration {
    status = "Disabled"
  }
}

data "databricks_aws_bucket_policy" "this" {
  bucket = aws_s3_bucket.root.bucket
}

resource "aws_s3_bucket_policy" "root" {
  bucket     = aws_s3_bucket.root.id
  policy     = data.databricks_aws_bucket_policy.this.json
  depends_on = [aws_s3_bucket_public_access_block.root]
}

resource "databricks_mws_storage_configurations" "this" {
  provider                   = databricks.mws
  account_id                 = var.databricks_account_id
  storage_configuration_name = "${var.prefix}-storage"
  bucket_name                = aws_s3_bucket.root.bucket
  depends_on                 = [aws_s3_bucket_policy.root]
}

# ---------------------------------------------------------------
# Workspace (Databricks-managed VPC)
# ---------------------------------------------------------------
resource "databricks_mws_workspaces" "this" {
  provider                 = databricks.mws
  account_id               = var.databricks_account_id
  aws_region               = var.region
  workspace_name           = var.workspace_name
  credentials_id           = databricks_mws_credentials.this.credentials_id
  storage_configuration_id = databricks_mws_storage_configurations.this.storage_configuration_id
}

# ---------------------------------------------------------------
# Attach the existing Unity Catalog metastore (optional)
# ---------------------------------------------------------------
resource "databricks_metastore_assignment" "this" {
  count        = var.metastore_id == "" ? 0 : 1
  provider     = databricks.mws
  workspace_id = databricks_mws_workspaces.this.workspace_id
  metastore_id = var.metastore_id
}
