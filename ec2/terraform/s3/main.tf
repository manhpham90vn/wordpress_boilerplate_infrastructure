resource "aws_s3_bucket" "S3" {
  bucket = var.bucket_name
}

resource "aws_s3_bucket_acl" "S3_ACL" {
  bucket = aws_s3_bucket.S3.id
  acl    = "public-read"
}

resource "aws_s3_bucket_ownership_controls" "S3_Ownership_Controls" {
  bucket = aws_s3_bucket.S3.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}