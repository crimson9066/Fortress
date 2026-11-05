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
