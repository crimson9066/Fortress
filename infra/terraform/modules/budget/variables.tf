variable "name" {
  description = "Budget name."
  type        = string
}

variable "limit_usd" {
  description = "Monthly budget limit in USD."
  type        = number

  validation {
    condition     = var.limit_usd > 0
    error_message = "limit_usd must be greater than zero."
  }
}

variable "alert_email" {
  description = "Email address that receives actual and forecasted budget alerts."
  type        = string

  validation {
    condition     = can(regex("^[^@\\s]+@[^@\\s]+\\.[^@\\s]+$", var.alert_email))
    error_message = "alert_email must be a valid email address."
  }
}

variable "alert_threshold_percent" {
  description = "Percentage of the monthly limit at which alerts are sent."
  type        = number
  default     = 80

  validation {
    condition     = var.alert_threshold_percent > 0 && var.alert_threshold_percent <= 100
    error_message = "alert_threshold_percent must be greater than zero and at most 100."
  }
}

variable "tags" {
  description = "Tags applied to the budget."
  type        = map(string)
  default     = {}
}

