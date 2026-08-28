# Homebrew Tap for AIVCS

Official Homebrew tap for [AIVCS](https://aivcs.io) — the AI Version Control System.

## Installation

```bash
brew install aivcs-io/tap/aivcs
```

Or tap first:

```bash
brew tap aivcs-io/tap
brew install aivcs
```

Installs pour a **prebuilt binary** from the matching [aivcs release](https://github.com/aivcs-io/aivcs/releases) (Apple Silicon macOS, Linux amd64/arm64). No local Rust compile.

## Supply-chain gates (required before merge)

Every formula bump must pass:

| Gate | Tool | Policy |
|------|------|--------|
| Checksum verify | `SHA256SUMS` from release | All platform assets must match |
| Secret scan (repo) | gitleaks | Fail closed on credential patterns |
| Secret scan (binary) | strings + pattern match | Block embedded tokens/keys (GitHub, AWS, PEM, etc.) |
| SBOM | Syft → CycloneDX JSON | Uploaded as CI artifact per version |
| Vulnerability scan | Grype on SBOM | Block merge on **high+** severity |

Governance references: `aivcs://aivcs/code-governance` → `security/standards/ci-cd-baseline.md` §6, preflight secret scan (#1306).

## Updating the formula after a release

1. Publish binaries + `SHA256SUMS` on `aivcs-io/aivcs` (tag `vX.Y.Z`).
2. Attach SBOM assets to the GitHub release when available (`*.cdx.json` / SPDX).
3. Run **update-formula-binaries** on this repo (`workflow_dispatch` with version `X.Y.Z`), or send `repository_dispatch` type `aivcs-release` with `client_payload.version`.
4. Merge the PR only when **tap-pr-gate** is green.
