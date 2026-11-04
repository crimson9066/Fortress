# Security Policy

## Reporting a vulnerability

Please report suspected vulnerabilities privately through [GitHub Security Advisories](../../security/advisories/new). Do not open a public issue or include exploit details in a pull request.

If GitHub Security Advisories are unavailable, contact the repository owner through a private GitHub channel and include the affected component, reproduction steps, impact, and a suggested mitigation. Never include credentials, tokens, or other sensitive material in a report.

## Response targets

These are targets, not guarantees:

| Activity | Target |
|---|---|
| Acknowledge a report | 2 business days |
| Initial triage | 5 business days |
| Provide an impact assessment | 10 business days |
| Publish a fix or mitigation | Based on severity and coordinated disclosure |

## Scope

In scope are this repository's Terraform, Kubernetes, GitHub Actions, GitOps, policy, container, observability, and documentation artifacts, plus the small Go workload when it is implemented.

Out of scope are third-party services, GitHub itself, AWS-managed infrastructure outside resources created by this project, denial-of-service testing, social engineering, and reports based only on unsupported configurations.

Security fixes must not disclose secrets. Use placeholders in examples and redact sensitive evidence.

