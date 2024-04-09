terraform {
  required_version = ">=1.7.4"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "=5.35.0"
    }
  }
}

provider "aws" {
  region = "ap-southeast-1"
}

provider "aws" {
  alias  = "us-east-1"
  region = "us-east-1"
}

data "aws_availability_zones" "availability_zones" {}

locals {
  vpc_name = "My VPC"
  public_subnet_name = "Public Subnet"
  gateway_name = "Internet Gateway"
  public_route_table_name = "Public Route Table"
  public_security_groups_name = "Public Security Group"
  ec2_user = "ec2-user"
  ec2_name = "MyEC2Instance"
  availability_zones = slice(data.aws_availability_zones.availability_zones.names, 0, 1)
  public_subnet = [for k, v in local.availability_zones : cidrsubnet(local.vpc_cidr, 8, k + 48)]
  vpc_cidr = "10.0.0.0/16"
}

resource "aws_acm_certificate" "acm_certificate" {
  private_key = "${file("${path.root}/../certificate/privkey.pem")}"
  certificate_body = "${file("${path.root}/../certificate/cert.pem")}"
  certificate_chain = "${file("${path.root}/../certificate/fullchain.pem")}"
  provider = aws.us-east-1
}

resource "tls_private_key" "private_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_sensitive_file" "local_file" {
  content  = tls_private_key.private_key.private_key_pem
  filename = "${path.root}/${var.ssh_key_name}.pem"
  file_permission = "0400"
}

resource "aws_key_pair" "key_pair" {
  key_name   = var.ssh_key_name
  public_key = tls_private_key.private_key.public_key_openssh
}

resource "aws_vpc" "vpc" {
  cidr_block           = local.vpc_cidr
  enable_dns_hostnames = true

  tags = {
    Name = "${local.vpc_name}"
  }
}

resource "aws_subnet" "public_subnet" {
  count             = length(local.public_subnet)
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = local.public_subnet[count.index]
  availability_zone = local.availability_zones[count.index]

  tags = {
    Name = "${local.public_subnet_name}-${count.index}"
  }
}

resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.vpc.id
  
  tags = {
    Name = "${local.gateway_name}"
  }
}

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gateway.id
  }

  tags = {
    "Name" = "${local.public_route_table_name}"
  }
}

resource "aws_route_table_association" "public_route_table_association" {
  for_each       = { for k, v in aws_subnet.public_subnet : k => v }
  subnet_id      = each.value.id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_security_group" "public_security_group" {
  name        = "${local.public_security_groups_name}"
  description = "${local.public_security_groups_name}"
  vpc_id      = aws_vpc.vpc.id

  tags = {
    "Name" = "${local.public_security_groups_name}"
  }

  ingress = [
    {
      description      = "Allow all incoming traffics on port 80"
      from_port        = 80
      to_port          = 80
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    },
    {
      description      = "Allow all incoming traffics on port 443"
      from_port        = 443
      to_port          = 443
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    },
    {
      description      = "Allow ssh access from specific IP address"
      from_port        = 22
      to_port          = 22
      protocol         = "tcp"
      cidr_blocks      = [var.ssh_ip]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    },
    {
      description      = "Allow MySQL access from specific IP address"
      from_port        = 3306
      to_port          = 3306
      protocol         = "tcp"
      cidr_blocks      = [var.ssh_ip]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    }]

  egress = [
    {
      description      = "Allow all outgoing traffics"
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    }
  ]
}

locals {

}

data "aws_ami" "Ami" {
  most_recent      = true
  owners           = ["amazon"]
 
  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }
 
  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
 
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
 
}

resource "aws_instance" "instance" {
  count                       = 1
  ami                         = data.aws_ami.Ami.id
  instance_type               = var.instance_type
  key_name                    = aws_key_pair.key_pair.key_name
  subnet_id                   = aws_subnet.public_subnet.*.id[count.index]
  vpc_security_group_ids      = [aws_security_group.public_security_group.id]
  associate_public_ip_address = true

  tags = {
    Name = "${local.ec2_name}-${count.index}-Public"
  }
}

resource "local_file" "Configs" {
  content = templatefile("${path.root}/scripts/install.tpl",
    {
      mysql_root_password = var.mysql_root_password
      mysql_db_user       = var.mysql_db_user
      mysql_db_password   = var.mysql_db_password
      mysql_db_name       = var.mysql_db_name
      ec2_domain          = var.domain_name
      ssh_ip              = var.ssh_ip
      fullchain = file("${path.root}/../certificate/fullchain.pem")
      privkey = file("${path.root}/../certificate/privkey.pem")
    }
  )
  filename = "${path.root}/scripts/install.sh"
}

resource "null_resource" "Run_Install" {

  provisioner "file" {
    source      = "${path.root}/scripts/install.sh"
    destination = "/tmp/install.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/install.sh",
      "sudo /tmp/install.sh"
    ]
  }

  connection {
    type        = "ssh"
    user        = local.ec2_user
    private_key = aws_key_pair.key_pair.key_name
    host        = aws_instance.instance[0].public_ip
  }

  depends_on = [ local_file.Configs ]
}

resource "aws_route53_zone" "route53_zone" {
  name = var.domain_name
}

resource "aws_route53_record" "route53_record_1" {
  zone_id = aws_route53_zone.route53_zone.zone_id
  name    = var.domain_name
  type    = "A"
  ttl     = "300"
  records = []
}

resource "aws_route53_record" "route53_record_2" {
  zone_id = aws_route53_zone.route53_zone.zone_id
  name    = "cdn.${var.domain_name}"
  type    = "A"
  alias {
    name = var.cloudfront_domain_name
    zone_id = var.zone_id
    evaluate_target_health = false
  }
}

output "main" {
  value = {
    public_ip = aws_instance.instance[0].public_ip
  }
}
