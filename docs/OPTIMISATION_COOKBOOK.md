# Soroban Contract Optimisation Cookbook

Practical recipes for reducing CPU instructions, RAM usage, and ledger footprint in Soroban smart contracts.

## 1. Avoid Redundant Storage Reads

Every `env.storage().persistent().get()` call costs CPU instructions. Cache the value in a local variable if you read it more than once.

**Before:**
```rust
if env.storage().persistent().get::<_, u64>(&DataKey::Counter).unwrap_or(0) > 0 {
    let count = env.storage().persistent().get::<_, u64>(&DataKey::Counter).unwrap_or(0);
    // use count
}
```

**After:**
```rust
let count = env.storage().persistent().get::<_, u64>(&DataKey::Counter).unwrap_or(0);
if count > 0 {
    // use count
}
```

**Saving:** ~200–400 CPU instructions per avoided read.

---

## 2. Prefer `instance` Storage for Frequently Accessed Config

`instance` storage is cheaper to access than `persistent` for values that are read on almost every call (e.g. admin address, fee rate, paused flag).

```rust
// Expensive: persistent storage for hot path
env.storage().persistent().get::<_, Address>(&DataKey::Admin)

// Cheaper: instance storage
env.storage().instance().get::<_, Address>(&DataKey::Admin)
```

---

## 3. Return Early on Auth Failures

Check authorization before any storage reads. Failed auth reverts the transaction but you still pay for any work done before the revert.

```rust
pub fn withdraw(env: Env, caller: Address, amount: i128) -> Result<(), Error> {
    caller.require_auth(); // fail fast — before any storage access
    let config = read_config(&env)?;
    // ...
}
```

---

## 4. Batch Writes — Update State Once

Accumulate state changes in local variables and write to storage once at the end of the function.

**Before:**
```rust
config.total += amount;
write_config(&env, &config);
record.count += 1;
write_record(&env, &record);
config.last_updated = now;
write_config(&env, &config); // second write!
```

**After:**
```rust
config.total += amount;
config.last_updated = now;
record.count += 1;
write_config(&env, &config);  // single write
write_record(&env, &record);  // single write
```

---

## 5. Minimise `Vec` and `Map` Sizes in Storage

`Vec` and `Map` stored on-chain consume ledger entries proportional to their size. Prefer fixed-size structs where the maximum length is bounded and small.

- Cap participant lists with an explicit `MAX_SIGNERS` or `MAX_RECIPIENTS` constant
- Prefer `u32`/`u64` identifiers over `String` or `Bytes` keys in maps
- Archive old entries to `temporary` storage rather than keeping them in `persistent`

---

## 6. Use `temporary` Storage for Short-lived Data

Nonces, rate-limit windows, and proposal expiry data do not need to live forever. `temporary` storage has a much lower rent cost.

```rust
// Use temporary storage for per-epoch rate limit records
env.storage().temporary().set(&RateLimitKey::User(caller.clone()), &record);
env.storage().temporary().extend_ttl(&RateLimitKey::User(caller), 0, EPOCH_LEDGERS);
```

---

## 7. Emit Events Instead of Storing History

On-chain history (e.g. a `Vec<Transaction>` in storage) is expensive. Emit events instead — they are indexed off-chain by Horizon and cost far less than persistent storage entries.

```rust
env.events().publish(
    (symbol_short!("transfer"), symbol_short!("v1")),
    (from.clone(), to.clone(), amount),
);
```

---

## Reading Profiler Output

After analysing a contract with Soroscope, focus on:

| Metric | Warning Threshold | Action |
|--------|------------------|--------|
| CPU instructions | > 80% of limit | Reduce loops and storage reads |
| RAM bytes | > 70% of limit | Shrink struct sizes, avoid large Vecs |
| Ledger read bytes | > 60% of limit | Reduce number of storage keys touched |
| Ledger write bytes | > 50% of limit | Batch writes, use temporary storage |
