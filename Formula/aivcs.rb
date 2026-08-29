# typed: false
# frozen_string_literal: true

class Aivcs < Formula
  desc "AI Version Control System for Autonomous Agent Swarms"
  homepage "https://github.com/aivcs-io/aivcs"
  version "0.5.2"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/aivcs-io/aivcs/releases/download/v#{version}/aivcs-darwin-arm64"
      sha256 "b08bc2adf893292094a3e5f7da2849d58ad4d30afb4bcfd18f403090e2b0f8c8"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/aivcs-io/aivcs/releases/download/v#{version}/aivcs-linux-arm64"
      sha256 "e53362214295d666184caf0e48358825d1788be7a20d0006d98d18c72160d9c2"
    end
    on_intel do
      url "https://github.com/aivcs-io/aivcs/releases/download/v#{version}/aivcs-linux-x86_64"
      sha256 "3a480b63f6f4063723e1aec5b39a68273e6e7d12144cfb2ada5a068e8030aed7"
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
