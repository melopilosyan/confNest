#!/usr/bin/bash
set -euo pipefail

# Installs the pass command line tool
sudo apt install pass gpg

if ! gpg --list-secret-keys | grep sec -q; then
  echo "==> Generating GPG key (follow prompts)..."
  gpg --full-generate-key
fi

KEY_ID=$(gpg --list-secret-keys --keyid-format LONG | awk -F '[ /]+' 'NR==3 {print $3}')
echo "==> Using key: $KEY_ID"
pass init "$KEY_ID"

BP_BIN=~/.local/bin/browserpass
BP_DIR=~/Apps/browserpass-native
BRAVE_BROWSER=~/.config/BraveSoftware/Brave-Browser

# Download or update browserpass-native source code
if [ -d "$BP_DIR" ]; then
  git -C "$BP_DIR" pull
else
  git clone --depth 1 git@github.com:browserpass/browserpass-native.git "$BP_DIR"
fi

# Install the binary
bin=browserpass-linux64
if [ ! -x "$BP_DIR/$bin" ]; then
  docker build -t browserpass-native "$BP_DIR"
  docker run --rm -v "$BP_DIR":/src browserpass-native "$bin"
  ln -sfv "$BP_DIR/$bin" "$BP_BIN"
fi

# Configure the native host for Brave extension
mkdir -p "$BRAVE_BROWSER/NativeMessagingHosts"
BPN_JSON="$_/com.github.browserpass.native.json"
cp -v "$BP_DIR/browser-files/chromium-host.json" "$BPN_JSON"
jq --arg path "$BP_BIN" '.path = $path' "$BPN_JSON" | tee "$BPN_JSON"

# Auto-install the browser extension via Managed Policies
sudo mkdir -p /etc/brave/policies/managed
sudo cp -v "$BP_DIR/browser-files/chromium-policy.json" "$_/browserpass-extension.json"

# Create gpg-agent.conf with sane defaults
mkdir -p ~/.gnupg
cat <<CONF > ~/.gnupg/gpg-agent.conf
default-cache-ttl 3600
max-cache-ttl 86400
CONF
gpgconf --kill gpg-agent

echo "==> Done. Restart Brave to trigger extension install."
echo "==> Then verify the Browserpass at brave://extensions"
