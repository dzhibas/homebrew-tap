class FlagfileCli < Formula
  desc "CLI tool for managing and evaluating Flagfile feature flags"
  homepage "https://github.com/dzhibas/flagfile"
  version "0.1.36"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/dzhibas/flagfile/releases/download/v0.1.36/flagfile-cli-aarch64-apple-darwin.tar.xz"
      sha256 "14c588d929d9a169e80fecdd02fbacd41eb53a5701d5c52547f2e853eaea6779"
    end
    if Hardware::CPU.intel?
      url "https://github.com/dzhibas/flagfile/releases/download/v0.1.36/flagfile-cli-x86_64-apple-darwin.tar.xz"
      sha256 "1bf43325c1878981d264df9b5f5127f993e00f5031e26a97ffa33632c23f5acc"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/dzhibas/flagfile/releases/download/v0.1.36/flagfile-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "d12e406cd0eb3f6ef517dec307d30d9cdb8cf694ed6dbedcec7c3a880f3ca01f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/dzhibas/flagfile/releases/download/v0.1.36/flagfile-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "a7175ddcc245ab083e06b1a7f960464e79f268c0d5b249b9271e50203b09058e"
    end
  end

  BINARY_ALIASES = {
    "aarch64-apple-darwin":              {},
    "aarch64-unknown-linux-gnu":         {},
    "x86_64-apple-darwin":               {},
    "x86_64-unknown-linux-gnu":          {},
    "x86_64-unknown-linux-musl-dynamic": {},
    "x86_64-unknown-linux-musl-static":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    if OS.mac? && Hardware::CPU.arm?
      bin.install "ff", "flagfile"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "ff", "flagfile"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "ff", "flagfile"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "ff", "flagfile"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
