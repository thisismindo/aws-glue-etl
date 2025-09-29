import sys
import json
import boto3
from awsglue.context import GlueContext
from awsglue.job import Job
from awsglue.utils import getResolvedOptions
from pyspark.context import SparkContext
from pyspark.sql.functions import col, explode, struct, collect_list


s3_bucket = 'transformed-data-597631'
args = getResolvedOptions(sys.argv, ['JOB_NAME'])
sc = SparkContext()
glueContext = GlueContext(sc)
spark = glueContext.spark_session
job = Job(glueContext)
job.init(args['JOB_NAME'], args)

raw_df = glueContext.create_dynamic_frame.from_catalog(database="ecommerce_database", table_name="raw_records_json").toDF()

users_df = raw_df.select(explode(col("users")).alias("user")).select(
    col("user.record_id").alias("record_id"),
    col("user.user_id").alias("users_user_id"),
    col("user.first_name").alias("first_name"),
    col("user.last_name").alias("last_name"),
    col("user.email").alias("email")
)
orders_df = raw_df.select(explode(col("orders")).alias("order")).select(
    col("order.order_record_id").alias("order_record_id"),
    col("order.order_id").alias("order_id"),
    col("order.user_id").alias("orders_user_id"),
    col("order.transaction_date").alias("transaction_date"),
    col("order.transaction_amount").alias("transaction_amount"),
    col("order.currency").alias("currency"),
    col("order.product_category").alias("product_category"),
    col("order.transaction_type").alias("transaction_type"),
    col("order.payment_method").alias("payment_method"),
    col("order.items_count").alias("items_count")
)
locations_df = raw_df.select(explode(col("locations")).alias("location")).select(
    col("location.user_id").alias("locations_user_id"),
    col("location.location_id").alias("location_id"),
    col("location.country").alias("country"),
    col("location.city").alias("city"),
    col("location.latitude").alias("latitude"),
    col("location.longitude").alias("longitude"),
    col("location.timezone").alias("timezone")
)

user_location_df = users_df.join(locations_df, users_df.users_user_id == locations_df.locations_user_id, "inner")
result_df = user_location_df.join(orders_df, user_location_df.users_user_id == orders_df.orders_user_id, "left") \
    .groupBy(user_location_df.users_user_id, user_location_df.record_id, user_location_df.first_name,
             user_location_df.last_name, user_location_df.email, locations_df.location_id,
             locations_df.country, locations_df.city, locations_df.latitude,
             locations_df.longitude, locations_df.timezone) \
    .agg(collect_list(struct(
        col("order_id"),
        col("order_record_id"),
        col("transaction_date"),
        col("transaction_amount"),
        col("currency"),
        col("product_category"),
        col("transaction_type"),
        col("payment_method"),
        col("items_count")
    )).alias("order_details"))

intermediate_df = result_df.select(
    col("record_id"),
    col("users_user_id").alias("user_id"),
    col("first_name"),
    col("last_name"),
    col("email"),
    struct(
        col("location_id").alias("location_id"),
        col("country").alias("country"),
        col("city").alias("city"),
        col("latitude").alias("latitude"),
        col("longitude").alias("longitude"),
        col("timezone").alias("timezone")
    ).alias("location"),
    col("order_details")
)

json_rows = intermediate_df.toJSON().collect()
data = [json.loads(row) for row in json_rows]

json_array = json.dumps(data)
timestamp = spark.sql("SELECT current_timestamp()").collect()[0][0].strftime("%Y%m%d%H%M%S")
output_path = f"s3://{s3_bucket}/transformed_records-{timestamp}.json"
s3 = boto3.client('s3')
s3.put_object(Bucket=s3_bucket, Key=f'transformed_records-{timestamp}.json', Body=json_array)

job.commit()
