class FlagfileCli < Formula
  desc "CLI tool for managing and evaluating Flagfile feature flags"
  homepage "https://github.com/dzhibas/flagfile"
  version "0.1.31"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/dzhibas/flagfile/releases/download/v0.1.31/flagfile-cli-aarch64-apple-darwin.tar.xz"
      sha256 "971c7dcce4f8fc4ddc664247857bec4a0e1989a025123204a7d48f36590127fc"
    end
    if Hardware::CPU.intel?
      url "https://github.com/dzhibas/flagfile/releases/download/v0.1.31/flagfile-cli-x86_64-apple-darwin.tar.xz"
      sha256 "d24ef8a1ef8b78a0b22566ccd70cfd0961b087d7676b3c1078bedc8d98278bc1"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/dzhibas/flagfile/releases/download/v0.1.31/flagfile-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "8f3b240c057ab23afee7e5ab2e3cbf7ede5c6f67262f7c761d472f599240438d"
    end
    if Hardware::CPU.intel?
      url "https://github.com/dzhibas/flagfile/releases/download/v0.1.31/flagfile-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "4a851449bb58eb82458581b5be9ad45e15674d73ecee6d9fd5887208d059dcbf"
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
