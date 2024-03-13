variable "security_groups" {
  type = list(string)
  description = "List of security groups to associate with the load balancer"
}

variable "subnets" {
  type = list(string)
  description = "value of the subnets to associate with the load balancer"
}

variable "vpc_id" {
  type = string
  description = "value of the vpc id to associate with the load balancer"
}

variable "certificate_arn" {
  type = string
  description = "value of the certificate arn to associate with the load balancer"
}

variable "aim_for_autoscaling" {
  type        = string
  description = "Aim for autoscaling"
  default     = ""
}

variable "instance_type" {
  type = string
  description = "Instance type of the EC2"

  validation {
    condition = contains(["t2.micro", "t3.small"], var.instance_type)
    error_message = "Value not allow."
  }
}