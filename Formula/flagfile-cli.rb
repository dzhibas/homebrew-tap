class FlagfileCli < Formula
  desc "CLI tool for managing and evaluating Flagfile feature flags"
  homepage "https://github.com/dzhibas/flagfile"
  version "0.1.30"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/dzhibas/flagfile/releases/download/v0.1.30/flagfile-cli-aarch64-apple-darwin.tar.xz"
      sha256 "fb7116ec15cd8d2c8189efb65494a9b1f9deae825f9e730d7a48ee866bfbff08"
    end
    if Hardware::CPU.intel?
      url "https://github.com/dzhibas/flagfile/releases/download/v0.1.30/flagfile-cli-x86_64-apple-darwin.tar.xz"
      sha256 "dbb1e38b978c46b744bcef9d0d471220add7d50cd40eb99668db946e335c70b8"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/dzhibas/flagfile/releases/download/v0.1.30/flagfile-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "f8eca0732d8903432777fe0c60ffce3a7d696487ed6550d38d6c6a9e41284182"
    end
    if Hardware::CPU.intel?
      url "https://github.com/dzhibas/flagfile/releases/download/v0.1.30/flagfile-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "110d3094d8d7424579e33e96263837b7c38f5c5de76112952b0c3755de823b38"
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
    bin.install "ff", "flagfile" if OS.mac? && Hardware::CPU.arm?
    bin.install "ff", "flagfile" if OS.mac? && Hardware::CPU.intel?
    bin.install "ff", "flagfile" if OS.linux? && Hardware::CPU.arm?
    bin.install "ff", "flagfile" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
