resource "aws_s3_object" "spark_code" {
  bucket = aws_s3_bucket.datalake.id
  key    = "emr-code/pyspark/job_spark_from_tf.py" # nome do arquivo inserido
  acl    = "private"
  source = "../job_spark.py"
  etag   = filemd5("../job_spark.py") # impede do arquivo ser inserido novamente sem ter nenhuma modificacao
}