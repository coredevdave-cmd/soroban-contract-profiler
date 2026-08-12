# CLI Reference

## Global options

```
soroscope [OPTIONS] <SUBCOMMAND>

OPTIONS:
    -v, --verbose       Increase log verbosity (repeat for more: -vv, -vvv)
    -q, --quiet         Suppress all non-error output
        --config <PATH> Use a specific config file instead of soroscope.toml
    -h, --help          Print help information
    -V, --version       Print version information
```

---

## `soroscope profile`

Profile a single compiled contract.

```
soroscope profile [OPTIONS] <WASM>

ARGS:
    <WASM>    Path to the compiled .wasm file

OPTIONS:
    -o, --output <FORMAT>           Output format: table | json | csv [default: table]
    -f, --function <NAME>           Only profile this exported function [default: all]
        --rpc <URL>                 Fetch ledger state from this Stellar RPC endpoint
        --mock-contract <ADDR=PATH> Stub a dependency; repeat for multiple contracts
        --cpu-budget <N>            Fail if instructions exceed N (0 = disabled) [default: 0]
        --args <JSON>               JSON-encoded invocation arguments
    -h, --help                      Print help information

EXAMPLES:
    soroscope profile contracts/token/token.wasm
    soroscope profile --output json contracts/amm/amm.wasm
    soroscope profile --function transfer --args '["GABC...", "GDEF...", 1000]' token.wasm
```

---

## `soroscope compare`

Compare the profiling output of two `.wasm` builds.

```
soroscope compare [OPTIONS] --before <WASM> --after <WASM>

OPTIONS:
    --before <WASM>     Path to the baseline .wasm file
    --after <WASM>      Path to the candidate .wasm file
    -o, --output <FORMAT>  Output format: table | json | csv [default: table]
    --fail-on-regression   Exit with code 1 if any metric regresses
    -h, --help

EXAMPLES:
    soroscope compare --before v1.wasm --after v2.wasm
    soroscope compare --before v1.wasm --after v2.wasm --fail-on-regression
```

---

## `soroscope benchmark`

Run a contract function N times and report aggregate statistics.

```
soroscope benchmark [OPTIONS] <WASM>

OPTIONS:
    -n, --iterations <N>    Number of invocations [default: 100]
    -f, --function <NAME>   Function to benchmark [default: first exported function]
        --args <JSON>       JSON-encoded invocation arguments
    -o, --output <FORMAT>   Output format: table | json | csv [default: table]
    -h, --help

EXAMPLES:
    soroscope benchmark -n 500 contracts/math/math.wasm
```

---

## `soroscope serve`

Launch the local web UI.

```
soroscope serve [OPTIONS]

OPTIONS:
    -p, --port <PORT>   Port to listen on [default: 3000]
        --no-open       Do not open the browser automatically
    -h, --help
```
