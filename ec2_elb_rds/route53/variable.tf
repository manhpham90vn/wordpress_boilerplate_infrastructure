variable "domain_name" {
  type = string
  description = "The domain name"
  default = ""
}

variable "cdn_domain_name" {
  type = string
  description = "The cdn domain name"
  default = ""
}

variable "cloudfront_domain_name" {
  type = string
  description = "The cloudfront domain name"
  default = ""
}

variable "cloudfront_zone_id" {
  type = string
  description = "The zone ID of the Cloudfront distribution"
  default = ""
}

variable "load_balancer_domain_name" {
  type = string
  description = "The load balancer domain name"
  default = ""
}

variable "load_balancer_zone_id" {
  type = string
  description = "The zone ID of the load balancer distribution"
  default = ""
}

variable "public_ip" {
  type = string
  description = "The public IP address of the EC2 instance"
  default = ""
}

