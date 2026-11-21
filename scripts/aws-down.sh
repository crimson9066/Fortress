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

printf 'This will run Terraform destroy for environment: %s\n' "$environment"
printf 'It will delete managed AWS resources and may cause data loss.\n'
printf 'Verify backups, state, account, and region before continuing.\n'
read -r -p "Type ${environment} to confirm destruction: " confirmation
if [[ "$confirmation" != "$environment" ]]; then
  printf 'Confirmation did not match; no Terraform command was run.\n' >&2
  exit 1
fi

terraform -chdir="infra/terraform/envs/${environment}" destroy

