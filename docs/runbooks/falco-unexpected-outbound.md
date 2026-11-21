# Falco unexpected outbound connection

- **Impact:** The items workload opened an outbound connection outside its expected policy.
- **Diagnose:** Check destination IP/port, DNS activity, image digest, and the NetworkPolicy state.
- **Mitigate:** Block the destination, isolate the pod, and roll back suspicious workload changes.
- **Escalate:** Engage security response for unknown destinations or repeated attempts.
