sudo apt install -y \
  fzf bat eza zoxide plocate btop apache2-utils xclip \
  vim fortune

# fd - find entries in the filesystem
install_deb_package_from_gh 'sharkdp/fd' 'fd_VERSION_amd64'

# rg - recursively search the current directory for lines matching a pattern
install_deb_package_from_gh 'BurntSushi/ripgrep' 'ripgrep_VERSION-1_amd64'

# gum - a tool for glamorous shell scripts
install_deb_package_from_gh 'charmbracelet/gum' 'gum_VERSION_amd64'
