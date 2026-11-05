# AWS Cost Estimate and Destroy Checklist

AWS is optional and should be used only for a short-lived demonstration in a
dedicated account. Prices vary by region, purchase model, traffic, log volume,
storage, and free-tier eligibility. Confirm current prices in the official
[AWS pricing pages](https://aws.amazon.com/pricing/) before creating resources.
This estimate is a planning model, not an invoice or a measured result.

## Hourly planning estimate

For a small `us-east-1` demonstration, use this conservative planning model:

| Component | Cost driver | Planning assumption |
|---|---|---|
| EKS control plane | Cluster-hour | One cluster-hour at the current EKS published rate |
| EC2 managed nodes | Instance-hours | Two small on-demand nodes |
| NAT gateways | Gateway-hours and data processing | One gateway per AZ, with three AZs |
| EBS | Provisioned GB-month | Two encrypted gp3 node volumes |
| CloudWatch | Log ingestion and retention | Control-plane and VPC flow logs, 90-day retention |
| KMS | Key-month and API requests | Bootstrap, VPC-flow-log, and EKS keys |
| S3 | Storage, requests, and access logging | Versioned state and log buckets |
| Budget | Budget monitoring | One monthly budget |

Before an AWS run, record the current hourly total from the AWS Pricing
Calculator and set the monthly budget below that total multiplied by the
planned run hours. NAT gateways and EKS control planes can dominate short
demonstrations, so local kind remains the default.

## Destroy checklist

- [ ] Confirm the AWS account and region are the intended non-production account.
- [ ] Export any evidence required for the portfolio.
- [ ] Confirm no workload data or logs must be retained.
- [ ] Review the Terraform plan and state for resources outside the intended environment.
- [ ] Run `./scripts/aws-down.sh dev` and type `dev` only after review.
- [ ] Confirm Terraform destroy completed successfully.
- [ ] Verify the EKS cluster, node groups, NAT gateways, EIPs, load balancers, KMS aliases, log groups, and S3 objects are gone or intentionally retained.
- [ ] Retain the state bucket only if its versioned recovery history is required; otherwise remove it through a separately reviewed bootstrap destroy plan.
- [ ] Check AWS Cost Explorer and Budgets for residual charges.

Never use `terraform destroy` against a shared or production account.

