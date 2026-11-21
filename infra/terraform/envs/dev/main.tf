locals {
  name = "fortress-dev"
}

module "vpc" {
  source = "../../modules/vpc"

  name                    = local.name
  vpc_cidr                = "10.40.0.0/16"
  availability_zone_count = 3
  public_subnet_cidrs     = ["10.40.0.0/20", "10.40.16.0/20", "10.40.32.0/20"]
  private_subnet_cidrs    = ["10.40.128.0/20", "10.40.144.0/20", "10.40.160.0/20"]
  tags = {
    Environment = "dev"
  }
}

module "eks" {
  source = "../../modules/eks"

  name                    = local.name
  vpc_id                  = module.vpc.vpc_id
  private_subnet_ids      = module.vpc.private_subnet_ids
  api_public_access_cidrs = var.api_public_access_cidrs
  tags = {
    Environment = "dev"
  }
}

module "budget" {
  source = "../../modules/budget"

  name        = "${local.name}-monthly"
  limit_usd   = 100
  alert_email = var.budget_alert_email
  tags = {
    Environment = "dev"
  }
}

