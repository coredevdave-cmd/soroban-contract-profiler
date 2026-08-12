# Security Policy

## Supported Versions

| Version | Supported |
|---------|-----------|
| 0.3.x   | Yes       |
| 0.2.x   | Critical fixes only |
| < 0.2   | No        |

## Reporting a Vulnerability

**Please do not open a public GitHub issue for security vulnerabilities.**

Report security issues by emailing **security@soroscope.dev** (or open a [GitHub Security Advisory](https://github.com/coredevdave-cmd/soroban-contract-profiler/security/advisories/new) if you prefer).

Include:

1. A description of the vulnerability and its potential impact.
2. Steps to reproduce or a minimal proof-of-concept.
3. The Soroscope version and operating system you tested on.

You will receive an acknowledgement within **48 hours** and a status update within **7 days**.

## Scope

The following are in scope:

- The `soroscope` CLI binary and its dependencies.
- The `core/` Rust library crates.
- The Next.js web UI (`web/`), especially anything related to file upload handling or WebAssembly execution.

The following are **out of scope**:

- Vulnerabilities in the upstream Soroban host or Stellar protocol — report those to the [Stellar Bug Bounty](https://www.stellar.org/bug-bounty-program).
- Issues that require physical access to the machine running Soroscope.

## Disclosure Timeline

We aim to release a patch within **14 days** of a confirmed vulnerability and to publish a public disclosure within **90 days** of the initial report, regardless of patch status.
