locals {
  lb_name           = "my-lb"
  target_group_name = "my-tg"
  instance_name     = "my-instance"
}

data "aws_iam_policy_document" "Iam_Policy_Document" {
  statement {
    actions = ["sts:AssumeRole"]
    effect  = "Allow"

    principals {
      type = "Service"
      identifiers = [
        "ec2.amazonaws.com",
        "ecs.amazonaws.com"
      ]
    }
  }
}

resource "aws_iam_role" "Iam_Role" {
  assume_role_policy = data.aws_iam_policy_document.Iam_Policy_Document.json
}

resource "aws_iam_role_policy_attachment" "Iam_Role_Policy_attachment" {
  role       = aws_iam_role.Iam_Role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

resource "aws_iam_instance_profile" "Iam_Instance_Profile" {
  role = aws_iam_role.Iam_Role.id
}

resource "aws_lb" "Load_Balancer" {
  name            = local.lb_name
  internal        = false
  security_groups = var.security_groups
  subnets         = var.public_subnets
}

resource "aws_lb_target_group" "Load_Balancer_Target_Group" {
  name        = local.target_group_name
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
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

resource "aws_launch_template" "Launch_Template" {
  image_id      = var.aim_for_autoscaling
  instance_type = var.instance_type

  iam_instance_profile {
    arn = aws_iam_instance_profile.Iam_Instance_Profile.arn
  }

  network_interfaces {
    associate_public_ip_address = false
    security_groups             = var.security_groups
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

  tag {
    key                 = "AmazonECSManaged"
    value               = true
    propagate_at_launch = true
  }
}
