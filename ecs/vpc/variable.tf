variable "cidr_block" {
  type = string
  description = "value of the cidr block"
  default = ""
}

variable "public_subnet" {
  type = list(string)
  description = "value of the public subnet"
  default = []
}

variable "private_subnet" {
  type = list(string)
  description = "value of the private subnet"
  default = []
}

variable "availability_zone" {
  type = list(string)
  description = "value of the availability zone"
  default = []
}

variable "ssh_ip" {
  type        = string
  description = "IP address to allow SSH access"
  default     = ""
}
