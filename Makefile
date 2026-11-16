.PHONY: help fmt validate lint test security vuln docker-build kind-up bootstrap cluster-up cluster-down

help:
	@printf "Available targets:\n"
	@printf "  fmt       Format repository files (planned)\n"
	@printf "  validate  Validate infrastructure and manifests (planned)\n"
	@printf "  test      Run Go tests with the race detector\n"
	@printf "  lint      Run golangci-lint\n"
	@printf "  vuln      Run govulncheck\n"
	@printf "  docker-build Build the hardened service image\n"
	@printf "  security  Run security checks (planned)\n"
	@printf "  cluster-up Create the local kind cluster with Cilium\n"
	@printf "  bootstrap Install hardened Argo CD and GitOps applications\n"
	@printf "  cluster-down Delete the local kind cluster\n"

fmt validate security:
	@printf "%s is planned; no implementation exists in Phase 1.\n" "$@"

cluster-up:
	bash scripts/kind-up.sh

bootstrap:
	bash scripts/bootstrap.sh

cluster-down:
	bash scripts/cluster-down.sh

test:
	cd app && go test -race ./...

lint:
	cd app && golangci-lint run

vuln:
	cd app && govulncheck ./...

docker-build:
	docker build --file app/Dockerfile --tag fortress:local app
