output "data" {
  value = {
    s3_bucket_name = aws_s3_bucket.S3.bucket
    bucket_regional_domain_name = aws_s3_bucket.S3.bucket_regional_domain_name
    cloudfront_access_identity_path = aws_cloudfront_origin_access_identity.Coudfront_Origin_Access_Identity.cloudfront_access_identity_path
  }
}