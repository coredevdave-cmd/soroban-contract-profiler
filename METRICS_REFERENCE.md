# Metrics Reference

This document describes every metric that Soroscope produces and explains how to interpret it.

---

## CPU Metrics

### `cpu_instructions`

**Type:** integer  
**Unit:** Soroban instruction units

The total number of instruction units consumed by a single invocation of the profiled function. This maps directly to the Soroban host's metered instruction counter and is the primary driver of transaction fees.

**Interpretation:**
- < 100 000 — trivially cheap
- 100 000 – 1 000 000 — typical for well-optimised contracts
- > 5 000 000 — approaching practical limits; optimise before mainnet

### `cpu_instructions_per_function`

**Type:** map of `{ function_name: integer }`

A breakdown of `cpu_instructions` by Wasm function. Use this to pinpoint hotspots in the flame graph.

---

## Memory Metrics

### `memory_bytes_peak`

**Type:** integer  
**Unit:** bytes

The peak heap size observed during the invocation. Soroban limits contract memory; exceeding the limit causes a trap.

### `memory_bytes_allocated`

**Type:** integer  
**Unit:** bytes

Total bytes allocated (not peak — includes memory that was freed mid-invocation). A high allocation-to-peak ratio suggests frequent short-lived allocations that may benefit from pre-allocation.

---

## Ledger Footprint Metrics

### `footprint_read_entries`

**Type:** integer

Number of distinct ledger entries read during the invocation. Each entry costs a `readBytes` fee.

### `footprint_write_entries`

**Type:** integer

Number of distinct ledger entries written (created or updated). Each entry costs a `writeBytes` fee proportional to entry size.

### `footprint_read_bytes`

**Type:** integer  
**Unit:** bytes

Total bytes read from ledger storage.

### `footprint_write_bytes`

**Type:** integer  
**Unit:** bytes

Total bytes written to ledger storage. This is the largest contributor to fees for storage-heavy contracts.

---

## Derived Metrics

### `estimated_fee_xlm`

**Type:** float  
**Unit:** XLM (approximate)

A rough fee estimate computed from the current Stellar fee schedule. This is **not** a guaranteed on-chain cost — use it for relative comparisons only.

### `efficiency_score`

**Type:** float (0–100)

A composite score calculated as:

```
score = 100 × (1 − cpu_instructions / CPU_BUDGET) × (1 − footprint_write_bytes / WRITE_BUDGET)
```

Where `CPU_BUDGET` and `WRITE_BUDGET` are the Soroban network limits. Higher is better.
