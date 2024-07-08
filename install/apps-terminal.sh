sudo apt install -y plocate btop apache2-utils xclip vim fortune

# As in amd64
arch=$(dpkg --print-architecture)

# As in x86_64
xarch=$(uname -m)

# fd - find entries in the filesystem
install_from_github 'sharkdp/fd' "fd_VERSION_$arch.deb"

# rg - recursively search the current directory for lines matching a pattern
install_from_github 'BurntSushi/ripgrep' "ripgrep_VERSION-1_$arch.deb"

# gum - a tool for glamorous shell scripts
install_from_github 'charmbracelet/gum' "gum_VERSION_$arch.deb"

# bat - a cat clone with syntax highlighting and Git integration
install_from_github 'sharkdp/bat' "bat_VERSION_$arch.deb"

# zoxide - a smarter cd command for your terminal
ajeetdsouza_zoxide_post_install_callback() {
  mkdir -p ~/.local/share/zoxide
  # Prepare bash integration to be sourced directly from bashrc
  zoxide init --cmd cd bash > "$_/bash-integration.sh"
}
install_from_github 'ajeetdsouza/zoxide' "zoxide_VERSION-1_$arch.deb"

# eza - a modern, maintained replacement for ls
install_from_github 'eza-community/eza' "eza_$xarch-unknown-linux-gnu.tar.gz"

# fzf - an interactive filter program for any kind of list
junegunn_fzf_post_install_callback() {
  mkdir -p ~/.local/share/fzf
  # Prepare bash integration to be sourced directly from bashrc
  fzf --bash > ~/.local/share/fzf/bash-integration.sh
  # Install man page
  curl -fsSLo ~/.local/share/man/man1/fzf.1 "https://raw.githubusercontent.com/junegunn/fzf/$version/man/man1/fzf.1"
}
install_from_github 'junegunn/fzf' "fzf-VERSION-linux_$arch.tar.gz"
