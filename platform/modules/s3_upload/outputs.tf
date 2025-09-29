output "bucket_name" {
  description = "The name of the raw data S3 bucket"
  value       = aws_s3_bucket.raw_data.bucket
}

output "bucket_arn" {
  description = "The ARN of the raw data S3 bucket"
  value       = aws_s3_bucket.raw_data.arn
}
