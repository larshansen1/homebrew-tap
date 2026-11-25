require_relative "../lib/private_github_release"

class KaiRs < Formula
  desc "Rust edition of the kai CLI and local HTTP service for Obsidian vaults"
  homepage "https://github.com/larshansen1/obsidian-ai-tools"
  version "1.1.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/larshansen1/obsidian-ai-tools/releases/download/kai-rs-v1.1.0/kai-rs-1.1.0-aarch64-apple-darwin.tar.gz",
          using: PrivateGitHubReleaseDownloadStrategy
      sha256 "45394300cf4f7c1f7c9a13ba53ef69917e0d0666336b792914dee1c2edbce3e0"
    end
    on_intel do
      url "https://github.com/larshansen1/obsidian-ai-tools/releases/download/kai-rs-v1.1.0/kai-rs-1.1.0-x86_64-apple-darwin.tar.gz",
          using: PrivateGitHubReleaseDownloadStrategy
      sha256 "b3c9bddde79908db26ff1a55e8810f231efacf93b1d5d0b58d39f2f27a3b34ef"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/larshansen1/obsidian-ai-tools/releases/download/kai-rs-v1.1.0/kai-rs-1.1.0-aarch64-unknown-linux-gnu.tar.gz",
          using: PrivateGitHubReleaseDownloadStrategy
      sha256 "c6c52dc19f14525954dfa9b0943d2b6604043c9dc6cef273eb6b82922472f6f3"
    end
    on_intel do
      url "https://github.com/larshansen1/obsidian-ai-tools/releases/download/kai-rs-v1.1.0/kai-rs-1.1.0-x86_64-unknown-linux-gnu.tar.gz",
          using: PrivateGitHubReleaseDownloadStrategy
      sha256 "9bb3192dab95213c087300eee2f60d8593ddef842624185005ea47cbe1b9555f"
    end
  end

  def install
    bin.install "kai-rs"
  end

  test do
    assert_match "obsidian-ai-tools v#{version}", shell_output("#{bin}/kai-rs version")
  end
end
