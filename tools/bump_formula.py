#!/usr/bin/env python3
"""Rewrite Formula/aivcs.rb from aivcs-io/aivcs release SHA256SUMS."""
from __future__ import annotations

import os
import re
import sys
import urllib.request
from pathlib import Path

FORMULA = Path("Formula/aivcs.rb")
RELEASE_REPO = os.environ.get("AIVCS_RELEASE_REPO", "aivcs-io/aivcs")


def die(msg: str) -> None:
    print(f"bump-formula: {msg}", file=sys.stderr)
    sys.exit(1)


def main() -> None:
    version = os.environ.get("AIVCS_VERSION", "").lstrip("v")
    if not version:
        die("set AIVCS_VERSION (e.g. 0.4.4)")

    tag = f"v{version}"
    url = f"https://github.com/{RELEASE_REPO}/releases/download/{tag}/SHA256SUMS"
    with urllib.request.urlopen(url) as resp:
        sums = resp.read().decode()

    def sha(name: str) -> str:
        m = re.search(rf"^([0-9a-f]{{64}})\s+{re.escape(name)}\s*$", sums, re.M)
        if not m:
            die(f"missing {name} in SHA256SUMS")
        return m.group(1)

    d, la, lx = sha("aivcs-darwin-arm64"), sha("aivcs-linux-arm64"), sha("aivcs-linux-x86_64")
    text = f"""# typed: false
# frozen_string_literal: true

class Aivcs < Formula
  desc "AI Version Control System for Autonomous Agent Swarms"
  homepage "https://aivcs.io"
  version "{version}"
  license "Apache-2.0"

  # Prebuilt release binaries from https://github.com/aivcs-io/aivcs/releases

  on_macos do
    on_arm do
      url "https://github.com/aivcs-io/aivcs/releases/download/v#{{version}}/aivcs-darwin-arm64"
      sha256 "{d}"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/aivcs-io/aivcs/releases/download/v#{{version}}/aivcs-linux-arm64"
      sha256 "{la}"
    end
    on_intel do
      url "https://github.com/aivcs-io/aivcs/releases/download/v#{{version}}/aivcs-linux-x86_64"
      sha256 "{lx}"
    end
  end

  def install
    binary = if OS.mac?
      "aivcs-darwin-arm64"
    elsif Hardware::CPU.arm?
      "aivcs-linux-arm64"
    else
      "aivcs-linux-x86_64"
    end
    bin.install binary => "aivcs"
  end

  test do
    out = shell_output("#{{bin}}/aivcs --version")
    assert_match(/\\A[a-z]+ \\d+\\.\\d+\\.\\d+\\z/, out.strip)
  end
end
"""
    FORMULA.write_text(text)
    print(f"bump-formula: wrote {FORMULA} for {version}")


if __name__ == "__main__":
    main()
