output "budget_id" {
  description = "AWS budget identifier."
  value       = aws_budgets_budget.monthly.id
}

output "budget_name" {
  description = "AWS budget name."
  value       = aws_budgets_budget.monthly.name
}

