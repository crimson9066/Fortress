# Fortress latency burn rate (14.4x)

- **Impact:** p95 latency is above 300 ms in both short windows.
- **Diagnose:** Inspect RED dashboard panels, CPU throttling, pod restarts, and downstream calls.
- **Mitigate:** Roll back recent changes, scale replicas, or remove the saturated dependency.
- **Escalate:** Page the platform owner if p95 does not recover after the first mitigation.
