variable "auto_scaling_group_arn" {
  description = "value of the autoscaling group arn"
  type = string
  default = ""
}

variable "subnets" {
  description = "value of the subnets"
  type = list(string)
  default = []
}

variable "security_groups" {
  description = "value of the security groups"
  type = list(string)
  default = []
}

variable "target_group_arn" {
  description = "value of the target group arn"
  type = string
  default = ""
}

variable "image_id" {
  description = "value of the image id"
  type = string
  default = ""
}