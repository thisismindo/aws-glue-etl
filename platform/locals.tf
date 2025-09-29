locals {
  raw_bucket_name           = "raw-data-382961"
  transformed_bucket_name   = "transformed-data-597631"
  glue_role_name            = "AWSGlueServiceRole"
  glue_policy_name          = "AWSGlueServicePolicy"
  glue_database_name        = "ecommerce_database"
  glue_crawler_name         = "raw_data_crawler"
  glue_job_name             = "ecommerce_transform_job"
}
