variable "domain_name" {
  description = "The domain name of the Cloudfront distribution"
  type        = string
  default     = ""
}

variable "acm_certificate_arn" {
  description = "The ARN of the ACM certificate"
  type        = string
  default     = ""
}