# typed: false
# frozen_string_literal: true

class Aivcs < Formula
  desc "AI Version Control System for Autonomous Agent Swarms"
  homepage "https://aivcs.io"
  url "https://github.com/aivcs-io/aivcs/archive/refs/tags/v0.4.2.tar.gz"
  version "0.4.2"
  sha256 "0012e49893e2e3ad289a62add3325c080dbee32b2e039fdbd9859c1ffed75283"
  license "Apache-2.0"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/aivcs-cli")
  end

  test do
    system "#{bin}/aivcs", "--help"
  end
end
