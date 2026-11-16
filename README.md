# Fortress

Fortress is a secure, observable Kubernetes platform portfolio project demonstrating reproducible infrastructure, policy enforcement, GitOps delivery, runtime detection, and operational response for a small Go workload. AWS resources are optional and ephemeral; the primary development and verification target is a local kind cluster.

## Status

| Phase | Scope | Status |
|---|---|---|
| Phase 1 | Repository foundation and governance | Planned |
| Phase 2 | Go workload and container hardening | Implemented; local checks documented below |
| Phase 3 | Local Kubernetes platform and policies | Planned |
| Phase 4 | Terraform and optional AWS infrastructure | Planned |
| Phase 5 | Local kind cluster and GitOps delivery | Implemented; live cluster verification requires Docker, kind, and Helm |
| Phase 6 | Kyverno policy enforcement and External Secrets | Implemented; live cluster verification requires Docker, kind, and Helm |
| Phase 7 | Observability and runtime detection | Implemented; live cluster verification requires Docker, kind, and Helm |
| Phase 8 | Game days, evidence, and operational documentation | Planned |

## Local development

Implementation and verification commands will be added with each phase. See [docs/DECISIONS.md](docs/DECISIONS.md) and [docs/threat-model.md](docs/threat-model.md) for the current design baseline.

Phase 2 provides the Go API in [`app/`](app/), including health and readiness endpoints, an in-memory items API, request safety middleware, Prometheus metrics, structured logs, tests, and a digest-pinned distroless image definition. The application test suite passes with `CGO_ENABLED=0`; race, lint, vulnerability, and Docker checks require the corresponding local toolchains and Docker daemon.

Phase 5 provides a local kind cluster with Cilium NetworkPolicy enforcement,
pinned Argo CD, and restricted dev/prod GitOps manifests. Run `make cluster-up`
then `make bootstrap`; see [`docs/runbooks/local-cluster.md`](docs/runbooks/local-cluster.md).

Phase 6 provides pinned Kyverno policies, pass/fail CLI fixtures, and
External Secrets Operator manifests for kind's fake provider or AWS
Secrets Manager. See [`docs/runbooks/policy-rollout.md`](docs/runbooks/policy-rollout.md).

Phase 7 provides pinned Prometheus/Grafana monitoring, SLO alerts, Falco
runtime detection, and Alertmanager runbooks through Argo CD.
