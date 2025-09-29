output "bucket_name" {
  description = "The name of the transformed data S3 bucket"
  value       = aws_s3_bucket.transformed_data.bucket
}

output "bucket_arn" {
  description = "The ARN of the transformed data S3 bucket"
  value       = aws_s3_bucket.transformed_data.arn
}
