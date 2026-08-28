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

## CI — aivcs-propel (not GitHub Actions)

Checks are declared in `propel.toml` and executed by **sandlot / aivcs-propel** on the sovereign build rail.

```bash
# Local (requires nix)
nix develop --command aivcs-propel pipeline
```

| Check | What it does |
|-------|----------------|
| `secret-scan` | gitleaks — blocks credential commits |
| `formula-syntax` | Ruby syntax check on `Formula/aivcs.rb` |
| `tap-release-gate` | SHA256SUMS verify, binary strings scan, Syft SBOM, Grype (high+) |

Governance: `aivcs://aivcs/code-governance` → `security/standards/ci-cd-baseline.md` §6, preflight secret scan (#1306).

SBOM artifacts land in `artifacts/` when `TAP_GATE_ARTIFACT_DIR` is set (sandlot workspace).

## Updating the formula after an aivcs release

1. Publish binaries + `SHA256SUMS` on `aivcs-io/aivcs` (tag `vX.Y.Z`).
2. Bump the formula from verified checksums:

```bash
AIVCS_VERSION=0.4.4 nix run .#bump-formula
```

3. Open PR → **aivcs-propel check** must pass (sandlot dispatches on PR).
4. Merge when green.

Do **not** use GitHub Actions for tap gates — propel + Nix are the SoT.
