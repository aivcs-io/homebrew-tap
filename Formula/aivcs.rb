# typed: false
# frozen_string_literal: true

class Aivcs < Formula
  desc "AI Version Control System for Autonomous Agent Swarms"
  homepage "https://aivcs.io"
  version "0.5.0"
  license "Apache-2.0"

  # Prebuilt release binaries from https://github.com/aivcs-io/aivcs/releases
  # SHA256 placeholders replaced at cut time to match SHA256SUMS.

  on_macos do
    on_arm do
      url "https://github.com/aivcs-io/aivcs/releases/download/v#{version}/aivcs-darwin-arm64"
      sha256 "3270e03e9e7569b20be4282d6b3c6d065f80d1a47231af06f447a6a7838f14a7"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/aivcs-io/aivcs/releases/download/v#{version}/aivcs-linux-arm64"
      sha256 "7fd5a038851d6d58c16ff75bb44c8a44a730c2759cdd75b77f8943d8c6d48899"
    end
    on_intel do
      url "https://github.com/aivcs-io/aivcs/releases/download/v#{version}/aivcs-linux-x86_64"
      sha256 "acad047708a6bc20c8f874e3b896160a6a7a68faa1ba1c69efc2895647ea1918"
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
