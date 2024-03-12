output "data" {
  value = {
    aws_iam_policy_document = data.aws_iam_policy_document.Iam_Policy_Document.json
  }
}