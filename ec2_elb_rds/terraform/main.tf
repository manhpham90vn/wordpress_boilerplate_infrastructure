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

data "aws_availability_zones" "Availability_Zones" {}

locals {
  azs = slice(data.aws_availability_zones.Availability_Zones.names, 0, 3)
  vpc_cidr = "10.0.0.0/16"
}

module "ssh" {
  source = "./ssh"
  ssh_key_name = var.ssh_key_name
}

module "vpc" {
  source = "./vpc"
  cidr_block = local.vpc_cidr
  private_subnet = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 4, k)]
  public_subnet  = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 8, k + 48)]
  availability_zone = local.azs
  ssh_ip = var.ssh_ip
}

module "ec2" {
  source = "./ec2"
  ami = var.ami
  instance_type = var.instance_type
  key_name = module.ssh.data.key_name
  public_subnet_id = module.vpc.data.public_subnet_id
  public_security_group_id = module.vpc.data.public_security_group_id
  private_key = module.ssh.data.private_key
  domain_name = var.domain_name
}

module "rds" {
  source = "./rds"
  db_instance_class = var.db_instance_class
  subnet_ids = module.vpc.data.private_subnet_id
  vpc_security_group_ids = [module.vpc.data.private_security_group_id]
  db_user = var.mysql_db_user
  db_password = var.mysql_db_password
}

module "route53" {
  source = "./route53"
  domain_name = var.domain_name
  cdn_domain_name = "cdn.${var.domain_name}"
  cloudfront_domain_name = module.cloudfront.data.cloudfront_domain_name
  cloudfront_zone_id = module.cloudfront.data.zone_id
  load_balancer_domain_name = module.elb.data.load_balancer_dns_name
  load_balancer_zone_id = module.elb.data.zone_id
  public_ip = module.ec2.data.public_ip
}

module "acm" {
  source = "./acm"
}

module "s3" {
  source = "./s3"
  bucket_name = "runtimedev"
}

module "cloudfront" {
  source = "./cloudfront"
  cdn_domain_name = "cdn.${var.domain_name}"
  origin_domain_name = module.s3.data.bucket_regional_domain_name
  acm_certificate_arn = module.acm.data.arn_us
  s3_bucket = module.s3.data.s3_bucket_name
  cloudfront_access_identity_path = module.s3.data.cloudfront_access_identity_path
  depends_on = [ module.s3 ]
}

module "elb" {
  source = "./elb"
  security_groups = [module.vpc.data.public_security_group_id]
  subnets = module.vpc.data.public_subnet_id
  vpc_id = module.vpc.data.vpc_id
  certificate_arn = module.acm.data.arn
  aim_for_autoscaling = var.aim_for_autoscaling
  instance_type = var.instance_type
}

output "ec2" {
  value = {
    public_ip = module.ec2.data.public_ip
    db = module.rds.data.rds_endpoint
    lb = module.elb.data.load_balancer_dns_name
    name_servers = module.route53.data.name_servers
  }
}
