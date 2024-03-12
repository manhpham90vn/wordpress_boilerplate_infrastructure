
data "aws_iam_policy_document" "Iam_Policy_Document" {
  statement {
    actions   = ["s3:GetObject"]
    resources = ["${var.s3_arn}/*"]

    principals {
      type        = "AWS"
      identifiers = [var.origin_access_identity_arn]
    }
  }

  statement {
    actions   = ["s3:ListBucket"]
    resources = [var.s3_arn]

    principals {
      type        = "AWS"
      identifiers = [var.origin_access_identity_arn]
    }
  }
}