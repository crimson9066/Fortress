#!/usr/bin/env bash
set -euo pipefail

printf '| Scenario | Expected detection | Actual result | Time to detect |\n'
printf '|---|---|---|---|\n'
printf '| Supply chain | Kyverno denies unsigned and :latest images | | |\n'
printf '| Secret leak | Push protection or Gitleaks blocks the fake key | | |\n'
printf '| Container compromise | Falco alerts and egress is denied | | |\n'
printf '| Reliability | SLO burn-rate alert fires and runbook is followed | | |\n'
printf '| Misconfiguration | Checkov fails the insecure Terraform change | | |\n'
printf '\nActual result and time-to-detect fields remain empty until the scenarios are run.\n'
