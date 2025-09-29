resource "aws_s3_object" "glue_script" {
  bucket = var.raw_bucket_name
  key    = "scripts/transform_script.py"
  source = "${path.module}/transform_script.py"
  etag   = filemd5("${path.module}/transform_script.py")
}

resource "aws_glue_job" "transform_job" {
  name     = var.job_name
  role_arn = var.glue_role_arn

  command {
    script_location = "s3://${var.raw_bucket_name}/scripts/transform_script.py"
    python_version  = "3"
  }

  default_arguments = {
    "--TempDir"             = "s3://${var.raw_bucket_name}/temp/"
    "--job-language"        = "python"
    "--job-bookmark-option" = "job-bookmark-enable"
  }

  max_retries       = var.max_retries
  timeout           = var.timeout
  glue_version      = var.glue_version
  worker_type       = var.worker_type
  number_of_workers = var.number_of_workers
}
