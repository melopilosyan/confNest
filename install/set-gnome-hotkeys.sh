set_per_digit() {
  # Replace every "#" with the value of $n
  for n in {1..9}; do gsettings set ${@//\#/$n}; done
}

# Full-screen with title/navigation bar
gsettings set org.gnome.desktop.wm.keybindings toggle-fullscreen "['<Shift>F11']"

# INFO: Use Alt for applications
#
# Either show or launch the n-th dock application.
set_per_digit org.gnome.shell.extensions.dash-to-dock app-hotkey-# "['<Alt>#']"
# Launch a new n-th dock application.
set_per_digit org.gnome.shell.extensions.dash-to-dock app-ctrl-hotkey-# "['<Ctrl><Alt>#']"
set_per_digit org.gnome.shell.extensions.dash-to-dock app-shift-hotkey-# "['<Shift><Alt>#']"
# Close window
gsettings set org.gnome.desktop.wm.keybindings close "['<Alt>q']"

# INFO: Use Super for workspaces
#
# Switch to n-th workspaces
set_per_digit org.gnome.desktop.wm.keybindings switch-to-workspace-# "['<Super>#']"
# Prevent colliding the default <Super># bindings on switch-to-application with switch-to-workspace
set_per_digit org.gnome.shell.keybindings switch-to-application-# "[]"
# Move the application to the n-th workspace
set_per_digit org.gnome.desktop.wm.keybindings move-to-workspace-# "['<Shift><Super>#']"

# Reserve slots for custom keybindings
gsettings set org.gnome.settings-daemon.plugins.media-keys custom-keybindings "['/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/', '/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/']"

# INFO: Set ulauncher to Control+Space
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ name 'ulauncher-toggle'
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ command 'ulauncher-toggle'
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ binding '<Ctrl>space'

# INFO: Set flameshot (with the sh fix for starting under Wayland) on alternate print screen key
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/ name 'Flameshot'
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/ command 'sh -c -- "flameshot gui"'
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/ binding '<Control>Print'
