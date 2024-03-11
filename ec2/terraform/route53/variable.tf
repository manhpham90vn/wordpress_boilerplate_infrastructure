variable "domain_name" {
  type = string
  description = "The domain name"
  default = ""
}

variable "public_ip" {
  type = string
  description = "The public IP address of the EC2 instance"
  default = ""
}