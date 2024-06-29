kitty_conf=~/.config/kitty
configs_kitty="$CONFIGS_DIR/kitty"

mkdir -p $kitty_conf

cat <<CONF > $kitty_conf/kitty.conf
include $configs_kitty/mappings.conf
include $configs_kitty/settings.conf
include $configs_kitty/nerd-font.conf

# Updated when the font changes.
include font.conf

# Managed by the themes kitten.
include theme.conf

# Computer specific. Change as needed.
touch_scroll_multiplier 5
CONF

cat <<CONF > $kitty_conf/font.conf
font_family JetBrains Mono
font_size 15
CONF

ln -sf "$configs_kitty/open-actions.conf" $kitty_conf

# Set the default theme
THEME=tokyo-night source $OMAKUB_PATH/themes/kitty/_set.sh
