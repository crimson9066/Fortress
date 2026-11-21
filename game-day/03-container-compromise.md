# Scenario 3: container compromise

## Hypothesis

A shell started in the items container and an attempted service-account-token
read produce Falco alerts, while the application's default-deny egress policy
blocks an outbound connection.

## Script

Run [`03-container-compromise.sh`](03-container-compromise.sh) against the
disposable cluster and namespace selected through environment variables.

## Expected detection

Falco reports shell execution and service-account-token access. A connection
to the test destination fails because NetworkPolicy denies egress.

## Actual result


## Time to detect


