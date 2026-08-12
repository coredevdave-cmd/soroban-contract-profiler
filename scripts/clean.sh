#!/usr/bin/env bash
# scripts/clean.sh — remove build artefacts, benchmark CSVs, and temporary profile output.
#
# Usage:
#   ./scripts/clean.sh [--all]
#
# Flags:
#   --all    Also remove the Cargo target/ directory (full clean; slow to rebuild)

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

FULL_CLEAN=false

while [[ $# -gt 0 ]]; do
  case "$1" in
    --all) FULL_CLEAN=true; shift ;;
    *) echo "Unknown flag: $1" >&2; exit 1 ;;
  esac
done

echo "=== Soroscope Clean ==="

# Remove benchmark CSV results
find "$REPO_ROOT" -maxdepth 2 -name "benchmark-results.csv" -print -delete

# Remove temporary profile JSON files
find "$REPO_ROOT" -maxdepth 2 -name "*_profile.json" -print -delete
find "$REPO_ROOT" -maxdepth 2 -name "soroscope.log" -print -delete

# Remove web UI build output
if [[ -d "$REPO_ROOT/web/.next" ]]; then
  echo "Removing web/.next"
  rm -rf "$REPO_ROOT/web/.next"
fi

if $FULL_CLEAN; then
  echo "Removing target/ (full clean)"
  cargo clean --manifest-path "$REPO_ROOT/Cargo.toml"
fi

echo "=== Clean complete ==="
