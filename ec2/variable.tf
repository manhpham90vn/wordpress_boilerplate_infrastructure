variable "instance_type" {
  type = string
  description = "Instance type of the EC2"

  validation {
    condition = contains(["t2.micro", "t3.small"], var.instance_type)
    error_message = "Value not allow."
  }
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

variable "mysql_root_password" {
  type        = string
  description = "Root password for MySQL"
  default     = ""
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

variable "mysql_db_name" {
  type        = string
  description = "Database name"
  default     = ""
}