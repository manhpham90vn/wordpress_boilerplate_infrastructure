output "data" {
  value = {
    name_servers = aws_route53_zone.Route53_Zone.name_servers
  }
}