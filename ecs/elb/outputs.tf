output "data" {
  value = {
    load_balancer_dns_name = aws_lb.Load_Balancer.dns_name
    zone_id = aws_lb.Load_Balancer.zone_id
    auto_scaling_group_arn = aws_autoscaling_group.Auto_Scaling_Group.arn
    target_group_arn = aws_lb_target_group.Load_Balancer_Target_Group.arn
    aim_role = aws_iam_role.Iam_Role.arn
  }
}