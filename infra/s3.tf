resource "aws_s3_bucket" "datalake" {
  bucket = "${var.base_bucket_name}-${var.environment}-${var.account_number}"
}

resource "aws_s3_bucket_ownership_controls" "datalake_ownership" {
  bucket = aws_s3_bucket.datalake.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "datalake_acl" {
  depends_on = [aws_s3_bucket_ownership_controls.datalake_ownership]
  bucket     = aws_s3_bucket.datalake.id
  acl        = "private"
}

resource "aws_s3_bucket_server_side_encryption_configuration" "datalake_encryption" {
  bucket = aws_s3_bucket.datalake.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256" #SSE-S3
    }
  }
}