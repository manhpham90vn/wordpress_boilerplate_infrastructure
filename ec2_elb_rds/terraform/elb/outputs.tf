output "data" {
  value = {
    load_balancer_dns_name = aws_lb.Load_Balancer.dns_name
    zone_id = aws_lb.Load_Balancer.zone_id
  }
}