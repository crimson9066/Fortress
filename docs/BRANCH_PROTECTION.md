# Branch Protection Checklist

Configure these settings manually in the repository's default branch. The repository should not claim these controls are enabled until they are verified in GitHub.

- Require a pull request before merging.
- Require at least one approving review and dismiss stale approvals after new changes.
- Require conversation resolution.
- Require all required status checks to pass before merging.
- Require branches to be up to date before merging.
- Require signed commits.
- Require linear history.
- Disable force pushes and branch deletion.
- Enable secret scanning and push protection.
- Enable Dependabot alerts and security updates.
- Enable private vulnerability reporting.
- Restrict who can bypass pull request requirements; keep bypass access minimal and audited.
- Do not allow administrators to bypass these rules unless an emergency process is documented.

## Required status checks

Require these checks on the default branch after the corresponding workflows are present:

- `test`
- `lint`
- `hadolint`
- `gitleaks`
- `govulncheck`
- `codeql`
- `trivy-fs`
- `trivy-image`
- `sbom`
- `workflow-lint`
- `terraform-fmt`
- `terraform-validate`
- `tflint`
- `checkov`
- `trivy-config`
- `terraform-plan`

The `publish` workflow is restricted to the default branch and is not a pull-request merge requirement.

Record the enabled settings and verification date in the Phase 1 evidence once the repository is configured.
