omakub_kitty="$OMAKUB_PATH/configs/kitty"

cat <<CONF > ~/.config/kitty/kitty.conf
include $omakub_kitty/mappings.conf
include $omakub_kitty/open-actions.conf
include $omakub_kitty/settings.conf
include $omakub_kitty/nerd-font-code-points.conf

# Updated when the font changes.
include font.conf

# Managed by the themes kitten.
include theme.conf

# Computer specific. Change as needed.
touch_scroll_multiplier 5
CONF

cat <<CONF > ~/.config/kitty/font.conf
font_family JetBrains Mono
font_size 15
CONF
