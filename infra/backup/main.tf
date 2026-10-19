provider "aws" {
  region = "us-east-1"
}

# 1. Backup bucket for prod gold data
resource "aws_s3_bucket" "prod_backup" {
  bucket = "databricks-ingestion-customers-backup-prod"

  tags = {
    env     = "prod"
    purpose = "gold-backup"
  }
}

# 2. Folder inside the bucket (an empty marker object)
resource "aws_s3_object" "folder" {
  bucket = aws_s3_bucket.prod_backup.id
  key    = "daily_sales_by_category/"
}

# 3. Keep old versions if a backup is overwritten
resource "aws_s3_bucket_versioning" "prod_backup" {
  bucket = aws_s3_bucket.prod_backup.id

  versioning_configuration {
    status = "Enabled"
  }
}

# 4. Encrypt everything at rest
resource "aws_s3_bucket_server_side_encryption_configuration" "prod_backup" {
  bucket = aws_s3_bucket.prod_backup.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# 5. Make sure the bucket can never be public
resource "aws_s3_bucket_public_access_block" "prod_backup" {
  bucket                  = aws_s3_bucket.prod_backup.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

output "backup_bucket" {
  value = aws_s3_bucket.prod_backup.bucket
}