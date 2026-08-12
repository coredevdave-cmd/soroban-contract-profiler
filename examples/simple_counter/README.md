# Example: Simple Counter Contract

This example walks through profiling a minimal Soroban counter contract and interpreting the output.

## What the contract does

`simple_counter` exposes two functions:

| Function | Description |
|----------|-------------|
| `increment` | Reads the current count from instance storage, adds 1, writes it back |
| `get_count` | Reads and returns the current count |

## Build the contract

```bash
cd examples/simple_counter
cargo build --target wasm32-unknown-unknown --release
```

## Profile `increment`

```bash
soroscope profile \
  --function increment \
  target/wasm32-unknown-unknown/release/simple_counter.wasm
```

Expected output:

```
Function      cpu_instructions  ram_peak_bytes  write_bytes
increment           48 320           8 192          128
```

## Profile `get_count`

```bash
soroscope profile \
  --function get_count \
  target/wasm32-unknown-unknown/release/simple_counter.wasm
```

Expected output:

```
Function    cpu_instructions  ram_peak_bytes  write_bytes
get_count         31 040           8 192            0
```

## Observations

- `increment` costs ~56 % more CPU than `get_count` because it performs a write in addition to the read.
- Neither function allocates beyond the baseline 8 KB stack frame.
- `write_bytes` of 128 corresponds to a single instance-storage entry update.

## Optimisation idea

If the counter is updated frequently, switching from `instance` to `temporary` storage reduces `write_bytes` fees but means the count resets after the TTL expires. Choose the storage class that matches your durability requirements.
