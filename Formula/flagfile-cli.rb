class FlagfileCli < Formula
  desc "CLI tool for managing and evaluating Flagfile feature flags"
  homepage "https://github.com/dzhibas/flagfile"
  version "0.1.14"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/dzhibas/flagfile/releases/download/v0.1.14/flagfile-cli-aarch64-apple-darwin.tar.xz"
      sha256 "1f52ce7c57e9baef1e709ea2d1cac4e73b61caee48c3f6cbd4e67fb9e5135d8f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/dzhibas/flagfile/releases/download/v0.1.14/flagfile-cli-x86_64-apple-darwin.tar.xz"
      sha256 "eca636cff6a963e229c57ff350cf76c5eb2b39e6c7672ee67c309fcecf4e8e2c"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/dzhibas/flagfile/releases/download/v0.1.14/flagfile-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "02bce104d1f5b262ddac9e64753cf5740305548fa1d3414b5e7d9f6c2e0433bd"
    end
    if Hardware::CPU.intel?
      url "https://github.com/dzhibas/flagfile/releases/download/v0.1.14/flagfile-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "8dac80819aa9d6364f820d6c81ca53edc6d1912c0fdaf85ec40f6450b6469e55"
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
