#!/usr/bin/env python3
"""Supply-chain gate for homebrew-tap formula bumps (propel check).

Verifies release checksums, scans for embedded credentials, generates SBOM,
and runs Grype. Aligns with code-governance ci-cd-baseline §6.
"""
from __future__ import annotations

import json
import os
import re
import subprocess
import sys
import tempfile
import urllib.request
from pathlib import Path

FORMULA = Path("Formula/aivcs.rb")
RELEASE_REPO = os.environ.get("AIVCS_RELEASE_REPO", "aivcs-io/aivcs")
GRYPE_SEVERITY = os.environ.get("GRYPE_FAIL_ON", "high")

CREDENTIAL_PATTERNS: list[tuple[str, str]] = [
    (r"gho_[A-Za-z0-9_]{20,}", "GitHub OAuth token"),
    (r"ghp_[A-Za-z0-9_]{20,}", "GitHub PAT"),
    (r"github_pat_[A-Za-z0-9_]{20,}", "GitHub fine-grained PAT"),
    (r"glpat-[A-Za-z0-9\-_]{20,}", "GitLab PAT"),
    (r"AKIA[0-9A-Z]{16}", "AWS access key id"),
    (r"sk-ant-[A-Za-z0-9\-_]{20,}", "Anthropic API key"),
    (r"AIza[0-9A-Za-z\-_]{30,}", "Google API key"),
    (r"-----BEGIN (?:RSA |EC |OPENSSH )?PRIVATE KEY-----", "PEM private key"),
]


def die(msg: str) -> None:
    print(f"tap-release-gate: {msg}", file=sys.stderr)
    sys.exit(1)


def run(cmd: list[str], *, cwd: Path | None = None) -> None:
    print("+", " ".join(cmd))
    subprocess.run(cmd, cwd=cwd, check=True)


def formula_version() -> str:
    text = FORMULA.read_text()
    m = re.search(r'^\s*version\s+"([^"]+)"', text, re.M)
    if not m:
        die(f"could not parse version from {FORMULA}")
    return m.group(1)


def download(url: str, dest: Path) -> None:
    dest.parent.mkdir(parents=True, exist_ok=True)
    with urllib.request.urlopen(url) as resp, dest.open("wb") as out:
        out.write(resp.read())


def verify_sha256sums(workdir: Path, assets: list[str]) -> None:
    sums_path = workdir / "SHA256SUMS"
    run(["sha256sum", "-c", str(sums_path)], cwd=workdir)
    for name in assets:
        if not (workdir / name).is_file():
            die(f"missing asset after download: {name}")


def scan_binary_strings(binary: Path) -> None:
    proc = subprocess.run(
        ["strings", str(binary)],
        check=True,
        capture_output=True,
        text=True,
    )
    hits = [label for pat, label in CREDENTIAL_PATTERNS if re.search(pat, proc.stdout)]
    if hits:
        for label in hits:
            print(f"credential pattern in binary: {label}", file=sys.stderr)
        die("embedded credential-like material detected in release binary")


def main() -> None:
    if not FORMULA.is_file():
        die(f"{FORMULA} not found")

    version = formula_version()
    tag = f"v{version}"
    base = f"https://github.com/{RELEASE_REPO}/releases/download/{tag}"
    assets = ["aivcs-linux-x86_64", "aivcs-linux-arm64", "aivcs-darwin-arm64"]

    with tempfile.TemporaryDirectory(prefix="tap-gate-") as tmp:
        work = Path(tmp)
        download(f"{base}/SHA256SUMS", work / "SHA256SUMS")
        for asset in assets:
            download(f"{base}/{asset}", work / asset)
        verify_sha256sums(work, assets)

        linux_bin = work / "aivcs-linux-x86_64"
        scan_binary_strings(linux_bin)

        sbom = work / "sbom.cdx.json"
        run(["syft", str(linux_bin), "-o", f"cyclonedx-json={sbom}"])

        grype_args = [
            "grype",
            f"sbom:{sbom}",
            "--fail-on",
            GRYPE_SEVERITY,
        ]
        run(grype_args)

        out_dir = Path(os.environ.get("TAP_GATE_ARTIFACT_DIR", "artifacts"))
        out_dir.mkdir(parents=True, exist_ok=True)
        (out_dir / f"sbom-aivcs-{version}.cdx.json").write_text(sbom.read_text())
        manifest = {
            "version": version,
            "tag": tag,
            "assets": assets,
            "sbom": str(out_dir / f"sbom-aivcs-{version}.cdx.json"),
            "grype_fail_on": GRYPE_SEVERITY,
        }
        (out_dir / f"tap-gate-{version}.json").write_text(json.dumps(manifest, indent=2) + "\n")

    print(f"tap-release-gate: ok for aivcs {version}")


if __name__ == "__main__":
    main()
