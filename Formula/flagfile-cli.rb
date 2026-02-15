class FlagfileCli < Formula
  desc "CLI tool for managing and evaluating Flagfile feature flags"
  homepage "https://github.com/dzhibas/flagfile"
  version "0.1.21"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/dzhibas/flagfile/releases/download/v0.1.21/flagfile-cli-aarch64-apple-darwin.tar.xz"
      sha256 "b40264c6abd1305541c56a20d150108e338c5fc066f893afed43aa25fe0970cd"
    end
    if Hardware::CPU.intel?
      url "https://github.com/dzhibas/flagfile/releases/download/v0.1.21/flagfile-cli-x86_64-apple-darwin.tar.xz"
      sha256 "67ff5092edbf1f5341535a19d5131e63c028eff2f5b194820d786e8b4abea35a"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/dzhibas/flagfile/releases/download/v0.1.21/flagfile-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "44d8d36a70025afa79b45c13955b954757d3ed7805c14d1eff6beae4770c546c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/dzhibas/flagfile/releases/download/v0.1.21/flagfile-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "11e87393b20212f6dcfd57e6e89ce59cca44e954639b7d3aade247684ff73763"
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
