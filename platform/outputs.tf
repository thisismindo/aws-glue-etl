output "raw_bucket_name" {
  description = "Name of the raw data AWS S3 bucket"
  value       = module.s3_upload.bucket_name
}

output "transformed_bucket_name" {
  description = "Name of the transformed data AWS S3 bucket"
  value       = module.s3_transformed.bucket_name
}

output "glue_role_arn" {
  description = "ARN of the AWS Glue IAM role"
  value       = module.glue_role.glue_role_arn
}

output "glue_database_name" {
  description = "Name of the AWS Glue Catalog Database"
  value       = module.glue_crawler.database_name
}

output "glue_crawler_name" {
  description = "Name of the AWS Glue Crawler"
  value       = module.glue_crawler.crawler_name
}

output "glue_job_name" {
  description = "Name of the AWS Glue Job"
  value       = module.glue_job.job_name
}
