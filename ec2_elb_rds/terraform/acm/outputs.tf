output "data" {
  value = {
    arn = aws_acm_certificate.Certificate_Manager.arn
  }
}