locals {
  ecs_cluster_name           = "my-ecs-cluster"
  ecs_capacity_provider_name = "my-ecs-capacity-provider"
  ecs_task_definition_name   = "my-ecs-task-definition"
  ecs_service_name           = "my-ecs-service"
  container_name             = "my-container"
}

resource "aws_ecs_cluster" "ECS_Cluster" {
  name = local.ecs_cluster_name
}

resource "aws_ecs_capacity_provider" "ECS_Capacity_Provider" {
  name = local.ecs_capacity_provider_name

  auto_scaling_group_provider {
    auto_scaling_group_arn = var.auto_scaling_group_arn
  }
}

resource "aws_ecs_cluster_capacity_providers" "ECS_Cluster_Capacity_Providers" {
  cluster_name = aws_ecs_cluster.ECS_Cluster.name

  capacity_providers = [aws_ecs_capacity_provider.ECS_Capacity_Provider.name]

  default_capacity_provider_strategy {
    base              = 1
    weight            = 100
    capacity_provider = aws_ecs_capacity_provider.ECS_Capacity_Provider.name
  }
}

resource "aws_ecs_task_definition" "ECS_Task_Definition" {
  family       = local.ecs_task_definition_name
  network_mode = "awsvpc"
  cpu          = 768
  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "X86_64"
  }
  container_definitions = jsonencode([
    {
      name      = local.container_name
      image     = var.image_id
      cpu       = 256
      memory    = 512
      essential = true
      portMappings = [
        {
          containerPort = 9000
          hostPort      = 9000
          protocol      = "tcp"
        }
      ]
    },
    {
      name      = "nginx"
      image     = "nginx:1.25.4-alpine3.18"
      cpu       = 256
      memory    = 512
      essential = true
      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
          protocol      = "tcp"
        }
      ]
    },
    {
      name      = "redis"
      image     = "redis:7.2.4-alpine"
      cpu       = 256
      memory    = 512
      essential = true
      portMappings = [
        {
          containerPort = 6379
          hostPort      = 6379
          protocol      = "tcp"
        }
      ]
    },
  ])
}

resource "aws_ecs_service" "ECS_Service" {
  name            = local.ecs_service_name
  cluster         = aws_ecs_cluster.ECS_Cluster.id
  task_definition = aws_ecs_task_definition.ECS_Task_Definition.arn
  desired_count   = 2

  network_configuration {
    subnets         = var.subnets
    security_groups = var.security_groups
  }

  force_new_deployment = true
  placement_constraints {
    type = "distinctInstance"
  }

  triggers = {
    redeployment = timestamp()
  }

  capacity_provider_strategy {
    capacity_provider = aws_ecs_capacity_provider.ECS_Capacity_Provider.name
    weight            = 100
  }

  load_balancer {
    target_group_arn = var.target_group_arn
    container_name   = local.container_name
    container_port   = 80
  }
}
