output "iam_policy" {
  value = data.template_file.ugam_api_policy.rendered
}