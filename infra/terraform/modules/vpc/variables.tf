variable "name" {
  description = "Prefix used for VPC resource names."
  type        = string
}

variable "vpc_cidr" {
  description = "IPv4 CIDR range for the VPC."
  type        = string
}

variable "availability_zone_count" {
  description = "Number of Availability Zones to use."
  type        = number
  default     = 3

  validation {
    condition     = var.availability_zone_count >= 2 && var.availability_zone_count <= 6 && var.availability_zone_count == floor(var.availability_zone_count)
    error_message = "availability_zone_count must be a whole number between 2 and 6."
  }
}

variable "public_subnet_cidrs" {
  description = "One public subnet CIDR per Availability Zone."
  type        = list(string)
}

variable "private_subnet_cidrs" {
  description = "One private subnet CIDR per Availability Zone."
  type        = list(string)
}

variable "flow_log_retention_days" {
  description = "CloudWatch retention period for VPC flow logs."
  type        = number
  default     = 90

  validation {
    condition     = var.flow_log_retention_days > 0 && var.flow_log_retention_days == floor(var.flow_log_retention_days)
    error_message = "flow_log_retention_days must be a positive whole number."
  }
}

variable "tags" {
  description = "Tags applied to VPC resources."
  type        = map(string)
  default     = {}
}

