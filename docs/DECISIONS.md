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
