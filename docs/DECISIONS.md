# Architecture Decisions

This log records choices that affect security, reproducibility, operations, or project scope. Each entry must state context, decision, alternatives, and consequences.

## ADR template

### ADR-NNN: Short title

- **Status:** Proposed | Accepted | Superseded
- **Context:** Why is a decision needed?
- **Decision:** What was chosen?
- **Alternatives:** What else was considered?
- **Consequences:** What becomes easier, harder, or more risky?

## ADR-001: Kind first, AWS optional and ephemeral

- **Status:** Accepted
- **Context:** The platform must be reproducible and affordable for local development while still demonstrating cloud security practices.
- **Decision:** Build and verify the platform against kind first. Treat AWS resources as optional, explicitly ephemeral, and subject to documented destroy steps and a budget alarm before use.
- **Alternatives:** Require AWS for every workflow; use a different local Kubernetes distribution; omit cloud infrastructure entirely.
- **Consequences:** Local verification is accessible and avoids mandatory spend, but AWS-specific behavior requires separate validation. Any AWS phase must include least-privilege IAM, encryption, cost controls, and a manual destroy path.

## ADR-002: Standard-library HTTP service with Prometheus instrumentation

- **Status:** Accepted
- **Context:** The portfolio workload should be small enough to audit while demonstrating production HTTP safety and observable SLO signals.
- **Decision:** Use Go's standard-library `net/http` and `log/slog`, with `prometheus/client_golang` as the only external application dependency. Keep the item store in memory for this phase.
- **Alternatives:** Use a web framework; add a database; use a different logging or metrics stack.
- **Consequences:** The service has a small dependency and attack surface, but data is intentionally ephemeral and the API is not horizontally consistent until a persistence layer is planned and implemented.

## ADR-003: Native S3 state locking with a customer-managed KMS key

- **Status:** Accepted
- **Context:** Terraform state needs recovery, encryption, transport protection, and locking without introducing an additional state-locking database.
- **Decision:** Use Terraform 1.17.1's S3 backend `use_lockfile` native locking, an S3 state bucket with versioning and SSE-KMS using a rotating customer-managed key, and a separate encrypted access-log bucket. Bootstrap remains local-state until its outputs are reviewed and the backend is explicitly configured.
- **Alternatives:** Use the legacy DynamoDB locking table; use an unencrypted or unversioned bucket; use a hosted Terraform backend.
- **Consequences:** The bootstrap has fewer AWS resources and follows the current Terraform backend behavior, but the backend configuration must be completed manually after bootstrap and the KMS key has a 30-day deletion window.

## ADR-004: One NAT gateway per Availability Zone

- **Status:** Accepted
- **Context:** Private subnets need controlled outbound access while the VPC module remains reusable for multi-AZ EKS environments.
- **Decision:** Create one NAT gateway and private route table per selected Availability Zone. Enable VPC flow logs to an encrypted, retained CloudWatch log group and remove all default security-group rules.
- **Alternatives:** Use one shared NAT gateway to reduce cost; expose private workloads directly; leave the default security-group rules unchanged.
- **Consequences:** The design is more resilient to an Availability Zone failure and avoids cross-AZ NAT traffic, but NAT gateways incur recurring hourly and data-processing charges. The cost trade-off is documented in `docs/cost.md` during the budget phase.

## ADR-005: Exact GitHub OIDC subjects for plan and apply

- **Status:** Accepted
- **Context:** Terraform CI must use short-lived AWS credentials without exposing long-lived secrets or allowing arbitrary branches and workflows to assume privileged roles.
- **Decision:** Create one GitHub OIDC provider and two roles. The plan role accepts only the exact repository pull-request subject. The apply role accepts only the exact protected `production` environment subject and an exact workflow reference on `refs/heads/main`. Both roles have a one-hour maximum session and receive permissions only through explicitly supplied policy ARNs.
- **Alternatives:** Use access keys; trust the repository broadly; use wildcard branch or subject conditions; attach broad administrator permissions by default.
- **Consequences:** Fork and branch credentials are constrained by immutable OIDC claims, but callers must explicitly provide the minimum managed policies needed for each Terraform stack.

## ADR-006: EKS API authentication and node hardening

- **Status:** Accepted
- **Context:** The cluster must avoid legacy `aws-auth`, protect Kubernetes Secrets, restrict API exposure, and prevent pod access to instance metadata credentials.
- **Decision:** Use EKS API authentication with access entries, encrypt Secrets with a rotating KMS key, enable all control-plane log types, place managed nodes in private subnets, restrict the public API endpoint to caller-supplied CIDRs, install the EKS Pod Identity Agent, and require IMDSv2 with hop limit 1 on nodes.
- **Alternatives:** Use `aws-auth`; leave Secrets unencrypted; allow `0.0.0.0/0`; use public nodes; permit IMDSv1 or a hop limit of 2.
- **Consequences:** The cluster has stronger default isolation and auditability, but operators must supply explicit API CIDRs, access entries, and workload IAM associations before use.

## ADR-007: Explicit monthly budget and confirmation-gated AWS helpers

- **Status:** Accepted
- **Context:** Optional AWS demonstrations can create recurring charges and destructive cleanup must be deliberate.
- **Decision:** Require a monthly AWS Budget with actual and forecasted email alerts. Provide environment allowlisted `aws-up.sh` and `aws-down.sh` helpers that print the impact and require the exact environment name before invoking Terraform.
- **Alternatives:** Rely on manual commands with no budget; auto-apply or auto-destroy from CI; accept arbitrary environment names.
- **Consequences:** Cost and destructive-action friction are visible before use, but the alert email and environment-specific variables must be configured by the operator.
