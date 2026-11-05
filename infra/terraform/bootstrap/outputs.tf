output "state_bucket_name" {
  description = "S3 bucket name for the Terraform backend."
  value       = aws_s3_bucket.state.id
}

output "state_kms_key_arn" {
  description = "KMS key ARN used to encrypt Terraform state."
  value       = aws_kms_key.state.arn
}

output "backend_configuration" {
  description = "Values to use when configuring an S3 backend after bootstrap."
  value = {
    bucket       = aws_s3_bucket.state.id
    key          = "fortress/terraform.tfstate"
    region       = var.aws_region
    encrypt      = true
    kms_key_id   = aws_kms_key.state.arn
    use_lockfile = true
  }
}

