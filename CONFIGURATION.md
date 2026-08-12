# Configuration Reference

Soroscope reads configuration from (in order of precedence):

1. CLI flags
2. Environment variables
3. `soroscope.toml` in the current directory
4. `~/.config/soroscope/config.toml`

---

## soroscope.toml

```toml
# soroscope.toml — project-level config

[profiler]
# Default output format: "table" | "json" | "csv"
output = "table"

# Number of simulated invocations when running benchmarks
bench_iterations = 100

# Fail with a non-zero exit code if CPU instructions exceed this budget.
# 0 = no limit.
cpu_budget = 0

[rpc]
# Stellar RPC endpoint used by the --rpc flag.
# Leave empty to disable live ledger fetching.
endpoint = ""

# Timeout in seconds for RPC requests.
timeout_secs = 10

[web]
# Port for the local web UI dev server.
port = 3000

# Whether to open the browser automatically on `soroscope serve`.
open_browser = true
```

---

## Environment Variables

| Variable | Default | Description |
|----------|---------|-------------|
| `SOROSCOPE_OUTPUT` | `table` | Output format (`table`, `json`, `csv`) |
| `SOROSCOPE_RPC_ENDPOINT` | *(empty)* | Stellar RPC URL |
| `SOROSCOPE_RPC_TIMEOUT` | `10` | RPC timeout in seconds |
| `SOROSCOPE_CPU_BUDGET` | `0` | CPU instruction budget (0 = unlimited) |
| `SOROSCOPE_LOG` | `warn` | Log level (`error`, `warn`, `info`, `debug`, `trace`) |
| `SOROSCOPE_WEB_PORT` | `3000` | Web UI port |
| `RUST_LOG` | *(unset)* | Overrides `SOROSCOPE_LOG` for library-level logging |

---

## CLI Flags

Run `soroscope --help` for a full flag reference. Key flags:

```
soroscope profile [OPTIONS] <WASM>

OPTIONS:
    --output <FORMAT>           Output format [default: table]
    --rpc <URL>                 Fetch ledger state from this RPC endpoint
    --mock-contract <ADDR=PATH> Stub a dependency contract
    --cpu-budget <N>            Fail if instructions exceed N (0 = off)
    --json                      Alias for --output json
    --csv                       Alias for --output csv
```
