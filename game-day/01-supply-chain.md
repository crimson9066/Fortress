# Scenario 1: supply-chain policy

## Hypothesis

Kyverno blocks a workload that uses an unsigned image or a mutable `:latest`
tag before it can run in an application namespace.

## Script

Run [`01-supply-chain.sh`](01-supply-chain.sh) against a disposable kind
cluster. The script requires explicit confirmation and does not target AWS.

## Expected detection

Kyverno admission denies both manifests. A PolicyReport records the denied
resource if the admission request is configured for reporting.

## Actual result


## Time to detect


