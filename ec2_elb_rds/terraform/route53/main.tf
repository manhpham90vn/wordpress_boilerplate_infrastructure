resource "aws_route53_zone" "Route53_Zone" {
  name = var.domain_name
}

resource "aws_route53_record" "Route53_Record_1" {
  zone_id = aws_route53_zone.Route53_Zone.zone_id
  name    = var.cdn_domain_name
  type    = "A"
  alias {
    name = var.cloudfront_domain_name
    zone_id = var.cloudfront_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "Route53_Record_2" {
  zone_id = aws_route53_zone.Route53_Zone.zone_id
  name    = var.domain_name
  type    = "A"
  alias {
    name = var.load_balancer_domain_name
    zone_id = var.load_balancer_zone_id
    evaluate_target_health = false
  }
}