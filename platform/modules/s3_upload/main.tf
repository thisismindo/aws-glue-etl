resource "aws_s3_bucket" "raw_data" {
  bucket = var.bucket_name

  provisioner "local-exec" {
    when    = destroy
    command = <<EOT
      aws s3api list-object-versions --bucket ${self.bucket} --query 'Versions[].[Key,VersionId]' --output text > versions.txt 2>/dev/null || true
      [ -s versions.txt ] && while read -r key version; do
        if [ -n "$key" ] && [ -n "$version" ]; then
          aws s3api delete-object --bucket ${self.bucket} --key "$key" --version-id "$version" || true
        fi
      done < versions.txt
      rm -f versions.txt

      aws s3api list-object-versions --bucket ${self.bucket} --query 'DeleteMarkers[].[Key,VersionId]' --output text > deletemarkers.txt 2>/dev/null || true
      [ -s deletemarkers.txt ] && while read -r key version; do
        if [ -n "$key" ] && [ -n "$version" ]; then
          aws s3api delete-object --bucket ${self.bucket} --key "$key" --version-id "$version" || true
        fi
      done < deletemarkers.txt
      rm -f deletemarkers.txt

      aws s3 rm s3://${self.bucket} --recursive || true
    EOT
  }
}

resource "aws_s3_bucket_ownership_controls" "raw_data_ownership" {
  bucket = aws_s3_bucket.raw_data.id
  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

resource "aws_s3_bucket_versioning" "raw_data_versioning" {
  bucket = aws_s3_bucket.raw_data.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_object" "json_upload" {
  for_each = fileset(var.data_path, "*.json")

  bucket = aws_s3_bucket.raw_data.id
  key    = each.value
  source = "${var.data_path}/${each.value}"
  etag   = filemd5("${var.data_path}/${each.value}")
}

resource "aws_s3_bucket_lifecycle_configuration" "raw_data_lifecycle" {
  bucket = aws_s3_bucket.raw_data.id

  rule {
    id     = "expire_all_objects"
    status = "Enabled"

    filter {}

    expiration {
      days = 1
    }

    noncurrent_version_expiration {
      noncurrent_days = 1
    }
  }
}
