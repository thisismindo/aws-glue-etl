resource "aws_glue_catalog_database" "glue_database" {
  name = var.database_name
}

resource "aws_glue_crawler" "raw_data_crawler" {
  database_name = aws_glue_catalog_database.glue_database.name
  name          = var.crawler_name
  role          = var.glue_role_arn

  s3_target {
    path = "s3://${var.raw_bucket_name}/"
  }

  configuration = jsonencode({
    Version = 1.0
    CrawlerOutput = {
      Partitions = {
        AddOrUpdateBehavior = "InheritFromTable"
      }
      Tables = {
        AddOrUpdateBehavior = "MergeNewColumns"
      }
    }
  })
}
