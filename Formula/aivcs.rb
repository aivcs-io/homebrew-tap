# typed: false
# frozen_string_literal: true

class Aivcs < Formula
  desc "AI Version Control System for Autonomous Agent Swarms"
  homepage "https://aivcs.io"
  url "https://github.com/aivcs-io/aivcs/archive/refs/tags/v0.4.2.tar.gz"
  sha256 "3d3833080b46ab85131c6951e12debf4a567207034cd09dcfdb6fd26d8431d12"
  license "Apache-2.0"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/aivcs-cli")
  end

  test do
    system bin/"aivcs", "--help"
  end
end
