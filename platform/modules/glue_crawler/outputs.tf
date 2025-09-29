output "database_name" {
  description = "Name of the Glue Catalog Database"
  value       = aws_glue_catalog_database.glue_database.name
}

output "crawler_name" {
  description = "Name of the Glue Crawler"
  value       = aws_glue_crawler.raw_data_crawler.name
}
