#!/usr/bin/env bash
set -euo pipefail

# Scan staged/tracked files for common secret patterns.
# Keep this lightweight and dependency-free.

ROOT_DIR="$(git rev-parse --show-toplevel)"
cd "$ROOT_DIR"

# Ignore known safe/generated areas that can be noisy.
EXCLUDES=(
  ".git/"
)

PATTERNS=(
  # Generic private key headers
  "-----BEGIN (RSA|EC|DSA|OPENSSH|PGP) PRIVATE KEY-----"
  # Common API key/token prefixes
  "AIza[0-9A-Za-z\\-_]{35}"
  "sk_live_[0-9A-Za-z]{24,}"
  "xox[baprs]-[0-9A-Za-z-]{10,}"
  "ghp_[0-9A-Za-z]{36}"
  "github_pat_[0-9A-Za-z_]{20,}"
  "AKIA[0-9A-Z]{16}"
  "ASIA[0-9A-Z]{16}"
  # JWT-ish token
  "eyJ[A-Za-z0-9_-]{10,}\\.[A-Za-z0-9._-]{10,}\\.[A-Za-z0-9._-]{10,}"
  # Mapbox public/secret token prefixes
  "pk\\.[A-Za-z0-9._-]{20,}"
  "sk\\.[A-Za-z0-9._-]{20,}"
)

RG_GLOBS=()
for ex in "${EXCLUDES[@]}"; do
  RG_GLOBS+=(--glob "!${ex}**")
done

matches=0
for pattern in "${PATTERNS[@]}"; do
  if rg -n -I --pcre2 "${pattern}" . "${RG_GLOBS[@]}" >/tmp/secret_scan_hits.txt 2>/dev/null; then
    if [ "$matches" -eq 0 ]; then
      echo "Potential secrets detected. Push blocked."
    fi
    matches=1
    echo "--- Pattern: ${pattern}"
    cat /tmp/secret_scan_hits.txt
  fi
done

rm -f /tmp/secret_scan_hits.txt

if [ "$matches" -ne 0 ]; then
  echo
  echo "If a match is intentional, redact or move it to environment variables."
  exit 1
fi

echo "Secret scan passed."
