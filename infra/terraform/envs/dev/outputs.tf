output "vpc_id" {
  description = "Development VPC identifier."
  value       = module.vpc.vpc_id
}

output "eks_cluster_name" {
  description = "Development EKS cluster name."
  value       = module.eks.cluster_name
}

output "budget_name" {
  description = "Development monthly budget name."
  value       = module.budget.budget_name
}

