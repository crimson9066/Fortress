# Scenario 5: infrastructure misconfiguration

## Hypothesis

Checkov fails a pull request when a throwaway change widens the GitHub OIDC
trust policy or opens a security-group ingress rule.

## Script

Run [`05-misconfiguration.sh`](05-misconfiguration.sh). It creates local
fixture files and runs Checkov when available; it never applies Terraform.

## Expected detection

The Checkov CI gate reports the insecure trust or ingress configuration and
fails the check.

## Actual result


## Time to detect


