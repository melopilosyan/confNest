sudo apt install -y xclip vim universal-ctags fortune

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

sharkdp_bat_post_install_callback() {
  [[ -f /etc/apt/preferences.d/bat ]] && return 0

  cat <<PREF | sudo tee /etc/apt/preferences.d/bat >/dev/null
Package: bat
Pin: version *
Pin-Priority: -1
PREF
}
# bat - a cat clone with syntax highlighting and Git integration
install_from_github 'sharkdp/bat' "bat_VERSION_$arch.deb"

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
