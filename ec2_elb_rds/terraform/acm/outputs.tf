output "data" {
  value = {
    arn = aws_acm_certificate.Certificate_Manager.arn
    arn_us = aws_acm_certificate.Certificate_Manager_US.arn
  }
}