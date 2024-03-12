variable "bucket_name" {
  description = "The name of the bucket"
  type        = string
  default     = ""
}

variable "aws_iam_policy_document" {
  description = "value of the IAM policy document"
  type        = any
}