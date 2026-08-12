#!/usr/bin/env bash
# scripts/analyze.sh — profile every contract in the workspace and emit a summary table.
#
# Usage:
#   ./scripts/analyze.sh [--output json|csv|table] [--cpu-budget N]
#
# Requires: soroscope on PATH or built at target/release/soroscope

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

OUTPUT_FORMAT="table"
CPU_BUDGET="0"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --output)  OUTPUT_FORMAT="$2"; shift 2 ;;
    --cpu-budget) CPU_BUDGET="$2"; shift 2 ;;
    *) echo "Unknown flag: $1" >&2; exit 1 ;;
  esac
done

if command -v soroscope &>/dev/null; then
  SOROSCOPE="soroscope"
elif [[ -x "$REPO_ROOT/target/release/soroscope" ]]; then
  SOROSCOPE="$REPO_ROOT/target/release/soroscope"
else
  echo "soroscope binary not found. Run 'cargo build --release' first." >&2
  exit 1
fi

echo "=== Soroscope Workspace Analysis ==="
echo "Format : $OUTPUT_FORMAT"
echo "Binary : $SOROSCOPE"
echo ""

CONTRACTS_DIR="$REPO_ROOT/contracts"

find "$CONTRACTS_DIR" -name "*.wasm" | sort | while read -r wasm; do
  contract_name="$(basename "$(dirname "$(dirname "$(dirname "$wasm")")")")"
  echo "--- $contract_name ---"
  "$SOROSCOPE" profile \
    --output "$OUTPUT_FORMAT" \
    --cpu-budget "$CPU_BUDGET" \
    "$wasm" || echo "  [skipped — profiling failed]"
  echo ""
done

echo "=== Analysis complete ==="
