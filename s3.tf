resource "aws_s3_bucket" "storage_bucket" {
  bucket = var.storage_bucket_name

  tags = var.tags
}

resource "aws_s3_bucket_public_access_block" "storage_bucket" {
  bucket = aws_s3_bucket.storage_bucket.id

  ignore_public_acls      = true
  block_public_acls       = true
  block_public_policy     = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_lifecycle_configuration" "storage_bucket" {
  bucket = aws_s3_bucket.storage_bucket.id

  rule {
    id = "s3-err-${aws_s3_bucket.storage_bucket.bucket}"
    filter {}
    abort_incomplete_multipart_upload {
      days_after_initiation = 7
    }
    status = "Enabled"
  }
}
