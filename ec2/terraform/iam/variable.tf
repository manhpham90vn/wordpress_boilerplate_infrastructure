variable "s3_arn" {
  description = "The ARN of the S3 bucket"
  type        = string
}

variable "origin_access_identity_arn" {
  description = "The ARN of the CloudFront Origin Access Identity"
  type        = string
}