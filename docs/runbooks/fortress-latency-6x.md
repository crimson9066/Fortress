# Fortress latency burn rate (6x)

- **Impact:** Sustained latency degradation is consuming the latency budget.
- **Diagnose:** Compare the 6-hour and 30-minute p95 recordings by route.
- **Mitigate:** Tune capacity or roll back the suspected release; preserve evidence before changing configuration.
- **Escalate:** Engage the service owner if the alert remains active for 30 minutes.
