variable "job_name" {
  description = "Name of the Glue Job"
  type        = string
  default     = "ecommerce_transform_job"
}

variable "glue_role_arn" {
  description = "ARN of the IAM role for AWS Glue"
  type        = string
}

variable "raw_bucket_name" {
  description = "Name of the raw data S3 bucket for script and temp"
  type        = string
}

variable "max_retries" {
  description = "Maximum number of retries for the Glue Job"
  type        = number
  default     = 0
}

variable "timeout" {
  description = "Timeout in minutes for the Glue Job"
  type        = number
  default     = 15
}

variable "glue_version" {
  description = "Version of Glue to use"
  type        = string
  default     = "4.0"
}

variable "worker_type" {
  description = "Type of worker for the Glue Job"
  type        = string
  default     = "G.1X"
}

variable "number_of_workers" {
  description = "Number of workers for the Glue Job"
  type        = number
  default     = 4
}
