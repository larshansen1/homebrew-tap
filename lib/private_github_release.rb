# frozen_string_literal: true

require "download_strategy"
require "json"
require "net/http"
require "uri"

# Downloads release assets from a private GitHub repository using
# HOMEBREW_GITHUB_API_TOKEN or an authenticated `gh` CLI session.
class PrivateGitHubReleaseDownloadStrategy < CurlDownloadStrategy
  def initialize(url, name, version, **meta)
    super
    @owner, @repo, @tag, @filename = parse_release_url(url)
  end

  private

  def parse_release_url(url)
    match = url.match(%r{\Ahttps://github\.com/([^/]+)/([^/]+)/releases/download/([^/]+)/(.+)\z})
    raise CurlDownloadStrategyError.new(url, "Invalid GitHub release URL") unless match

    match.captures
  end

  def resolve_github_token
    token = ENV["HOMEBREW_GITHUB_API_TOKEN"].to_s.strip
    return token unless token.empty?

    gh = ["/opt/homebrew/bin/gh", "/usr/local/bin/gh", "/usr/bin/gh"].find { |p| File.executable?(p) }
    if gh
      out = IO.popen([gh, "auth", "token"], err: File::NULL, &:read).to_s.strip
      return out if $?.success? && !out.empty?
    end

    raise CurlDownloadStrategyError.new(
      url,
      "GitHub auth required for private repo #{@owner}/#{@repo}. " \
      "Run `gh auth login` or set HOMEBREW_GITHUB_API_TOKEN.",
    )
  end

  def resolve_asset_api_url(token)
    uri = URI("https://api.github.com/repos/#{@owner}/#{@repo}/releases/tags/#{@tag}")
    req = Net::HTTP::Get.new(uri)
    req["Authorization"] = "Bearer #{token}"
    req["Accept"] = "application/vnd.github+json"
    req["X-GitHub-Api-Version"] = "2022-11-28"
    req["User-Agent"] = "Homebrew"

    res = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) { |http| http.request(req) }
    unless res.is_a?(Net::HTTPSuccess)
      raise CurlDownloadStrategyError.new(
        url,
        "GitHub API returned #{res.code} for #{@owner}/#{@repo}@#{@tag} (check token repo access)",
      )
    end

    release = JSON.parse(res.body)
    asset = release.fetch("assets", []).find { |a| a["name"] == @filename }
    raise CurlDownloadStrategyError.new(url, "Asset #{@filename} not found in release #{@tag}") unless asset

    asset.fetch("url")
  end

  def resolve_url_basename_time_file_size(url, timeout: nil)
    [url, @filename, nil, nil, nil, false]
  end

  def _fetch(url:, resolved_url:, timeout:)
    token = resolve_github_token
    asset_url = resolve_asset_api_url(token)
    curl_download(
      asset_url,
      "--header", "Authorization: Bearer #{token}",
      "--header", "Accept: application/octet-stream",
      "--header", "X-GitHub-Api-Version: 2022-11-28",
      to: temporary_path,
      timeout: timeout,
    )
  end
end
