# Example: CI Regression Check

This example shows how to integrate Soroscope into a GitHub Actions workflow so that every pull request is automatically checked for CPU or storage regressions.

## Workflow file

Save the following as `.github/workflows/profile.yml` in your contract repository:

```yaml
name: Soroban Contract Profiling

on:
  pull_request:
    paths:
      - 'contracts/**'

jobs:
  profile:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
        with:
          fetch-depth: 0       # needed to check out the base branch

      - name: Install Rust + wasm32 target
        uses: dtolnay/rust-toolchain@stable
        with:
          targets: wasm32-unknown-unknown

      - name: Cache Cargo registry
        uses: actions/cache@v4
        with:
          path: ~/.cargo/registry
          key: ${{ runner.os }}-cargo-${{ hashFiles('**/Cargo.lock') }}

      - name: Install Soroscope
        run: cargo install --locked soroscope

      - name: Build contracts (PR branch)
        run: cargo build --target wasm32-unknown-unknown --release

      - name: Profile PR branch
        run: |
          soroscope profile \
            --output json \
            target/wasm32-unknown-unknown/release/my_contract.wasm \
            > pr_profile.json

      - name: Checkout base branch contract
        run: |
          git stash
          git checkout origin/${{ github.base_ref }} -- contracts/
          cargo build --target wasm32-unknown-unknown --release
          soroscope profile \
            --output json \
            target/wasm32-unknown-unknown/release/my_contract.wasm \
            > base_profile.json
          git checkout -

      - name: Compare and fail on regression
        run: |
          soroscope compare \
            --before base_profile.json \
            --after  pr_profile.json \
            --fail-on-regression

      - name: Upload profiles as artefacts
        if: always()
        uses: actions/upload-artifact@v4
        with:
          name: soroscope-profiles
          path: |
            pr_profile.json
            base_profile.json
```

## What this does

1. Builds the contract on the PR branch and profiles it.
2. Checks out the base branch contract and profiles it.
3. Runs `soroscope compare --fail-on-regression` — the step fails (and blocks merging) if any metric regresses by more than 10%.
4. Uploads both JSON profiles as downloadable artefacts for review.

## Tuning the regression threshold

Set `SOROSCOPE_REGRESSION_THRESHOLD=5` in the step environment to tighten the allowed regression to 5%.
