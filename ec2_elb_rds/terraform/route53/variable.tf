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

variable "public_ip" {
  type = string
  description = "The public IP address of the EC2 instance"
  default = ""
}

variable "zone_id" {
  type = string
  description = "The zone ID of the Cloudfront distribution"
  default = ""
}