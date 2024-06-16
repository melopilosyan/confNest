omakub_kitty="$OMAKUB_PATH/configs/kitty"

cat <<CONF > ~/.config/kitty/kitty.conf
include $omakub_kitty/mappings.conf
include $omakub_kitty/open-actions.conf
include $omakub_kitty/settings.conf
include $omakub_kitty/nerd-font-code-points.conf
include $omakub_kitty/font.conf

# Managed by the themes kitten
include theme.conf

# Computer specific. Change as needed.
touch_scroll_multiplier 5
CONF
