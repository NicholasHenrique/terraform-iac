from pyspark.sql import SparkSession

spark = SparkSession.builder \
    .appName("CSV to Parquet Conversion") \
    .getOrCreate()

enem = (
    spark
    .read
    .format("csv")
    .option("header", True)
    .option("inferSchema", True)
    .option("delimiter", ";")
    .load("s3://datalake-prod-tf-nicholas-henrique-de/enem/raw/")
)

(
    enem
    .write
    .mode("overwrite")
    .format("parquet")
    .partitionBy("year")
    .save("s3://datalake-prod-tf-nicholas-henrique-de/enem/staging/")
)