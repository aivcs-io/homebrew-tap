# typed: false
# frozen_string_literal: true

class Aivcs < Formula
  desc "AI Version Control System for Autonomous Agent Swarms"
  homepage "https://aivcs.io"
  version "0.4.5"
  license "Apache-2.0"

  # Prebuilt release binaries from https://github.com/aivcs-io/aivcs/releases
  # (pour — no local Rust compile). Source tarball remains available upstream
  # for anyone who wants to build from source outside Homebrew.

  on_macos do
    on_arm do
      url "https://github.com/aivcs-io/aivcs/releases/download/v#{version}/aivcs-darwin-arm64"
      sha256 "2fd5cb4434be7448dd8d2683c669de315cf3672be3ebb0dcf7777de32c7f52df"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/aivcs-io/aivcs/releases/download/v#{version}/aivcs-linux-arm64"
      sha256 "a4344afe9d8013b9884a5a097af45b140df261d984ef49f0e54c77f0958faf67"
    end
    on_intel do
      url "https://github.com/aivcs-io/aivcs/releases/download/v#{version}/aivcs-linux-x86_64"
      sha256 "4acf6c938f53cb69f7c4284d96176265a5cc288fd4b0e3774cd0207afbcdc46b"
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
