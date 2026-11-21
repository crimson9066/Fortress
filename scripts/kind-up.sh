#!/usr/bin/env bash
set -euo pipefail

CLUSTER_NAME="${KIND_CLUSTER_NAME:-fortress}"
CILIUM_VERSION="${CILIUM_VERSION:-1.20.4}"
ROOT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
KIND_CONFIG="${ROOT_DIR}/kind/kind-config.yaml"

for command in docker kind kubectl helm; do
  command -v "${command}" >/dev/null 2>&1 || {
    printf 'Missing required command: %s\n' "${command}" >&2
    exit 1
  }
done

if ! docker info >/dev/null 2>&1; then
  printf 'Docker daemon is not available.\n' >&2
  exit 1
fi

if kind get clusters | grep -Fxq "${CLUSTER_NAME}"; then
  printf 'Kind cluster "%s" already exists.\n' "${CLUSTER_NAME}"
else
  kind create cluster --config "${KIND_CONFIG}" --name "${CLUSTER_NAME}"
fi

helm upgrade --install cilium oci://quay.io/cilium/charts/cilium \
  --version "${CILIUM_VERSION}" \
  --namespace kube-system \
  --set image.pullPolicy=IfNotPresent \
  --set ipam.mode=kubernetes \
  --wait \
  --timeout 5m

kubectl --context "kind-${CLUSTER_NAME}" rollout status daemonset/cilium \
  --namespace kube-system --timeout=5m
kubectl --context "kind-${CLUSTER_NAME}" wait --for=condition=Ready nodes \
  --all --timeout=5m

printf 'Cluster "%s" is ready with Cilium NetworkPolicy enforcement.\n' "${CLUSTER_NAME}"
