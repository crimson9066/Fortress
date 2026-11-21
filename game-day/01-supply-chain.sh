#!/usr/bin/env bash
set -euo pipefail

: "${GAME_DAY_CONFIRM:=}"
if [[ "$GAME_DAY_CONFIRM" != "I-understand-this-is-a-disposable-cluster" ]]; then
  echo "Set GAME_DAY_CONFIRM=I-understand-this-is-a-disposable-cluster to continue." >&2
  exit 1
fi

namespace="${GAME_DAY_NAMESPACE:-items-dev}"
kubectl -n "$namespace" apply -f - <<'YAML'
apiVersion: apps/v1
kind: Deployment
metadata:
  name: game-day-unsigned
spec:
  selector:
    matchLabels:
      app: game-day-unsigned
  template:
    metadata:
      labels:
        app: game-day-unsigned
    spec:
      containers:
        - name: test
          image: nginx:latest
YAML

