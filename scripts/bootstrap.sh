#!/usr/bin/env bash
set -euo pipefail

CLUSTER_NAME="${KIND_CLUSTER_NAME:-fortress}"
ARGOCD_VERSION="${ARGOCD_VERSION:-v3.6.1}"
ROOT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
CONTEXT="kind-${CLUSTER_NAME}"
ARGOCD_MANIFEST="https://raw.githubusercontent.com/argoproj/argo-cd/${ARGOCD_VERSION}/manifests/install.yaml"

command -v kubectl >/dev/null 2>&1 || { printf 'Missing required command: kubectl\n' >&2; exit 1; }
kubectl config get-contexts "${CONTEXT}" >/dev/null 2>&1 || {
  printf 'Kind context "%s" does not exist. Run make cluster-up first.\n' "${CONTEXT}" >&2
  exit 1
}

kubectl --context "${CONTEXT}" create namespace argocd --dry-run=client -o yaml |
  kubectl --context "${CONTEXT}" apply -f -
kubectl --context "${CONTEXT}" apply --server-side --force-conflicts \
  --context "${CONTEXT}" -n argocd -f "${ARGOCD_MANIFEST}"

kubectl --context "${CONTEXT}" apply -k "${ROOT_DIR}/gitops/argocd"
kubectl --context "${CONTEXT}" apply -f "${ROOT_DIR}/gitops/root-application.yaml"
kubectl --context "${CONTEXT}" -n argocd rollout status deployment/argocd-server --timeout=5m

printf 'Argo CD %s is installed. Access it only with:\n' "${ARGOCD_VERSION}"
printf 'kubectl --context %s -n argocd port-forward svc/argocd-server 8080:443\n' "${CONTEXT}"
