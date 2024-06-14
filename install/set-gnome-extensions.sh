sudo apt install -y gnome-shell-extension-manager pipx
pipx install gnome-extensions-cli --system-site-packages

# Turn off default Ubuntu extensions
gnome-extensions disable ubuntu-appindicators@ubuntu.com
gnome-extensions disable ding@rastersoft.com

# Pause to assure user is ready to accept confirmations
gum confirm "To install Gnome extensions, you need to accept confirmations." --affirmative "OK" --negative ""

# Install new extensions
gext install tactile@lundal.io
gext install just-perfection-desktop@just-perfection
gext install blur-my-shell@aunetx
gext install emoji-copy@felipeftn
gext install Vitals@CoreCoding.com

# Compile gsettings schemas in order to be able to set them
sudo cp ~/.local/share/gnome-shell/extensions/tactile@lundal.io/schemas/org.gnome.shell.extensions.tactile.gschema.xml /usr/share/glib-2.0/schemas/
sudo cp ~/.local/share/gnome-shell/extensions/just-perfection-desktop\@just-perfection/schemas/org.gnome.shell.extensions.just-perfection.gschema.xml /usr/share/glib-2.0/schemas/
sudo cp ~/.local/share/gnome-shell/extensions/blur-my-shell\@aunetx/schemas/org.gnome.shell.extensions.blur-my-shell.gschema.xml /usr/share/glib-2.0/schemas/
sudo cp ~/.local/share/gnome-shell/extensions/Vitals\@CoreCoding.com/schemas/org.gnome.shell.extensions.vitals.gschema.xml /usr/share/glib-2.0/schemas/
sudo glib-compile-schemas /usr/share/glib-2.0/schemas/

# Configure Tactile
gsettings set org.gnome.shell.extensions.tactile col-0 1
gsettings set org.gnome.shell.extensions.tactile col-1 2
gsettings set org.gnome.shell.extensions.tactile col-2 1
gsettings set org.gnome.shell.extensions.tactile col-3 0
gsettings set org.gnome.shell.extensions.tactile row-0 1
gsettings set org.gnome.shell.extensions.tactile row-1 6
gsettings set org.gnome.shell.extensions.tactile row-2 1
gsettings set org.gnome.shell.extensions.tactile gap-size 16

# Configure Just Perfection
gsettings set org.gnome.shell.extensions.just-perfection animation 2
gsettings set org.gnome.shell.extensions.just-perfection dash-app-running true
gsettings set org.gnome.shell.extensions.just-perfection workspace true
gsettings set org.gnome.shell.extensions.just-perfection workspace-popup false

# Configure Blur My Shell
gsettings set org.gnome.shell.extensions.blur-my-shell.appfolder blur false
gsettings set org.gnome.shell.extensions.blur-my-shell.lockscreen blur false
gsettings set org.gnome.shell.extensions.blur-my-shell.screenshot blur false
gsettings set org.gnome.shell.extensions.blur-my-shell.window-list blur false
gsettings set org.gnome.shell.extensions.blur-my-shell.panel brightness 0.6
gsettings set org.gnome.shell.extensions.blur-my-shell.panel sigma 30
gsettings set org.gnome.shell.extensions.blur-my-shell.panel pipeline 'pipeline_default'
gsettings set org.gnome.shell.extensions.blur-my-shell.overview blur true
gsettings set org.gnome.shell.extensions.blur-my-shell.overview pipeline 'pipeline_default'
gsettings set org.gnome.shell.extensions.blur-my-shell.dash-to-dock blur true
gsettings set org.gnome.shell.extensions.blur-my-shell.dash-to-dock brightness 0.6
gsettings set org.gnome.shell.extensions.blur-my-shell.dash-to-dock sigma 30
gsettings set org.gnome.shell.extensions.blur-my-shell.dash-to-dock static-blur true
gsettings set org.gnome.shell.extensions.blur-my-shell.dash-to-dock style-dash-to-dock 0

# Configure Vitals
gsettings set org.gnome.shell.extensions.vitals alphabetize true
gsettings set org.gnome.shell.extensions.vitals battery-slot 0
gsettings set org.gnome.shell.extensions.vitals fixed-widths true
gsettings set org.gnome.shell.extensions.vitals hide-icons true
gsettings set org.gnome.shell.extensions.vitals hide-zeros false
gsettings set org.gnome.shell.extensions.vitals hot-sensors "['__network-rx_max__', '__network-tx_max__', '_processor_usage_', '_memory_free_', '_storage_free_']"
gsettings set org.gnome.shell.extensions.vitals icon-style 0
gsettings set org.gnome.shell.extensions.vitals include-public-ip true
gsettings set org.gnome.shell.extensions.vitals include-static-gpu-info false
gsettings set org.gnome.shell.extensions.vitals include-static-info false
gsettings set org.gnome.shell.extensions.vitals memory-measurement 1
gsettings set org.gnome.shell.extensions.vitals menu-centered false
gsettings set org.gnome.shell.extensions.vitals monitor-cmd 'gnome-system-monitor'
gsettings set org.gnome.shell.extensions.vitals network-speed-format 0
gsettings set org.gnome.shell.extensions.vitals position-in-panel 2
gsettings set org.gnome.shell.extensions.vitals show-battery false
gsettings set org.gnome.shell.extensions.vitals show-fan false
gsettings set org.gnome.shell.extensions.vitals show-gpu false
gsettings set org.gnome.shell.extensions.vitals show-memory true
gsettings set org.gnome.shell.extensions.vitals show-network true
gsettings set org.gnome.shell.extensions.vitals show-processor true
gsettings set org.gnome.shell.extensions.vitals show-storage true
gsettings set org.gnome.shell.extensions.vitals show-system false
gsettings set org.gnome.shell.extensions.vitals show-temperature false
gsettings set org.gnome.shell.extensions.vitals show-voltage false
gsettings set org.gnome.shell.extensions.vitals storage-measurement 1
gsettings set org.gnome.shell.extensions.vitals storage-path '/'
gsettings set org.gnome.shell.extensions.vitals unit 0
gsettings set org.gnome.shell.extensions.vitals update-time 3
gsettings set org.gnome.shell.extensions.vitals use-higher-precision false
