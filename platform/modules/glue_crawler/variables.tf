variable "database_name" {
  description = "Name of the Glue Catalog Database"
  type        = string
  default     = "ecommerce_database"
}

variable "crawler_name" {
  description = "Name of the Glue Crawler"
  type        = string
  default     = "raw_data_crawler"
}

variable "glue_role_arn" {
  description = "ARN of the IAM role for Glue Crawler"
  type        = string
}

variable "raw_bucket_name" {
  description = "Name of the raw data S3 bucket"
  type        = string
}
