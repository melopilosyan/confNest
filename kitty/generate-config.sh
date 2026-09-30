kitty_conf=~/.config/kitty
configs_kitty="$CONFIGS_DIR/kitty"

mkdir -p $kitty_conf

cat <<CONF > $kitty_conf/kitty.conf
include $configs_kitty/mappings.conf
include $configs_kitty/settings.conf
include $configs_kitty/nerd-font.conf

# Updated when the font changes.
include font.conf

# Computer specific. Change as needed.
touch_scroll_multiplier 5
CONF

cat <<CONF > $kitty_conf/font.conf
font_family JetBrains Mono
font_size 15
CONF

# https://sw.kovidgoyal.net/kitty/kittens/choose-files/
cat <<CONF > $kitty_conf/choose-files.conf
# Next result
map ctrl+j next 1
# Previous result
map ctrl+k next -1
# Left result
map ctrl+h next left
# Right result
map ctrl+l next right
CONF

ln -sf "$configs_kitty/open-actions.conf" $kitty_conf

# https://sw.kovidgoyal.net/kitty/sessions/
mkdir -p ~/.local/share/kitty
ln -sf "$configs_kitty/sessions" ~/.local/share/kitty/sessions
