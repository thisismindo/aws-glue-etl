variable "role_name" {
  description = "Name of the IAM role for AWS Glue"
  type        = string
  default     = "AWSGlueServiceRole"
}

variable "policy_name" {
  description = "Name of the IAM policy for AWS Glue"
  type        = string
  default     = "AWSGlueServicePolicy"
}

variable "s3_resources" {
  description = "List of S3 ARNs for the policy"
  type        = list(string)
}
