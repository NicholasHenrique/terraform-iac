resource "aws_s3_object" "spark_code" {
  bucket = aws_s3_bucket.datalake.id
  key    = "enem/emr-codes/pyspark/job_spark.py" # nome do arquivo inserido
  acl    = "private"
  source = "../etl/job_spark.py"
  etag   = filemd5("../etl/job_spark.py") # impede do arquivo ser inserido novamente sem ter nenhuma modificacao
}

# impossivel de usar essa parte no github, pois o github tem limite de 100MB por arquivo, tem que subir esse arquivo via aws-cli ou criar 
# um lambda/glue/spark-submit(emr) para baixar o arquivo de dentro da aws
# resource "aws_s3_object" "microdados_enem_2020" {
#   bucket = aws_s3_bucket.datalake.id
#   key    = "enem/raw/MICRODADOS_ENEM_2020.csv" # nome do arquivo inserido
#   acl    = "private"
#   source = "../data/MICRODADOS_ENEM_2020.csv"
#   etag   = filemd5("../data/MICRODADOS_ENEM_2020.csv") # impede do arquivo ser inserido novamente sem ter nenhuma modificacao
# }