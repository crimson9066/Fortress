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

