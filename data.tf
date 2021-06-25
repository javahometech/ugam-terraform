data "aws_caller_identity" "current" {}

data "aws_availability_zones" "available" {
  state = "available"
}
data "template_file" "ugam_api_policy" {
  template = file("templates/ugam-api-iam.json")
  vars = {
    ugam_api_bucket = "${var.ugam_api_bucket}"
  }
}

data "aws_iam_policy_document" "example" {
  statement {
    sid = "1"
    actions = [
      "s3:GetObject",
      "s3:PutObject",
    ]
    resources = [
      "arn:aws:s3:::${var.ugam_api_bucket}/*",
    ]
  }
}