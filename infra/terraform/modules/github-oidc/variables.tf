variable "name" {
  description = "Prefix used for the IAM role and OIDC provider names."
  type        = string
}

variable "repository" {
  description = "GitHub repository in OWNER/REPOSITORY form."
  type        = string

  validation {
    condition     = can(regex("^[A-Za-z0-9_.-]+/[A-Za-z0-9_.-]+$", var.repository))
    error_message = "repository must be in OWNER/REPOSITORY form."
  }
}

variable "apply_workflow_file" {
  description = "Workflow file allowed to assume the apply role from the protected production environment."
  type        = string
  default     = ".github/workflows/publish.yml"

  validation {
    condition     = can(regex("^\\.github/workflows/[A-Za-z0-9_.-]+\\.ya?ml$", var.apply_workflow_file))
    error_message = "apply_workflow_file must name a workflow under .github/workflows."
  }
}

variable "production_environment" {
  description = "Protected GitHub environment required by the apply role."
  type        = string
  default     = "production"

  validation {
    condition     = var.production_environment != "" && !contains(var.production_environment, ":")
    error_message = "production_environment must be non-empty and cannot contain a colon."
  }
}

variable "plan_policy_arns" {
  description = "Explicit managed policy ARNs granting the plan role read-only permissions."
  type        = set(string)
  default     = []
}

variable "apply_policy_arns" {
  description = "Explicit managed policy ARNs granting the apply role only the permissions it needs."
  type        = set(string)
  default     = []
}

variable "tags" {
  description = "Tags applied to IAM resources."
  type        = map(string)
  default     = {}
}

