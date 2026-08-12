# Frequently Asked Questions

## General

### What is Soroscope?

Soroscope is a profiling tool for Soroban smart contracts. It measures CPU instruction count, RAM usage, and ledger-entry footprint without requiring a live network connection. Profiling is performed against the compiled `.wasm` binary using an embedded Soroban host.

### Does it require a Stellar node?

No. Soroscope runs the contract locally through a sandboxed Soroban host. An RPC endpoint is optional and only needed when you use the `--rpc` flag to fetch real ledger state as simulation input.

### Which contract languages are supported?

Any language that compiles to Soroban-compatible WebAssembly. In practice this means Rust (via `soroban-sdk`) today, with AssemblyScript support planned.

---

## Profiling

### Why do my CPU numbers differ from on-chain execution?

The profiler uses a deterministic instruction counter. Gas costs on-chain include additional factors such as base transaction overhead and network-level metering that are outside the scope of local simulation.

### Can I profile a contract that calls other contracts?

Yes, via cross-contract simulation. Pass `--mock-contract <address>=<wasm_path>` for each dependency and Soroscope will wire them together in the same host environment.

### How do I reduce ledger-entry footprint?

See [docs/OPTIMISATION_COOKBOOK.md](docs/OPTIMISATION_COOKBOOK.md) for seven concrete recipes. The most common fix is switching from `instance` storage to `temporary` storage for short-lived keys.

---

## Web UI

### The flame graph is blank after I upload a `.wasm` file.

Make sure the file was compiled with debug symbols (`RUSTFLAGS="-C debuginfo=2"`). Without them Soroscope cannot map instructions back to source functions.

### Can I export the profiling report?

Yes. Click **Export → JSON** in the top-right toolbar. The resulting file can be re-imported into Soroscope or fed to the `soroscope compare` command.

---

## Contributing

### How do I run the test suite?

```bash
cargo test --workspace
```

See [CONTRIBUTING.md](CONTRIBUTING.md) for the full contribution workflow.

### Where do I report bugs or request features?

Open an issue using the templates in [`.github/ISSUE_TEMPLATE/`](.github/ISSUE_TEMPLATE/). Please include the Soroscope version (`soroscope --version`) and the Soroban CLI version.
