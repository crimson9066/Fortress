# Fortress game day

Game-day exercises are run only against disposable local resources or
throwaway branches. They are designed to test admission policy, secret
detection, runtime detection, SLO response, and infrastructure scanning.

## Run the table

From the repository root:

```sh
bash scripts/game-day-runner.sh
```

The runner intentionally prints blank `Actual result` and `Time to detect`
columns until a human runs the scenarios and records real observations.

## Scenarios

1. [`01-supply-chain.md`](01-supply-chain.md): unsigned and `:latest` image.
2. [`02-secret-leak.md`](02-secret-leak.md): fake key in a local throwaway commit.
3. [`03-container-compromise.md`](03-container-compromise.md): shell, token read, and egress.
4. [`04-reliability.md`](04-reliability.md): guarded 500 and latency injection.
5. [`05-misconfiguration.md`](05-misconfiguration.md): insecure Terraform fixture.

Each script requires explicit confirmation where it can affect a cluster. Do
not run the reliability script against `items-prod`; the production overlay
sets `FORTRESS_FAULT_INJECTION_ENABLED` to `false`.

## Recording results

After each exercise, record the exact command output, UTC timestamps, and
time-to-detect in the scenario's empty fields. If a control fails, create a
blameless postmortem from [`docs/postmortems/TEMPLATE.md`](../docs/postmortems/TEMPLATE.md)
and link the remediation commit from the scenario.
