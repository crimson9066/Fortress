.PHONY: help fmt validate lint test security vuln docker-build kind-up kind-down

help:
	@printf "Available targets:\n"
	@printf "  fmt       Format repository files (planned)\n"
	@printf "  validate  Validate infrastructure and manifests (planned)\n"
	@printf "  lint      Run linters (planned)\n"
	@printf "  test      Run Go tests with the race detector\n"
	@printf "  lint      Run golangci-lint\n"
	@printf "  vuln      Run govulncheck\n"
	@printf "  docker-build Build the hardened service image\n"
	@printf "  security  Run security checks (planned)\n"
	@printf "  kind-up   Create the local kind cluster (planned)\n"
	@printf "  kind-down Delete the local kind cluster (planned)\n"

fmt validate security kind-up kind-down:
	@printf "%s is planned; no implementation exists in Phase 1.\n" "$@"

test:
	cd app && go test -race ./...

lint:
	cd app && golangci-lint run

vuln:
	cd app && govulncheck ./...

docker-build:
	docker build --file app/Dockerfile --tag fortress:local app
