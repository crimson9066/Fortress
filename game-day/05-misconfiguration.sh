#!/usr/bin/env bash
set -euo pipefail

tmp_dir="$(mktemp -d)"
cleanup() { rm -rf "$tmp_dir"; }
trap cleanup EXIT

cat > "$tmp_dir/insecure.tf" <<'EOF'
resource "aws_security_group_rule" "game_day_open_ingress" {
  type              = "ingress"
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  security_group_id = "sg-00000000000000000"
}
EOF

if ! command -v checkov >/dev/null 2>&1; then
  echo "checkov is unavailable; fixture created at $tmp_dir/insecure.tf"
  exit 0
fi
checkov -d "$tmp_dir" --quiet

