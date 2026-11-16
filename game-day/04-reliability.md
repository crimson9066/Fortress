# Scenario 4: reliability fault injection

## Hypothesis

The guarded local fault-injection flag can generate HTTP 500 responses and
latency, causing the configured SLO burn-rate alert to fire. The flag is off
by default and is not enabled by the production overlay.

## Script

Run [`04-reliability.sh`](04-reliability.sh) only in a disposable local
environment. It requires `FORTRESS_FAULT_INJECTION_ENABLED=true` in the
target workload and an explicit confirmation.

## Expected detection

Availability and latency burn-rate alerts fire, then the operator follows the
corresponding runbook to mitigate and verify recovery.

## Actual result


## Time to detect


