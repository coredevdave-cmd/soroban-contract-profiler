# Troubleshooting

## Build errors

### `error[E0463]: can't find crate for 'soroban_sdk'`

Make sure the `soroban-sdk` version in your contract's `Cargo.toml` matches the version pinned in Soroscope's workspace `Cargo.toml`. Run:

```bash
cargo tree -i soroban-sdk
```

and align the versions.

---

### `LLVM error: ... wasm32-unknown-unknown target not found`

The wasm32 target is not installed. Fix with:

```bash
rustup target add wasm32-unknown-unknown
```

---

## Runtime errors

### `Error: failed to parse Wasm: magic number mismatch`

The file passed to `soroscope profile` is not a valid WebAssembly binary. Check that the build succeeded and that you're pointing at the `.wasm` output, not the source file:

```bash
ls -lh target/wasm32-unknown-unknown/release/*.wasm
```

---

### `Error: contract trap — out of gas`

The contract exceeded Soroscope's default simulation gas limit. Raise it with:

```bash
soroscope profile --cpu-budget 0 path/to/contract.wasm
```

`--cpu-budget 0` disables the budget cap entirely.

---

### `Error: RPC timeout after 10s`

The configured RPC endpoint did not respond in time. Either increase the timeout in `soroscope.toml`:

```toml
[rpc]
timeout_secs = 30
```

or switch to a closer endpoint (e.g. a local `stellar-core` node).

---

## Web UI

### Flame graph does not show function names

Compile your contract with debug information:

```bash
RUSTFLAGS="-C debuginfo=2" cargo build --target wasm32-unknown-unknown --release
```

Then re-upload the `.wasm` file.

---

### `npm run dev` fails with `Cannot find module 'next'`

Run `npm install` inside the `web/` directory first:

```bash
cd web && npm install
```

---

## Diagnostics

Enable verbose logging to get more context for any error:

```bash
SOROSCOPE_LOG=debug soroscope profile path/to/contract.wasm 2>&1 | tee soroscope.log
```

Attach `soroscope.log` when filing a bug report.
