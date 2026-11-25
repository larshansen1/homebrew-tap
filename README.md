# homebrew-tap

Homebrew formulae for `larshansen1` tools.

## Install `kai-rs`

Because `larshansen1/obsidian-ai-tools` is a private repository, Homebrew needs a GitHub token
with read access to it. Either sign in with the GitHub CLI (`gh auth login`), or pass
`HOMEBREW_GITHUB_API_TOKEN`:

```bash
brew install larshansen1/tap/kai-rs
# Or explicitly:
HOMEBREW_GITHUB_API_TOKEN=$(gh auth token) brew install larshansen1/tap/kai-rs
```

Upgrade later with:

```bash
brew upgrade kai-rs
```
