# Roadmap

This document outlines the planned direction for Soroscope. Items are organised by milestone. Priorities can shift based on community feedback — open an issue to upvote or discuss any item.

---

## v0.4 — Differential Benchmarking (Q3 2025)

- [ ] `soroscope benchmark` subcommand: run a contract function N times and report mean/p50/p95 instruction counts
- [ ] CSV output mode for `benchmark` results (suitable for CI artefact storage)
- [ ] GitHub Actions workflow template for automated regression detection
- [ ] Configurable instruction-count budget with non-zero exit code on breach

## v0.5 — Multi-Contract Workspace Profiling (Q4 2025)

- [ ] Workspace-level scan: profile every contract in a Cargo workspace in one command
- [ ] Aggregate report showing hottest contracts ranked by CPU and RAM
- [ ] HTML report output (`--output html`) with embedded flame graphs
- [ ] Side-by-side comparison UI for workspace snapshots

## v0.6 — Live Network Integration (Q1 2026)

- [ ] Fetch real transaction history for a contract address and replay invocations locally
- [ ] Detect storage bloat by comparing on-chain footprint against profiler prediction
- [ ] Integration with Stellar Expert API for historical gas price context

## v1.0 — Stable API and Plugin System (Q2 2026)

- [ ] Stabilise `core/` library public API with semantic versioning guarantees
- [ ] Plugin interface for custom metric collectors
- [ ] AssemblyScript contract support
- [ ] Comprehensive rustdoc coverage (100% of public items)

---

## Completed

- [x] CPU instruction counting via embedded Soroban host (v0.1)
- [x] RAM and ledger-entry footprint (v0.2)
- [x] `soroscope compare` subcommand (v0.3)
- [x] Interactive web UI with flame graph (v0.3)
- [x] Fee market analytics module
- [x] Emergency guard contract integration
