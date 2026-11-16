#!/usr/bin/env bash
set -euo pipefail

CLUSTER_NAME="${KIND_CLUSTER_NAME:-fortress}"
command -v kind >/dev/null 2>&1 || { printf 'Missing required command: kind\n' >&2; exit 1; }

if kind get clusters | grep -Fxq "${CLUSTER_NAME}"; then
  kind delete cluster --name "${CLUSTER_NAME}"
else
  printf 'Kind cluster "%s" does not exist.\n' "${CLUSTER_NAME}"
fi
