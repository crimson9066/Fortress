# Threat Model

This STRIDE assessment covers the implemented Fortress platform. Statuses are
based on repository evidence and recorded local verification; controls that
require a live cluster, AWS account, or GitHub settings are marked
**Partially mitigated** until those checks are run.

## Assets

- Workload source, build artifacts, and container images
- Kubernetes API, workloads, secrets, and service accounts
- Terraform state, cloud resources, and IAM permissions
- GitHub repository, Actions workflows, and OIDC trust
- GitOps manifests and deployment history
- Metrics, logs, alerts, and incident evidence

## Actors

- Maintainer or authorized reviewer
- Compromised contributor or pull request
- Compromised CI dependency or action
- Compromised workload or runtime attacker
- External network attacker
- Cloud or cluster administrator

## Trust boundaries

1. Developer workstation to the public Git repository
2. Pull request and GitHub Actions runner to repository and cloud APIs
3. Git repository to Argo CD and the Kubernetes API
4. Kubernetes control plane to workload namespaces
5. Cluster and cloud networks to external services
6. Runtime telemetry to monitoring and evidence storage

## STRIDE threats

| # | STRIDE category | Threat | Component | Status | Evidence |
|---:|---|---|---|---|---|
| 1 | Spoofing | A stolen CI identity impersonates the deployment role | GitHub Actions / AWS | Partially mitigated | [OIDC module](../infra/terraform/modules/github-oidc), [publish workflow](../.github/workflows/publish.yml); live AWS trust verification is not recorded |
| 2 | Tampering | A pull request changes infrastructure or policy without adequate review | GitHub / Terraform / policies | Partially mitigated | [PR checklist](../.github/pull_request_template.md), [CODEOWNERS](../.github/CODEOWNERS), [branch settings](BRANCH_PROTECTION.md) |
| 3 | Repudiation | A destructive or privileged change cannot be attributed | GitHub / cluster / cloud | Partially mitigated | [workflow provenance](../.github/workflows/publish.yml), [branch settings](BRANCH_PROTECTION.md); signed-commit enforcement remains a manual setting |
| 4 | Information disclosure | Secrets or sensitive state are exposed in source or artifacts | Repository / CI / Terraform | Mitigated | [CI secret scan](../.github/workflows/ci.yml), [pre-commit hooks](../.pre-commit-config.yaml), [encrypted state](../infra/terraform/bootstrap) |
| 5 | Denial of service | An exposed workload or unbounded pod exhausts resources | Kubernetes / workload | Partially mitigated | [workload limits and probes](../gitops/apps/items/base/deployment.yaml), [network policy](../gitops/apps/items/base/networkpolicy.yaml); live enforcement is not recorded |
| 6 | Elevation of privilege | A pod or service account gains host or cluster privileges | Kubernetes / workload | Mitigated | [Kyverno baseline](../policies/kyverno/baseline.yaml), [restricted workload](../gitops/apps/items/base/deployment.yaml), [service account](../gitops/apps/items/base/serviceaccount.yaml) |
| 7 | Tampering | An untrusted image or dependency enters the deployment | Build / registry / GitOps | Mitigated | [supply-chain policy](../policies/kyverno/supply-chain.yaml), [publish workflow](../.github/workflows/publish.yml), [policy fixtures](../policies/tests) |
| 8 | Information disclosure | Telemetry leaks credentials or personal data | Observability | Partially mitigated | [structured logging](../app/server.go), [External Secrets](../policies/external-secrets), [monitoring policies](../observability/monitoring); retention and live access review remain operational tasks |
| 9 | Denial of service | A malicious or faulty policy blocks recovery or deployment | Kyverno / Argo CD | Partially mitigated | [Kyverno fixtures](../policies/tests), [rollout runbook](runbooks/policy-rollout.md), [game-day scenarios](../game-day); live game-day results are not yet recorded |
| 10 | Elevation of privilege | Cloud trust permits an unintended repository or branch to assume a role | AWS IAM / OIDC | Partially mitigated | [scoped trust policies](../infra/terraform/modules/github-oidc), [Terraform checks](../.github/workflows/terraform.yml); AWS negative tests require an account |

## Accepted risks

- Falco requires a privileged platform namespace for host syscall capture.
- The application store is intentionally in-memory for this portfolio project.
- AWS resources remain optional and are not created by CI automatically.
