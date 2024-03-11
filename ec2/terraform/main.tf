terraform {
  required_version = "=1.7.4"
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

# data "aws_availability_zones" "Availability_Zones" {}

# locals {
#   azs = slice(data.aws_availability_zones.Availability_Zones.names, 0, 1)
#   vpc_cidr = "10.0.0.0/16"
# }

# module "ssh" {
#   source = "./ssh"
#   ssh_key_name = var.ssh_key_name
# }

# module "vpc" {
#   source = "./vpc"
#   cidr_block = local.vpc_cidr
#   public_subnet  = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 8, k + 48)]
#   availability_zone = local.azs
#   ssh_ip = var.ssh_ip
# }

# module "ec2" {
#   source = "./ec2"
#   ami = var.ami
#   instance_type = var.instance_type
#   key_name = module.ssh.data.key_name
#   public_subnet_id = module.vpc.data.public_subnet_id
#   public_security_group_id = module.vpc.data.public_security_group_id
#   private_key = module.ssh.data.private_key
#   mysql_root_password = var.mysql_root_password
#   mysql_db_user = var.mysql_db_user
#   mysql_db_password = var.mysql_db_password
#   mysql_db_name = var.mysql_db_name
#   ssh_ip = var.ssh_ip
#   domain_name = var.domain_name
# }

# module "route53" {
#   source = "./route53"
#   domain_name = var.domain_name
#   public_ip = module.ec2.data.public_ip
# }

module "acm" {
  source = "./acm"
}

module "s3" {
  source = "./s3"
  bucket_name = "runtimedev"
}

module "cloudfront" {
  source = "./cloudfront"
  domain_name = module.s3.data.bucket_regional_domain_name
  acm_certificate_arn = module.acm.data.arn
}

# output "ec2" {
#   value = {
#     public_ip = module.ec2.data.public_ip
#     name_servers = module.route53.data.name_servers
#   }
# }
