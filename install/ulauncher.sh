if ! command -v ulauncher >/dev/null; then
  sudo add-apt-repository universe -y
  sudo add-apt-repository ppa:agornostal/ulauncher -y
  sudo apt update -y
  sudo apt install -y ulauncher
fi

mkdir -p ~/.config/autostart ~/.config/ulauncher

test -d ~/.config/ulauncher/user-themes/WhiteSur-Nord ||
  git clone https://github.com/habibimedwassim/WhiteSur-Nord-ulauncher.git "$_"

test -d ~/.config/ulauncher/user-themes/TokyoNight || {
  git clone https://github.com/SirHades696/TokyoNight-Ulauncher-Theme "$_"Theme
  mv "$_"/TokyoNight ~/.config/ulauncher/user-themes/
  rm -rf "$_"TokyoNightTheme
}

# Install the launcher
ln -sf "$CONFIGS_DIR/ulauncher/ulauncher.desktop" ~/.config/autostart/ulauncher.desktop

# Install configs
ln -sf "$CONFIGS_DIR/ulauncher/settings.json" ~/.config/ulauncher/settings.json
ln -sf "$CONFIGS_DIR/ulauncher/shortcuts.json" ~/.config/ulauncher/shortcuts.json
