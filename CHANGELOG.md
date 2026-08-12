# Changelog

All notable changes to Soroscope are documented here.

The format follows [Keep a Changelog](https://keepachangelog.com/en/1.0.0/) and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---

## [Unreleased]

### Added
- Cross-contract simulation via `--mock-contract` flag
- Emergency guard contract integration (see `docs/EMERGENCY_GUARD_SETUP.md`)
- Fee market analytics module (`core/src/fee_analytics.rs`)
- TWAP oracle and oracle aggregator example contracts
- Optimisation cookbook with seven concrete cost-reduction recipes

### Changed
- Migrated storage layer to use `temporary` storage by default for volatile keys
- Improved error messages when `.wasm` file cannot be parsed

### Fixed
- Panic when profiling contracts with zero exported functions
- Incorrect ledger-footprint count for contracts that use `instance` and `persistent` storage in the same invocation

---

## [0.3.0] — 2025-04-10

### Added
- Web UI with interactive flame graph (Next.js)
- `soroscope compare` subcommand for diffing two builds
- JSON export from the web UI

### Changed
- Switched internal host to Soroban SDK 20.x
- CLI flag `--output` now accepts `table`, `json`, and `csv`

### Fixed
- Off-by-one in instruction counter for nested function calls

---

## [0.2.0] — 2024-11-20

### Added
- RAM profiling (heap allocations tracked per function)
- Ledger-entry footprint report
- `--rpc` flag for fetching live ledger state

### Changed
- Binary renamed from `soroban-profiler` to `soroscope`

---

## [0.1.0] — 2024-08-05

### Added
- Initial release
- CPU instruction counting via embedded Soroban host
- Basic CLI (`profile` subcommand)
- Example contracts: `hello_soroban`, `math`, `storage_heavy`, `cpu_heavy`
