case "$THEME" in
  everforest)
    COLOR="bark"
    BG_IMAGE="fog_forest_2.jpg"
    ;;
  nord)
    COLOR="blue"
    BG_IMAGE="nord_scenary.png"
    ;;
  *)
    COLOR="prussiangreen"
    BG_IMAGE="cosmic-cliffs-in-the-carina-nebula.png"
    ;;
esac

test -d ~/.local/share/backgrounds || mkdir -p "$_"

BG_IMAGE_PATH="$_/$BG_IMAGE"
test -f "$BG_IMAGE_PATH" || cp "$CONFIGS_DIR/backgrounds/$BG_IMAGE" "$_"

gsettings set org.gnome.desktop.background picture-uri "$BG_IMAGE_PATH"
gsettings set org.gnome.desktop.background picture-uri-dark "$BG_IMAGE_PATH"
gsettings set org.gnome.desktop.background picture-options 'zoom'

gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
gsettings set org.gnome.desktop.interface cursor-theme 'Yaru'
gsettings set org.gnome.desktop.interface gtk-theme "Yaru-$COLOR-dark"
gsettings set org.gnome.desktop.interface icon-theme "Yaru-$COLOR"
