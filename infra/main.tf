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

resource "aws_s3_object" "spark_code" {
  bucket = aws_s3_bucket.datalake.id
  key    = "emr-code/pyspark/job_spark_from_tf.py" # nome do arquivo inserido
  acl    = "private"
  source = "../job_spark.py"
  etag   = filemd5("../job_spark.py") # impede do arquivo ser inserido novamente sem ter nenhuma modificacao
}

provider "aws" {
  region = var.region
}