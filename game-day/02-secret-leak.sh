#!/usr/bin/env bash
set -euo pipefail

tmp_dir="$(mktemp -d)"
cleanup() { rm -rf "$tmp_dir"; }
trap cleanup EXIT

git -C "$tmp_dir" init -q
git -C "$tmp_dir" config user.name game-day
git -C "$tmp_dir" config user.email game-day@example.invalid
git -C "$tmp_dir" checkout -q -b game-day-secret-leak
cat > "$tmp_dir/fake-key.txt" <<'EOF'
-----BEGIN OPENSSH PRIVATE KEY-----
GAME_DAY_FAKE_KEY_DO_NOT_USE
-----END OPENSSH PRIVATE KEY-----
EOF
git -C "$tmp_dir" add fake-key.txt
git -C "$tmp_dir" commit -q -m "test: fake secret leak"
echo "Created an unpushed temporary commit at $tmp_dir."
echo "Run gitleaks against that directory or attempt a controlled push to a throwaway branch."

