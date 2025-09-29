module "s3_transformed" {
  source      = "./modules/s3_transformed"
  bucket_name = local.transformed_bucket_name
}

module "s3_upload" {
  source     = "./modules/s3_upload"
  bucket_name = local.raw_bucket_name
  data_path  = abspath("${path.module}/../data")
}

module "glue_role" {
  source       = "./modules/glue_role"
  role_name    = local.glue_role_name
  policy_name  = local.glue_policy_name
  s3_resources = [
    module.s3_upload.bucket_arn,
    "${module.s3_upload.bucket_arn}/*",
    module.s3_transformed.bucket_arn,
    "${module.s3_transformed.bucket_arn}/*"
  ]
  depends_on = [module.s3_upload, module.s3_transformed]
}

module "glue_crawler" {
  source          = "./modules/glue_crawler"
  database_name   = local.glue_database_name
  crawler_name    = local.glue_crawler_name
  glue_role_arn   = module.glue_role.glue_role_arn
  raw_bucket_name = module.s3_upload.bucket_name
  depends_on      = [module.glue_role, module.s3_upload]
}

module "glue_job" {
  source          = "./modules/glue_job"
  job_name        = local.glue_job_name
  glue_role_arn   = module.glue_role.glue_role_arn
  raw_bucket_name = module.s3_upload.bucket_name
  depends_on      = [module.glue_role, module.s3_upload]
}

resource "aws_glue_trigger" "crawler_trigger" {
  name     = "raw_data_crawler_trigger"
  type     = "ON_DEMAND"
  actions {
    crawler_name = module.glue_crawler.crawler_name
  }
  enabled = true
}

resource "aws_glue_trigger" "job_trigger" {
  name     = "ecommerce_transform_job_trigger"
  type     = "CONDITIONAL"
  predicate {
    conditions {
      logical_operator = "EQUALS"
      crawler_name     = module.glue_crawler.crawler_name
      crawl_state      = "SUCCEEDED"
    }
  }
  actions {
    job_name = module.glue_job.job_name
  }
  enabled = true
  depends_on = [aws_glue_trigger.crawler_trigger]
}
