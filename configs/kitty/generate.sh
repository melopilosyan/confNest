kitty_conf=~/.config/kitty
omakub_kitty="$OMAKUB_PATH/configs/kitty"

mkdir -p $kitty_conf

cat <<CONF > $kitty_conf/kitty.conf
include $omakub_kitty/mappings.conf
include $omakub_kitty/settings.conf
include $omakub_kitty/nerd-font-code-points.conf

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

ln -sf $omakub_kitty/open-actions.conf $kitty_conf

# Set the default theme
THEME=tokyo-night source $OMAKUB_PATH/themes/kitty/_set.sh
