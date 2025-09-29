variable "bucket_name" {
  description = "Name of the S3 bucket for raw data"
  type        = string
}

variable "data_path" {
  description = "Path to the data folder containing JSON files"
  type        = string
  default     = "../data"
}
