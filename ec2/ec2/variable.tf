variable "countInstancesPublic" {
  type        = number
  description = "Number of instances to create in public subnet"
  default     = 1
}

variable "instance_type" {
  type = string
  description = "Type of instance"

  validation {
    condition = contains(["t2.micro", "t3.small"], var.instance_type)
    error_message = "Value not allow."
  }
}

variable "key_name" {
  type = string
  description = "Key Pair"
  default = ""
}

variable "private_key" {
  type = string
  description = "Private Key"
  default = ""
  
}

variable "public_subnet_id" {
  type = list(string)
  description = "Subnet Public ID"
  default = []
}

variable "public_security_group_id" {
  type = string
  description = "List of security group IDs public"
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

variable "ssh_ip" {
  type        = string
  description = "Ip address allowed to connect to the database"
  default     = ""
}

variable "domain_name" {
  type        = string
  description = "Domain of the EC2"
  default     = ""
}