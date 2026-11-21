variable "name" {
  description = "EKS cluster name."
  type        = string
}

variable "kubernetes_version" {
  description = "Supported EKS Kubernetes version."
  type        = string
  default     = "1.37"

  validation {
    condition     = can(regex("^1\\.(3[5-9]|[4-9][0-9])$", var.kubernetes_version))
    error_message = "kubernetes_version must be a supported 1.35+ minor version."
  }
}

variable "vpc_id" {
  description = "VPC identifier for the EKS cluster."
  type        = string
}

variable "private_subnet_ids" {
  description = "Private subnet identifiers for control plane and nodes."
  type        = list(string)

  validation {
    condition     = length(var.private_subnet_ids) >= 2
    error_message = "At least two private subnets are required."
  }
}

variable "api_public_access_cidrs" {
  description = "CIDR blocks allowed to reach the public EKS Kubernetes API endpoint."
  type        = list(string)

  validation {
    condition     = length(var.api_public_access_cidrs) > 0 && alltrue([for cidr in var.api_public_access_cidrs : can(cidrhost(cidr, 0))])
    error_message = "api_public_access_cidrs must contain at least one valid CIDR and must not be empty."
  }
}

variable "cluster_log_retention_days" {
  description = "CloudWatch retention period for EKS control-plane logs."
  type        = number
  default     = 90
}

variable "node_instance_types" {
  description = "EC2 instance types for the managed node group."
  type        = list(string)
  default     = ["t3.small"]
}

variable "node_min_size" {
  description = "Minimum managed node count."
  type        = number
  default     = 2
}

variable "node_max_size" {
  description = "Maximum managed node count."
  type        = number
  default     = 4
}

variable "node_desired_size" {
  description = "Desired managed node count."
  type        = number
  default     = 2
}

variable "node_disk_size_gib" {
  description = "Encrypted node root volume size."
  type        = number
  default     = 50
}

variable "access_entries" {
  description = "EKS access entries keyed by stable principal name."
  type = map(object({
    principal_arn     = string
    kubernetes_groups = optional(set(string), [])
    policy_arns       = optional(set(string), [])
    access_scope = optional(object({
      type       = string
      namespaces = optional(set(string), [])
    }), { type = "cluster" })
  }))
  default = {}
}

variable "node_role_policy_arns" {
  description = "Managed policy ARNs attached to the node role."
  type        = set(string)
  default = [
    "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryPullOnly",
    "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy",
    "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  ]
}

variable "tags" {
  description = "Tags applied to EKS resources."
  type        = map(string)
  default     = {}
}

