# Gum is used for the Omakub commands for tailoring Omakub after the initial install
GUM_LATEST=$(curl -s "https://api.github.com/repos/charmbracelet/gum/tags?per_page=1" | sed -nr 's/.*"name": "v(.*)",/\1/p')
echo "Installing gum version $GUM_LATEST ..."

curl -sLo gum.deb "https://github.com/charmbracelet/gum/releases/download/v$GUM_LATEST/gum_${GUM_LATEST}_amd64.deb"
sudo apt install -y ./gum.deb

rm gum.deb
