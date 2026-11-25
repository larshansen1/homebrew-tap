require_relative "../lib/private_github_release"

class KaiRs < Formula
  desc "Rust edition of the kai CLI and local HTTP service for Obsidian vaults"
  homepage "https://github.com/larshansen1/obsidian-ai-tools"
  version "1.1.1"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/larshansen1/obsidian-ai-tools/releases/download/kai-rs-v1.1.1/kai-rs-1.1.1-aarch64-apple-darwin.tar.gz",
          using: PrivateGitHubReleaseDownloadStrategy
      sha256 "7c5a1a9125edfe062d3615a5dd8ac8c30899d158c2b4a27af39b3ac2ebfe10ab"
    end
    on_intel do
      url "https://github.com/larshansen1/obsidian-ai-tools/releases/download/kai-rs-v1.1.1/kai-rs-1.1.1-x86_64-apple-darwin.tar.gz",
          using: PrivateGitHubReleaseDownloadStrategy
      sha256 "3d094c2fc6ca292fdba3f0994f2591a6f86eede4c6bee78353f189eb901131b0"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/larshansen1/obsidian-ai-tools/releases/download/kai-rs-v1.1.1/kai-rs-1.1.1-aarch64-unknown-linux-gnu.tar.gz",
          using: PrivateGitHubReleaseDownloadStrategy
      sha256 "fc79f9613e14c9a49d0aaf6e7a1295dddd00c0675379e575bf491c3672809e20"
    end
    on_intel do
      url "https://github.com/larshansen1/obsidian-ai-tools/releases/download/kai-rs-v1.1.1/kai-rs-1.1.1-x86_64-unknown-linux-gnu.tar.gz",
          using: PrivateGitHubReleaseDownloadStrategy
      sha256 "d86a157ee2e04ea0bb6de85a5c1628376795684e789d968403b5114658c6978d"
    end
  end

  def install
    bin.install "kai-rs"
  end

  test do
    assert_match "obsidian-ai-tools v#{version}", shell_output("#{bin}/kai-rs version")
  end
end
