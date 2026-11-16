# Policy rollout runbook

## Audit

1. Confirm Kyverno is healthy and the `fortress` applications are synced.
2. In the first policy commit, set every Fortress
   `validationFailureAction` to `Audit` before syncing. The requested commit
   split keeps this as the baseline-policy commit.
3. Review `PolicyReport` and `ClusterPolicyReport` resources:

   ```sh
   kubectl get policyreport,clusterpolicyreport -A
   kubectl describe clusterpolicyreport -A
   ```

4. Fix every violation or document a narrowly scoped exception with owner,
   reason, and expiry.

## Enforce

After review, change every `validationFailureAction` back to `Enforce`,
review the diff, and merge through the normal protected branch process. The
base policies in this final state use `validationFailureAction: Enforce`.
Confirm rejected resources are reported by Kyverno.

The generated default-deny policy intentionally excludes `kube-system`,
`kube-public`, `kube-node-lease`, `argocd`, `kyverno`, and
`external-secrets`. These namespaces contain control-plane or installer
components whose traffic is managed by their platform operators rather than
application teams.

The same namespaces are excluded from the baseline, label, and image
policies. Monitoring charts and Falco are platform components; Falco also
requires host access for syscall capture. Application namespaces remain
subject to the full policy set.

## AWS External Secrets

Create separate IAM roles for the dev and prod External Secrets service
accounts. Each role must allow only its own environment prefix. For example,
the dev role policy is:

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "secretsmanager:BatchGetSecretValue",
        "secretsmanager:DescribeSecret",
        "secretsmanager:GetResourcePolicy",
        "secretsmanager:GetSecretValue",
        "secretsmanager:ListSecretVersionIds"
      ],
      "Resource": [
        "arn:aws:secretsmanager:REGION:ACCOUNT:secret:fortress/dev/items-*"
      ]
    },
    {
      "Effect": "Allow",
      "Action": "secretsmanager:ListSecrets",
      "Resource": "*"
    }
  ]
}
```

Replace only placeholders outside Git before use. Use the equivalent
environment-specific prefix for the prod role. Do not add access keys or
secret values to Kubernetes manifests. Select the AWS SecretStore manifests
instead of the kind fake-provider manifests for an AWS environment.
