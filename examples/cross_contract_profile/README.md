# Example: Cross-Contract Profiling

This example shows how to profile a contract that calls another contract, using Soroscope's `--mock-contract` flag to stub out the dependency.

## Scenario

Suppose you have a `swap_router` contract that calls a `liquidity_pool` contract. You want to measure the CPU and storage cost of `swap_router.execute_swap` in isolation, without running a live node.

## Step 1 — Build both contracts

```bash
# Build the dependency first
cd contracts/liquidity_pool
cargo build --target wasm32-unknown-unknown --release

# Then build the caller
cd ../swap_router
cargo build --target wasm32-unknown-unknown --release
```

## Step 2 — Profile with a mocked dependency

```bash
POOL_ADDR="CABC1234EXAMPLECONTRACTADDRESS56789012345678901234567890"
POOL_WASM="contracts/liquidity_pool/target/wasm32-unknown-unknown/release/liquidity_pool.wasm"
ROUTER_WASM="contracts/swap_router/target/wasm32-unknown-unknown/release/swap_router.wasm"

soroscope profile \
  --function execute_swap \
  --mock-contract "$POOL_ADDR=$POOL_WASM" \
  "$ROUTER_WASM"
```

Soroscope loads both Wasm blobs into the same sandboxed host. Calls from `swap_router` to the `liquidity_pool` address are served by the stubbed binary — **no network required**.

## Step 3 — Interpret the output

```
Function        cpu_instructions  ram_peak_bytes  write_bytes
execute_swap       1 245 890         32 768         1 024
  ↳ swap_router      843 210         16 384           512
  ↳ liquidity_pool   402 680         16 384           512
```

The breakdown shows how much each contract contributes. If `liquidity_pool` dominates, optimise there first.

## Tips

- Pass `--mock-contract` multiple times to stub several dependencies.
- Add `--output json` to feed the result into a CI comparison script.
- Use `soroscope compare` between before/after builds to catch regressions automatically.
