resource "aws_s3_bucket" "S3" {
  bucket = var.bucket_name
}

resource "aws_s3_bucket_acl" "S3_ACL" {
  bucket = aws_s3_bucket.S3.id
  acl    = "public-read"
}

resource "aws_s3_bucket_policy" "S3_Policy" {
  bucket = aws_s3_bucket.S3.id
  policy = var.aws_iam_policy_document
}

resource "aws_s3_bucket_cors_configuration" "S3_CORS_Configuration" {
  bucket = aws_s3_bucket.S3.id  

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["GET", "HEAD"]
    allowed_origins = ["*"]
    expose_headers  = ["ETag"]
    max_age_seconds = 3000
  }  
}

resource "aws_s3_bucket_ownership_controls" "S3_Ownership_Controls" {
  bucket = aws_s3_bucket.S3.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
  depends_on = [aws_s3_bucket_public_access_block.S3_Public_Access_Block]
}

resource "aws_s3_bucket_public_access_block" "S3_Public_Access_Block" {
  bucket                  = aws_s3_bucket.S3.id
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}
