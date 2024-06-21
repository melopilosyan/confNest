# Exit immediately if a command exits with a non-zero status
set -e

# Ensure computer doesn't go to sleep or lock while installing
gsettings set org.gnome.desktop.screensaver lock-enabled false
gsettings set org.gnome.desktop.session idle-delay 0

echo "Installing prerequisite tools..."
sudo apt update > /dev/null
sudo apt install -y git curl unzip > /dev/null

export OMAKUB_PATH="$HOME/.local/share/omakub"

echo "Cloning OMAKUB into $OMAKUB_PATH..."
git clone https://github.com/melopilosyan/omakub.git $OMAKUB_PATH > /dev/null

# Run installers
for script in $OMAKUB_PATH/install/*.sh; do source $script; done

# Upgrade everything that might ask for a reboot
sudo apt upgrade -y
sudo apt autoremove -y

# Set the final idle and lock settings
gsettings set org.gnome.desktop.screensaver lock-enabled true
gsettings set org.gnome.desktop.session idle-delay 480

# Logout to pickup changes
gum confirm "Ready to logout for all settings to take effect?" && gnome-session-quit --logout --no-prompt
