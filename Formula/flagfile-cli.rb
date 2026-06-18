class FlagfileCli < Formula
  desc "CLI tool for managing and evaluating Flagfile feature flags"
  homepage "https://github.com/dzhibas/flagfile"
  version "0.1.28"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/dzhibas/flagfile/releases/download/v0.1.28/flagfile-cli-aarch64-apple-darwin.tar.xz"
      sha256 "602a3a89729011df0b909a08459be05442f7c959f40fcd3856e1fa9dd39e9025"
    end
    if Hardware::CPU.intel?
      url "https://github.com/dzhibas/flagfile/releases/download/v0.1.28/flagfile-cli-x86_64-apple-darwin.tar.xz"
      sha256 "7ca05113e6b5425ff264eaf32dfef59617b40b0f99ffe142ac7ed683d9a31605"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/dzhibas/flagfile/releases/download/v0.1.28/flagfile-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "b774c53ada681c14a7a86bff97f87fd5c988918eff1fca5d46b351f24164a4eb"
    end
    if Hardware::CPU.intel?
      url "https://github.com/dzhibas/flagfile/releases/download/v0.1.28/flagfile-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "664db099362565b0398ce99dd00b5a62246ae47becc87edd732f290caab6a2a3"
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
