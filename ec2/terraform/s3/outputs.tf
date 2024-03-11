output "data" {
  value = {
    bucket_regional_domain_name = aws_s3_bucket.S3.bucket_regional_domain_name
  }
}