resource "aws_cloudfront_origin_access_identity" "Coudfront_Origin_Access_Identity" {
  comment = "S3-${var.s3_bucket}"
}

resource "aws_cloudfront_origin_access_control" "Origin_Access_Control" {
  name                              = "S3-${var.origin_domain_name}"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

resource "aws_cloudfront_distribution" "Cloudfront_Distribution" {
  origin {
    domain_name              = var.origin_domain_name
    origin_id                = var.s3_bucket

    s3_origin_config {
      origin_access_identity = var.cloudfront_access_identity_path
    }
  }

  enabled = true
  is_ipv6_enabled = true
  aliases = [ var.cdn_domain_name ]

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = var.s3_bucket
    viewer_protocol_policy = "redirect-to-https"
    
    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }
  }

  viewer_certificate {
    acm_certificate_arn = var.acm_certificate_arn
    ssl_support_method  = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021"
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }
}
