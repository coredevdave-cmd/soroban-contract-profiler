# Benchmarks

Results measured on a 2024 MacBook Pro M3 (16 GB RAM), Soroscope v0.3.0, Soroban SDK 20.3.0.

All figures are the **median** of 100 invocations unless noted otherwise.

---

## Contract benchmark suite

| Contract | Function | CPU instructions | Peak RAM (bytes) | Write bytes |
|----------|----------|-----------------|------------------|-------------|
| `hello_soroban` | `hello` | 12 450 | 4 096 | 0 |
| `math` | `fibonacci(20)` | 234 780 | 8 192 | 0 |
| `math` | `fibonacci(30)` | 1 823 400 | 8 192 | 0 |
| `token` | `transfer` | 487 230 | 16 384 | 512 |
| `liquidity_pool` | `swap` | 1 245 890 | 32 768 | 1 024 |
| `concentrated_amm` | `swap` | 2 874 310 | 65 536 | 2 048 |
| `dutch_auction` | `bid` | 934 120 | 24 576 | 768 |
| `governance` | `vote` | 1 102 450 | 32 768 | 1 536 |
| `flash_loan_vault` | `flash_loan` | 3 451 200 | 131 072 | 4 096 |
| `cpu_heavy` | `run` | 8 920 100 | 65 536 | 0 |
| `storage_heavy` | `write_bulk` | 1 230 000 | 32 768 | 51 200 |

---

## Profiler overhead

Soroscope's instrumentation adds approximately **0.3 ms** per invocation on an M3 chip. The overhead is dominated by Wasm compilation and host initialisation, not the measurement itself.

## Reproducibility

Benchmark numbers are fully deterministic — rerunning on the same hardware produces identical instruction counts. RAM figures can vary by ±64 bytes due to allocator alignment.

## How to reproduce

```bash
cargo build --release

for contract in hello_soroban math token; do
  ./target/release/soroscope benchmark \
    contracts/$contract/target/wasm32-unknown-unknown/release/$contract.wasm \
    --iterations 100 --output csv
done
```
