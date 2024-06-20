# frozen_string_literal: true

# Data class
#
# Attributes
#
#   :name          Home folder and the install task name
#   :repo          Github full repository name - "gh_user/gh_repo"
#   :archive       Github archive name with possible placeholder for version
#   :display_name  Display name
#   :dir           Parent directory
Package = Data.define(:name, :repo, :archive, :display_name, :dir) do
  apps_dir = "~/Apps"
  fonts_dir = "~/.local/share/fonts/"

  names = [
    new(:neovim, "neovim/neovim", "nvim-linux64.tar.gz", "Neovim", apps_dir),
    new(:nerd_font, "ryanoasis/nerd-fonts", "NerdFontsSymbolsOnly.zip", "NerdFont Symbols", fonts_dir),
    new(:jetbrains_mono, "JetBrains/JetBrainsMono", "JetBrainsMono-%s.zip", "JetBrains Mono", fonts_dir),
    new(:cascadia_code, "microsoft/cascadia-code", "CascadiaCode-%s.zip", "Cascadia Code", fonts_dir),
  ].map do |package|
    define_singleton_method(package.name) { package }
    package.name
  end

  define_singleton_method(:names) { names }

  def install(version = nil, &)
    release = GithubRelease.new(repo, archive, version)
    Installer.new(name, dir, release, &).install
  end
end
