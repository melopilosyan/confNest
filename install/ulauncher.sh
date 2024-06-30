sudo add-apt-repository universe -y
sudo add-apt-repository ppa:agornostal/ulauncher -y
sudo apt update -y
sudo apt install -y ulauncher

# Start ulauncher to have it populate config before we overwrite
mkdir -p ~/.config/autostart/
cp $OMAKUB_PATH/configs/ulauncher.desktop ~/.config/autostart/ulauncher.desktop
gtk-launch ulauncher.desktop >/dev/null 2>&1
sleep 2 # ensure enough time for ulauncher to set defaults
cp $OMAKUB_PATH/configs/ulauncher.json ~/.config/ulauncher/settings.json
cp $OMAKUB_PATH/configs/ulauncher_shortcuts.json ~/.config/ulauncher/shortcuts.json
