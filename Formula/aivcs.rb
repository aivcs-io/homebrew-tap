# typed: false
# frozen_string_literal: true

class Aivcs < Formula
  desc "AI Version Control System for Autonomous Agent Swarms"
  homepage "https://aivcs.io"
  url "https://github.com/aivcs-io/aivcs/archive/refs/tags/v0.4.3.tar.gz"
  sha256 "623804366e44bc82f3236599f5ac6a61f096b90ae6cda15f6ff823684bb4db5d"
  license "Apache-2.0"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/aivcs-cli")
  end

  test do
    system bin/"aivcs", "--help"
  end
end
