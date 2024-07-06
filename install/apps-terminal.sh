sudo apt install -y eza zoxide plocate btop apache2-utils xclip vim fortune

# As in amd64
arch=$(dpkg --print-architecture)

# fd - find entries in the filesystem
install_deb_package_from_gh 'sharkdp/fd' 'fd_VERSION_amd64'

# rg - recursively search the current directory for lines matching a pattern
install_deb_package_from_gh 'BurntSushi/ripgrep' 'ripgrep_VERSION-1_amd64'

# gum - a tool for glamorous shell scripts
install_deb_package_from_gh 'charmbracelet/gum' 'gum_VERSION_amd64'

# bat - a cat clone with syntax highlighting and Git integration
install_deb_package_from_gh 'sharkdp/bat' 'bat_VERSION_amd64'

# fzf - an interactive filter program for any kind of list
install_binary_package_from_gh 'junegunn/fzf' "fzf-VERSION-linux_$arch.tar.gz"
mkdir -p ~/.local/share/fzf
# Prepare bash integration to be sourced directly from bashrc
fzf --bash > ~/.local/share/fzf/bash-integration.sh
# Install man page
curl -fsSLo ~/.local/share/man/man1/fzf.1 "https://raw.githubusercontent.com/junegunn/fzf/$version/man/man1/fzf.1"
