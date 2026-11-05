variable "aws_region" {
  description = "AWS region for the development environment."
  type        = string
  default     = "us-east-1"
}

variable "plan_role_arn" {
  description = "OIDC plan role ARN. Set by CI or a local tfvars file."
  type        = string
  default     = ""
}

variable "budget_alert_email" {
  description = "Budget alert email. Replace the placeholder before an AWS run."
  type        = string
  default     = "replace-me@example.invalid"
}

variable "api_public_access_cidrs" {
  description = "CIDRs allowed to reach the public EKS API endpoint."
  type        = list(string)
  default     = ["203.0.113.0/24"]
}

