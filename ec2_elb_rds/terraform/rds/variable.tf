variable "subnet_ids" {
  type = list(string)
  description = "The subnet IDs"
  default = [] 
}

variable "vpc_security_group_ids" {
  type = list(string)
  description = "The VPC security group IDs"
  default = []
}

variable "db_user" {
  type = string
  description = "The database user"
  default = ""
}

variable "db_password" {
  type = string
  description = "The database password"
  default = ""
}

variable "db_instance_class" {
  type = string
  description = "Instance class of the RDS"
}