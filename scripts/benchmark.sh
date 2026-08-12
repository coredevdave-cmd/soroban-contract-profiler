#!/usr/bin/env bash
# scripts/benchmark.sh — run the soroscope benchmark suite and write results to a CSV file.
#
# Usage:
#   ./scripts/benchmark.sh [--iterations N] [--out FILE]
#
# Output: CSV file at --out path (default: benchmark-results.csv)
#
# Requires: soroscope on PATH or built at target/release/soroscope

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

ITERATIONS=100
OUT_FILE="benchmark-results.csv"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --iterations) ITERATIONS="$2"; shift 2 ;;
    --out)        OUT_FILE="$2";   shift 2 ;;
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

echo "=== Soroscope Benchmark Suite ==="
echo "Iterations : $ITERATIONS"
echo "Output     : $OUT_FILE"
echo ""

# Write CSV header
echo "contract,function,cpu_p50,cpu_p95,cpu_max,ram_peak_bytes,write_bytes" > "$OUT_FILE"

CONTRACTS_DIR="$REPO_ROOT/contracts"

find "$CONTRACTS_DIR" -name "*.wasm" | sort | while read -r wasm; do
  contract_name="$(basename "$(dirname "$(dirname "$(dirname "$wasm")")")")"
  echo "Benchmarking $contract_name ..."

  result="$("$SOROSCOPE" benchmark \
    --iterations "$ITERATIONS" \
    --output csv \
    "$wasm" 2>/dev/null || echo "$contract_name,unknown,0,0,0,0,0")"

  echo "$result" >> "$OUT_FILE"
done

echo ""
echo "Results written to $OUT_FILE"
echo "=== Benchmark complete ==="
