## Summary

<!-- Describe the change and its security or operational impact. -->

## Verification

<!-- List commands run and their relevant results. -->

## Security checklist

- [ ] No real secrets, credentials, tokens, account IDs, or personal emails were added.
- [ ] Least privilege is preserved for IAM, Kubernetes RBAC, and CI permissions.
- [ ] New actions, providers, modules, and images are pinned and provenance is documented.
- [ ] Containers remain non-root, read-only, capability-free, and resource bounded where applicable.
- [ ] Network access and encryption defaults remain restrictive.
- [ ] Security checks fail closed and exceptions include reason, owner, and expiry.
- [ ] Documentation claims only behavior verified by this change; future work is labelled Planned.
- [ ] A relevant test or verification command was run.
- [ ] `docs/DECISIONS.md` was updated for any real design choice.

## Reviewer notes

<!-- Call out trade-offs, residual risk, migration steps, or manual settings. -->

