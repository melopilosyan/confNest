# frozen_string_literal: true

namespace :install do
  App[:neovim, "neovim/neovim", "nvim-linux64.tar.gz", "Neovim"].itask do |nvim|
    ln_sf nvim.extract_dir.join("bin/nvim"), local_bin("nvim")
  end

  Font[:nerd_font, "ryanoasis/nerd-fonts", "NerdFontsSymbolsOnly.zip", "NerdFont Symbols"].itask

  Font[:cascadia_code, "microsoft/cascadia-code", "CascadiaCode-%s.zip", "Cascadia Code font"]
    .itask { "mv ttf/CascadiaCode.ttf ttf/CascadiaCodeItalic.ttf . && rm -rf ttf otf woff2" }

  Font[:jetbrains_mono, "JetBrains/JetBrainsMono", "JetBrainsMono-%s.zip", "JetBrains Mono font"]
    .itask { "command find fonts/ttf/ -type f ! -name '*NL*' -exec mv -t . {} + && rm -rf fonts/" }

  desc "Install the latest versions of all configured packages"
  multitask all: Package.names
end
