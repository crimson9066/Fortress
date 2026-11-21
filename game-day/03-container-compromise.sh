#!/usr/bin/env bash
set -euo pipefail

: "${GAME_DAY_CONFIRM:=}"
if [[ "$GAME_DAY_CONFIRM" != "I-understand-this-is-a-disposable-cluster" ]]; then
  echo "Set GAME_DAY_CONFIRM=I-understand-this-is-a-disposable-cluster to continue." >&2
  exit 1
fi

namespace="${GAME_DAY_NAMESPACE:-items-dev}"
pod="${GAME_DAY_POD:?Set GAME_DAY_POD to the disposable items pod name}"
kubectl -n "$namespace" exec "$pod" -- sh -c 'id; cat /var/run/secrets/kubernetes.io/serviceaccount/token'
kubectl -n "$namespace" exec "$pod" -- sh -c 'wget -T 3 -qO- https://example.com || true'

