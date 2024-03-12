variable "origin_domain_name" {
  description = "The domain name of the Cloudfront distribution"
  type        = string
  default     = ""
}

variable "cdn_domain_name" {
  description = "Domain name"
  type        = string
  default     = ""
}

variable "s3_bucket" {
  description = "value of the s3 bucket"
  type        = string
  default     = ""
}

variable "acm_certificate_arn" {
  description = "The ARN of the ACM certificate"
  type        = string
  default     = ""
}

variable "cloudfront_access_identity_path" {
  description = "The path of the Cloudfront access identity"
  type        = string
  default     = ""
}