# frozen_string_literal: true

require "utils"

# 󰞷 GithubRelease.new "JetBrains/JetBrainsMono", "JetBrainsMono-%s.zip"
# 󰶻 #<GithubRelease:0x00007f0a9f6bc410
#  @archive_name  = "JetBrainsMono-2.304.zip",
#  @file_basename = "JetBrainsMono-2.304",
#  @file_ext      = "zip",
#  @repo          = "JetBrains/JetBrainsMono",
#  @version       = "2.304">
#
class GithubRelease
  attr_reader :repo, :version, :archive_name, :file_basename, :file_ext

  def initialize(repo, archive_name, version = nil)
    @repo = repo
    @version = version || latest_version

    file_basename, @file_ext = archive_name.split(".", 2)
    @file_basename = format(file_basename, @version)

    @archive_name = "#{@file_basename}.#{@file_ext}"
  end

  def download_url
    "https://github.com/#{repo}/releases/download/v#{version}/#{archive_name}"
  end

  private

  def latest_version
    sh_out(%{curl -sSL "#{latest_tag_url}" | sed -nr 's/.*name": "v(.*)",/\\1/p'}).tap do |v|
      halt!("Cannot download the latest tag info") if v.empty?
    end
  end

  def latest_tag_url = "https://api.github.com/repos/#{repo}/tags?per_page=1"
end
