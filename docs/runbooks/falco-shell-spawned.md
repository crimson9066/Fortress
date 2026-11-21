# Falco shell spawned in container

- **Impact:** Interactive command execution occurred inside an application container.
- **Diagnose:** Review the Falco event, pod identity, image digest, user, and deployment history.
- **Mitigate:** Isolate or delete the pod, rotate affected credentials, and pause the deployment if unauthorized.
- **Escalate:** Notify security response and preserve Falco, Kubernetes audit, and container logs.
