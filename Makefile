.PHONY: help fmt validate lint test security kind-up kind-down

help:
	@printf "Available targets:\n"
	@printf "  fmt       Format repository files (planned)\n"
	@printf "  validate  Validate infrastructure and manifests (planned)\n"
	@printf "  lint      Run linters (planned)\n"
	@printf "  test      Run tests (planned)\n"
	@printf "  security  Run security checks (planned)\n"
	@printf "  kind-up   Create the local kind cluster (planned)\n"
	@printf "  kind-down Delete the local kind cluster (planned)\n"

fmt validate lint test security kind-up kind-down:
	@printf "%s is planned; no implementation exists in Phase 1.\n" "$@"

