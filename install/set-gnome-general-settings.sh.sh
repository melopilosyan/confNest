# Swap Caps Lock & Esc keys
gsettings set org.gnome.desktop.input-sources xkb-options "['caps:swapescape']"

# Set numbers, dates and currency format
gsettings set org.gnome.system.locale region 'en_GB.UTF-8'

# Add Armenian and Russion to the input languages list
gsettings set org.gnome.desktop.input-sources sources "[('xkb', 'us'), ('xkb', 'am+phonetic'), ('xkb', 'ru+phonetic')]"
gsettings set org.gnome.desktop.input-sources mru-sources "[('xkb', 'us'), ('xkb', 'am+phonetic'), ('xkb', 'ru+phonetic')]"
gsettings set org.gnome.desktop.input-sources per-window true

# Enable night light
gsettings set org.gnome.settings-daemon.plugins.color night-light-enabled true
gsettings set org.gnome.settings-daemon.plugins.color night-light-temperature 4600
gsettings set org.gnome.settings-daemon.plugins.color night-light-schedule-automatic true

# Clock and calendar
gsettings set org.gnome.desktop.calendar show-weekdate true
gsettings set org.gnome.desktop.interface clock-format '24h'
gsettings set org.gnome.desktop.interface clock-show-date true
gsettings set org.gnome.desktop.interface clock-show-seconds true
gsettings set org.gnome.desktop.interface clock-show-weekday true

# Scroll behaviour and cursor speed
gsettings set org.gnome.desktop.peripherals.mouse natural-scroll false
gsettings set org.gnome.desktop.peripherals.mouse speed 0.6
gsettings set org.gnome.desktop.peripherals.touchpad natural-scroll false
gsettings set org.gnome.desktop.peripherals.touchpad speed 0.9

# File browser
gsettings set org.gnome.nautilus.preferences show-delete-permanently true
gsettings set org.gnome.nautilus.window-state initial-size "(1000, 520)"

# Ungrouped
gsettings set org.gnome.desktop.interface enable-animations false
gsettings set org.gnome.desktop.interface show-battery-percentage true
gsettings set org.gnome.desktop.sound allow-volume-above-100-percent true
gsettings set org.gnome.mutter center-new-windows true
