# Falco write below `/etc`

- **Impact:** A container modified protected system configuration.
- **Diagnose:** Confirm the file path, process, image digest, pod, and owning deployment.
- **Mitigate:** Isolate the pod and roll back or replace the image after collecting evidence.
- **Escalate:** Engage security response if the write was not part of an approved startup action.
