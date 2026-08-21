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

## Updating the formula after a release

1. Publish binaries + `SHA256SUMS` on `aivcs-io/aivcs` (tag `vX.Y.Z`).
2. Run **update-formula-binaries** on this repo (`workflow_dispatch` with version `X.Y.Z`), or send `repository_dispatch` type `aivcs-release` with `client_payload.version`.
3. Merge the PR.
