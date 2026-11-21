# Local cluster runbook

## Prerequisites

Install Docker, kind, kubectl, Helm, and Bash. The Docker daemon must be running.

## Create and bootstrap

```sh
make cluster-up
make bootstrap
```

`cluster-up` creates one control-plane node and two workers with kindnet disabled,
then installs Cilium 1.20.4. Cilium is the NetworkPolicy-enforcing CNI.

`bootstrap` installs Argo CD v3.6.1, applies the hardened configuration, and
creates the restricted Fortress AppProject and app-of-apps. No repository
credentials are stored in Git. Configure a read-only credential out-of-band
before syncing a private repository:

```sh
kubectl -n argocd create secret generic fortress-repository \
  --from-literal=type=git \
  --from-literal=url=https://github.com/crimson9066/Fortress.git \
  --from-literal=username=git-read-only \
  --from-literal=password="$GIT_READ_ONLY_TOKEN" \
  --dry-run=client -o yaml | \
  kubectl apply -f -
kubectl -n argocd label secret fortress-repository \
  argocd.argoproj.io/secret-type=repository
```

The token is never written to a file or shell history when supplied through a
secure environment mechanism. Use a short-lived, read-only credential where
the repository requires authentication.

The workload image in the example manifests is an intentionally non-runnable
zero digest placeholder. Before syncing, replace it with the verified SHA-256
digest produced by the publish workflow; never switch the deployment to a tag.

## Access Argo CD

The server is intentionally not exposed by a LoadBalancer or Ingress:

```sh
kubectl --context kind-fortress -n argocd port-forward svc/argocd-server 8080:443
```

The admin account is disabled. Configure an identity provider before enabling
interactive access. The production application has no automated sync policy;
sync it explicitly after review.

## Verify policy enforcement

```sh
kubectl --context kind-fortress get nodes
kubectl --context kind-fortress -n kube-system get pods -l k8s-app=cilium
kubectl --context kind-fortress -n items-dev get networkpolicy
kubectl --context kind-fortress -n items-dev get deploy,svc,hpa,pdb
```

## Tear down

```sh
make cluster-down
```

This deletes only the local kind cluster and does not affect AWS resources.
