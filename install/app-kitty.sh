curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin launch=n
ln -sf ~/.local/kitty.app/bin/kitty ~/.local/bin/

cp ~/.local/kitty.app/share/applications/kitty.desktop ~/.local/share/applications/
sed -i "s|Icon=kitty|Icon=$HOME/.local/kitty.app/share/icons/hicolor/256x256/apps/kitty.png|g" ~/.local/share/applications/kitty*.desktop
sed -i "s|Exec=kitty|Exec=$HOME/.local/kitty.app/bin/kitty|g" ~/.local/share/applications/kitty*.desktop

gsettings set org.gnome.desktop.default-applications.terminal exec 'kitty'

mkdir -p ~/.config/kitty

cat <<CONF > ~/.config/kitty/kitty.conf
include $OMAKUB_PATH/configs/kitty/kitty.conf
touch_scroll_multiplier 5
CONF

# Set the default theme
kitty +kitten themes --config-file-name=theme.conf 'Tokyo Night Storm'
