echo "Installing Signal's public signing key ..."
wget -qO- https://updates.signal.org/desktop/apt/keys.asc | gpg --dearmor >temp.gpg
cat temp.gpg | sudo tee /usr/share/keyrings/signal-desktop-keyring.gpg >/dev/null

echo "Installing the repository info ..."
wget -qO sources https://updates.signal.org/static/desktop/apt/signal-desktop.sources
cat sources | sudo tee /etc/apt/sources.list.d/signal-desktop.sources

rm temp.gpg sources

sudo apt update
sudo apt install -y signal-desktop
