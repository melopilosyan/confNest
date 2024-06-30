sudo apt install -y \
  fzf ripgrep bat eza zoxide plocate btop apache2-utils xclip \
  vim fortune

# Install latest fd realease from github
FD_LATEST=$(curl -s "https://api.github.com/repos/sharkdp/fd/tags?per_page=1" | sed -nr 's/.*"name": "v(.*)",/\1/p')
curl -sLo fd.deb "https://github.com/sharkdp/fd/releases/download/v$FD_LATEST/fd-musl_${FD_LATEST}_amd64.deb"
sudo apt install -y ./fd.deb
rm fd.deb
