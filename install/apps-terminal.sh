sudo apt install -y zoxide plocate btop apache2-utils xclip vim fortune

# As in amd64
arch=$(dpkg --print-architecture)

# As in x86_64
xarch=$(uname -m)

# fd - find entries in the filesystem
install_deb_package_from_gh 'sharkdp/fd' "fd_VERSION_$arch"

# rg - recursively search the current directory for lines matching a pattern
install_deb_package_from_gh 'BurntSushi/ripgrep' "ripgrep_VERSION-1_$arch"

# gum - a tool for glamorous shell scripts
install_deb_package_from_gh 'charmbracelet/gum' "gum_VERSION_$arch"

# bat - a cat clone with syntax highlighting and Git integration
install_deb_package_from_gh 'sharkdp/bat' "bat_VERSION_$arch"

# eza - a modern, maintained replacement for ls
install_binary_package_from_gh 'eza-community/eza' "eza_$xarch-unknown-linux-gnu.tar.gz"

# fzf - an interactive filter program for any kind of list
install_binary_package_from_gh 'junegunn/fzf' "fzf-VERSION-linux_$arch.tar.gz"
mkdir -p ~/.local/share/fzf
# Prepare bash integration to be sourced directly from bashrc
fzf --bash > ~/.local/share/fzf/bash-integration.sh
# Install man page
curl -fsSLo ~/.local/share/man/man1/fzf.1 "https://raw.githubusercontent.com/junegunn/fzf/$version/man/man1/fzf.1"
