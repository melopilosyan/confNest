# NOTE: Expects $FONT variable with short font names.

FONT_SIZE=15

case "$FONT" in
  jetbrains-mono)
    NERD_FONT="JetBrains Mono"
    ;;
  cascadia-mono)
    NERD_FONT="CaskaydiaMono Nerd Font"
    ;;
  fira-mono)
    NERD_FONT="FiraMono Nerd Font"
    ;;
  meslo)
    NERD_FONT="MesloLGLDZ Nerd Font"
    ;;
  *)
    echo "Unknown FONT '$FONT'"
    return
    ;;
esac

gsettings set org.gnome.desktop.interface monospace-font-name "$NERD_FONT $FONT_SIZE"

echo -e "font_family $NERD_FONT\nfont_size $FONT_SIZE" > ~/.config/kitty/font.conf

# Reload kitty instances
kill -SIGUSR1 $(pidof kitty)
