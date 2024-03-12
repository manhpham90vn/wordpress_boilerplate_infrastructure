output "data" {
  value = {
    s3_bucket_name = aws_s3_bucket.S3.bucket
    s3_arn = aws_s3_bucket.S3.arn
    bucket_regional_domain_name = aws_s3_bucket.S3.bucket_regional_domain_name
  }
}