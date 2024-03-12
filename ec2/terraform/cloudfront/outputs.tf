output "data" {
  value = {
    origin_access_identity_arn = aws_cloudfront_origin_access_identity.Coudfront_Origin_Access_Identity.iam_arn
  }
}