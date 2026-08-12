# Quickstart Guide

Get up and running with Soroscope in under five minutes.

## Prerequisites

| Tool | Version |
|------|---------|
| Rust | 1.74 or later |
| Soroban CLI | 20.x |
| Node.js | 18 LTS or later (web UI only) |

Install Rust via [rustup](https://rustup.rs/) and the Soroban CLI:

```bash
cargo install --locked soroban-cli
```

## 1. Clone and build

```bash
git clone https://github.com/coredevdave-cmd/soroban-contract-profiler.git
cd soroban-contract-profiler
cargo build --release
```

The binary is placed at `target/release/soroscope`.

## 2. Profile a contract

Point Soroscope at any compiled `.wasm` file:

```bash
./target/release/soroscope profile contracts/hello_soroban/target/wasm32-unknown-unknown/release/hello_soroban.wasm
```

You'll see a table of CPU instructions, RAM (bytes), and ledger-entry footprint printed to stdout.

## 3. Compare two builds

```bash
./target/release/soroscope compare \
  --before contracts/liquidity_pool/v1.wasm \
  --after  contracts/liquidity_pool/v2.wasm
```

A diff table highlights regressions in red and improvements in green.

## 4. Launch the web UI

```bash
cd web
npm install
npm run dev
```

Open <http://localhost:3000> in your browser and upload a `.wasm` file to explore the interactive flame graph.

## 5. Next steps

- Read [CONFIGURATION.md](CONFIGURATION.md) for environment variables and config file options.
- See [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md) for an overview of how the profiler works internally.
- Browse [examples/](examples/) for sample contracts with annotated profiling output.
