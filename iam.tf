resource "aws_iam_policy" "ugam_api_policy" {
  name        = "ugam_api_policy_${terraform.workspace}"
  path        = "/ugam/api/"
  description = "ugam iam policy"
  policy      = data.aws_iam_policy_document.example.json
}