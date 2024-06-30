if ! command -v ulauncher >/dev/null; then
  sudo add-apt-repository universe -y
  sudo add-apt-repository ppa:agornostal/ulauncher -y
  sudo apt update -y
  sudo apt install -y ulauncher
fi

mkdir -p ~/.config/autostart ~/.config/ulauncher

# Install the launcher
ln -sf "$CONFIGS_DIR/ulauncher/ulauncher.desktop" ~/.config/autostart/ulauncher.desktop

# Install configs
ln -sf "$CONFIGS_DIR/ulauncher/settings.json" ~/.config/ulauncher/settings.json
ln -sf "$CONFIGS_DIR/ulauncher/shortcuts.json" ~/.config/ulauncher/shortcuts.json
