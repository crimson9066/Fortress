# Falco service account token read

- **Impact:** A process accessed Kubernetes credentials from the pod filesystem.
- **Diagnose:** Identify the process, command line, pod, namespace, and service account.
- **Mitigate:** Isolate the pod, revoke or rotate the associated identity, and inspect API audit logs.
- **Escalate:** Page security response immediately for unexpected token use.
