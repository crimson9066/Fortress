#!/usr/bin/env bash
set -euo pipefail

environment="${1:-}"
if [[ -z "$environment" ]]; then
  printf 'Usage: %s <environment>\n' "$0" >&2
  exit 2
fi

case "$environment" in
  dev)
    ;;
  *)
    printf 'Refusing unknown environment: %s\n' "$environment" >&2
    exit 2
    ;;
esac

printf 'This will run Terraform apply for environment: %s\n' "$environment"
printf 'It may create billable AWS resources, including EKS, NAT gateways, KMS keys, and budgets.\n'
printf 'Review the plan and AWS account, region, and budget before continuing.\n'
read -r -p "Type ${environment} to confirm: " confirmation
if [[ "$confirmation" != "$environment" ]]; then
  printf 'Confirmation did not match; no Terraform command was run.\n' >&2
  exit 1
fi

terraform -chdir="infra/terraform/envs/${environment}" apply

