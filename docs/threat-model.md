# Threat Model

This STRIDE baseline covers the planned Fortress platform. Every mitigation is **Planned** until implemented and verified.

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

| # | STRIDE category | Threat | Component | Planned mitigation | Phase |
|---:|---|---|---|---|---|
| 1 | Spoofing | A stolen CI identity impersonates the deployment role | GitHub Actions / AWS | Use GitHub OIDC with repository and branch or environment conditions; no long-lived keys | Planned: Phase 4-5 |
| 2 | Tampering | A pull request changes infrastructure or policy without adequate review | GitHub / Terraform / policies | CODEOWNERS, required reviews, protected branches, pinned dependencies, and fail-closed checks | Planned: Phase 1, 5 |
| 3 | Repudiation | A destructive or privileged change cannot be attributed | GitHub / cluster / cloud | Signed commits, immutable audit logs, workflow provenance, and retained evidence | Planned: Phase 5, 8 |
| 4 | Information disclosure | Secrets or sensitive state are exposed in source or artifacts | Repository / CI / Terraform | Secret scanning, gitleaks, encrypted remote state, redaction, and least-privilege access | Planned: Phase 1, 4-5 |
| 5 | Denial of service | An exposed workload or unbounded pod exhausts resources | Kubernetes / workload | Default-deny network policy, resource requests and limits, probes, and non-public ingress | Planned: Phase 3 |
| 6 | Elevation of privilege | A pod or service account gains host or cluster privileges | Kubernetes / workload | Restricted pod security, non-root containers, dropped capabilities, scoped RBAC, and Kyverno policies | Planned: Phase 2-3 |
| 7 | Tampering | An untrusted image or dependency enters the deployment | Build / registry / GitOps | Digest-pinned images, dependency scanning, provenance, admission policy, and review gates | Planned: Phase 2, 5-6 |
| 8 | Information disclosure | Telemetry leaks credentials or personal data | Observability | Structured redaction, restricted access, encrypted transport and storage, and retention limits | Planned: Phase 7-8 |
| 9 | Denial of service | A malicious or faulty policy blocks recovery or deployment | Kyverno / Argo CD | Test policies, staged rollout, documented break-glass procedure, and game-day validation | Planned: Phase 3, 6, 8 |
| 10 | Elevation of privilege | Cloud trust permits an unintended repository or branch to assume a role | AWS IAM / OIDC | Exact repository, ref, and environment conditions; short-lived credentials; audit and negative tests | Planned: Phase 4-5 |

