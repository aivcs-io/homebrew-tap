# typed: false
# frozen_string_literal: true

class Aivcs < Formula
  desc "AI Version Control System for Autonomous Agent Swarms"
  homepage "https://aivcs.io"
  version "0.4.4"
  license "Apache-2.0"

  # Prebuilt release binaries from https://github.com/aivcs-io/aivcs/releases
  # (pour — no local Rust compile). Source tarball remains available upstream
  # for anyone who wants to build from source outside Homebrew.

  on_macos do
    on_arm do
      url "https://github.com/aivcs-io/aivcs/releases/download/v#{version}/aivcs-darwin-arm64"
      sha256 "e22a4353948633f3de68690776715fee0b3c1a7dc3e5213a6811196699d672bd"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/aivcs-io/aivcs/releases/download/v#{version}/aivcs-linux-arm64"
      sha256 "0972d6bfdbdb94df8e51af79eb8555ec26a85d12db9ffb4ff9b06be053a1e30f"
    end
    on_intel do
      url "https://github.com/aivcs-io/aivcs/releases/download/v#{version}/aivcs-linux-x86_64"
      sha256 "55e4693027feec4998cd1221de246f0babdc51436409e13c3d37e63d1a0861ab"
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
    assert_match version.to_s, shell_output("#{bin}/aivcs --version")
  end
end
