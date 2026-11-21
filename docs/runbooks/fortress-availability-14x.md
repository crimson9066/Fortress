# Fortress availability burn rate (14.4x)

- **Impact:** The 99.5% availability budget is being consumed rapidly.
- **Diagnose:** Check the alert query, `fortress_http_requests_total`, recent deployments, and application logs.
- **Mitigate:** Roll back the last release or remove the failing dependency; verify `/healthz` and `/readyz`.
- **Escalate:** Page the platform owner if the 5-minute window remains above budget after mitigation.
