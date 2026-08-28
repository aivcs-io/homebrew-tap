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
      sha256 "dd6110fac9d4e39d9a34dffc407c3177e0e4bb6e68f9664dc825fb65aa46ffeb"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/aivcs-io/aivcs/releases/download/v#{version}/aivcs-linux-arm64"
      sha256 "31997217c5906df7e0614f14f08547a7bb99c4e9f5f827894e3c17c2e20395ab"
    end
    on_intel do
      url "https://github.com/aivcs-io/aivcs/releases/download/v#{version}/aivcs-linux-x86_64"
      sha256 "c757692e429efdedb7404bacb6261af9421a5d19677cbab1f09061f9b5bd9456"
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
