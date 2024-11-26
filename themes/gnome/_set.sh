case "$THEME" in
  Everforest)
    ACCENT_COLOR="slate"
    GNOME_THEME="Yaru-sage-dark"
    BG_IMAGE="fog_forest_2.jpg"
    ;;
  Nord)
    ACCENT_COLOR="orange"
    GNOME_THEME="Yaru-dark"
    BG_IMAGE="nordfox.jpeg"
    ;;
  *)
    ACCENT_COLOR="brown"
    GNOME_THEME="Yaru-wartybrown-dark"
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

# Gnome Tweaks says this is for legacy applications
gsettings set org.gnome.desktop.interface gtk-theme "$GNOME_THEME"
gsettings set org.gnome.desktop.interface icon-theme "$GNOME_THEME"
gsettings set org.gnome.desktop.interface accent-color "$ACCENT_COLOR"
