output "data" {
  value = {
    cloudfront_domain_name = aws_cloudfront_distribution.Cloudfront_Distribution.domain_name
    zone_id = aws_cloudfront_distribution.Cloudfront_Distribution.hosted_zone_id
  }
}