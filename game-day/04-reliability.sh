#!/usr/bin/env bash
set -euo pipefail

: "${GAME_DAY_CONFIRM:=}"
if [[ "$GAME_DAY_CONFIRM" != "I-understand-this-is-a-disposable-cluster" ]]; then
  echo "Set GAME_DAY_CONFIRM=I-understand-this-is-a-disposable-cluster to continue." >&2
  exit 1
fi

namespace="${GAME_DAY_NAMESPACE:-items-dev}"
if [[ "$namespace" == "items-prod" ]]; then
  echo "Fault injection is forbidden against the prod overlay." >&2
  exit 1
fi
base_url="${GAME_DAY_BASE_URL:-http://localhost:8080}"
kubectl -n "$namespace" set env deployment/items \
  FORTRESS_FAULT_INJECTION_ENABLED=true
kubectl -n "$namespace" rollout status deployment/items --timeout=90s
echo "Confirm the disposable workload has FORTRESS_FAULT_INJECTION_ENABLED=true."
curl --fail-with-body -sS -X POST "$base_url/v1/items" \
  -H 'Content-Type: application/json' \
  -H 'X-Fortress-Fault: 500' \
  --data '{"name":"game-day"}' || true
curl --fail-with-body -sS "$base_url/v1/items" \
  -H 'X-Fortress-Fault: latency' || true

