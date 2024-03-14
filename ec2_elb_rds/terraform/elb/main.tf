locals {
  lb_name = "my-lb"
  target_group_name = "my-tg"
  instance_name = "my-instance"
}

resource "aws_lb" "Load_Balancer" {
  name               = local.lb_name
  internal           = false
  load_balancer_type = "application"
  security_groups    = var.security_groups
  subnets            = var.public_subnets
}

resource "aws_lb_target_group" "Load_Balancer_Target_Group" {
  name     = local.target_group_name
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
}

resource "aws_lb_listener" "Load_Balancer_Listener_HTTP" {
  load_balancer_arn = aws_lb.Load_Balancer.arn
  port              = "80"
  protocol          = "HTTP"
  
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.Load_Balancer_Target_Group.arn
  }
}

resource "aws_lb_listener" "Load_Balancer_Listener_HTTPS" {
  load_balancer_arn = aws_lb.Load_Balancer.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy = "ELBSecurityPolicy-TLS13-1-2-2021-06"
  certificate_arn = var.certificate_arn
  
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.Load_Balancer_Target_Group.arn
  }
}

resource "aws_launch_template" "Launch_Template" {
  image_id      = var.aim_for_autoscaling
  instance_type = var.instance_type

  network_interfaces {
    associate_public_ip_address = false
    security_groups             = var.security_groups
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = local.instance_name
    }
  }
}

resource "aws_autoscaling_group" "Auto_Scaling_Group" {
  desired_capacity = 2
  max_size         = 2
  min_size         = 1

  target_group_arns = [aws_lb_target_group.Load_Balancer_Target_Group.arn]

  vpc_zone_identifier = var.private_subnets

  launch_template {
    id      = aws_launch_template.Launch_Template.id
    version = "$Latest"
  }
}