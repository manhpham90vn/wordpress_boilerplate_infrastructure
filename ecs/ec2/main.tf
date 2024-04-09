locals {
  user = "ec2-user"
  name = "MyEC2Instance"
}

data "aws_ami" "Ami" {
  most_recent = true

  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }

  filter {
    name   = "name"
    values = ["al2023-ami-ecs-hvm-*-x86_64"]
  }
}

resource "aws_instance" "MyEC2InstancePublic" {
  count                       = var.countInstancesPublic
  ami                         = data.aws_ami.Ami.id
  instance_type               = var.instance_type
  key_name                    = var.key_name
  subnet_id                   = var.public_subnet_id[count.index]
  vpc_security_group_ids      = [var.public_security_group_id]

  tags = {
    Name = "${local.name}-${count.index}-Public"
  }
}