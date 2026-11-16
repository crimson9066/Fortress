# Scenario 2: secret leak

## Hypothesis

Repository push protection or the CI Gitleaks gate blocks a throwaway commit
containing a clearly fake private-key-shaped value.

## Script

Run [`02-secret-leak.sh`](02-secret-leak.sh). It creates a temporary worktree
and local commit only; it never pushes.

## Expected detection

GitHub push protection blocks the push, or the Gitleaks CI check fails on the
commit. The fake value must be removed before the throwaway branch is used
again.

## Actual result


## Time to detect


