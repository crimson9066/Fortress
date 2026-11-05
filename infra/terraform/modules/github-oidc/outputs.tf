output "oidc_provider_arn" {
  description = "GitHub Actions OIDC provider ARN."
  value       = aws_iam_openid_connect_provider.github.arn
}

output "plan_role_arn" {
  description = "IAM role ARN for pull-request Terraform plans."
  value       = aws_iam_role.plan.arn
}

output "apply_role_arn" {
  description = "IAM role ARN for main-branch production applies."
  value       = aws_iam_role.apply.arn
}

