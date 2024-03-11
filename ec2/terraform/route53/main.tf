resource "aws_route53_zone" "Route53_Zone" {
  name = var.domain_name
}

resource "aws_route53_record" "dev-ns" {
  zone_id = aws_route53_zone.Route53_Zone.zone_id
  name    = var.domain_name
  type    = "A"
  ttl     = "300"
  records = [var.public_ip]
}