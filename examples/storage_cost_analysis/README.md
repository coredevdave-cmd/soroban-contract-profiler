# Example: Storage Cost Analysis

This example demonstrates how to compare the ledger storage cost of different storage strategies in Soroban contracts.

## Storage classes in Soroban

| Class | TTL | Cost | Use case |
|-------|-----|------|----------|
| `instance` | Tied to contract instance | Cheapest per-byte | Config, admin keys |
| `persistent` | Extends with explicit `bump` | Medium | Long-lived user data |
| `temporary` | Expires after N ledgers | Cheapest write | Session data, nonces |

## Profiling write cost per storage class

```bash
# Profile a contract that uses instance storage
soroscope profile --function write_instance --output json contracts/storage_heavy/storage_heavy.wasm > instance.json

# Profile a contract that uses persistent storage
soroscope profile --function write_persistent --output json contracts/storage_heavy/storage_heavy.wasm > persistent.json

# Profile a contract that uses temporary storage
soroscope profile --function write_temporary --output json contracts/storage_heavy/storage_heavy.wasm > temporary.json
```

## Interpreting write_bytes

Extract `footprint_write_bytes` from each result:

```bash
jq '.footprint_write_bytes' instance.json persistent.json temporary.json
```

Expected output (approximate):

```
256    # instance  — includes contract instance overhead
192    # persistent
128    # temporary — cheapest; no durability guarantee
```

## Key takeaway

Temporary storage has the lowest `write_bytes` and therefore the lowest fee. Use it for data that does not need to survive beyond its TTL (e.g. session tokens, rate-limit counters).

For data that must survive indefinitely, use `persistent` and call `extend_ttl` proactively to avoid archival fees.

## Further reading

- [docs/OPTIMISATION_COOKBOOK.md](../../docs/OPTIMISATION_COOKBOOK.md) — storage recipes
- [METRICS_REFERENCE.md](../../METRICS_REFERENCE.md) — full description of `footprint_write_bytes`
