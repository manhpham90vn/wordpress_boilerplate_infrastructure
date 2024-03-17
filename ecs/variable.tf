variable "instance_type" {
  type = string
  description = "Instance type of the EC2"

  validation {
    condition = contains(["t2.micro", "t3.small"], var.instance_type)
    error_message = "Value not allow."
  }
}

variable "db_instance_class" {
  type = string
  description = "Instance class of the RDS"
}

variable "ami" {
  type = string
  description = "AMI ID"
  default = ""
}

variable "ssh_key_name" {
  type = string
  description = "SSH Key Pair Name"
  default = ""
}

variable "ssh_ip" {
  type        = string
  description = "IP address to allow SSH access"
  default     = ""
}

variable "domain_name" {
  type = string
  description = "The domain name"
  default = ""
}

variable "mysql_db_user" {
  type        = string
  description = "Database user"
  default     = ""
}

variable "mysql_db_password" {
  type        = string
  description = "Database password"
  default     = ""
}

variable "image_id" {
  description = "value of the image id"
  type = string
  default = ""
}

variable "aim_for_autoscaling" {
  type        = string
  description = "Aim for autoscaling"
  default     = ""
}