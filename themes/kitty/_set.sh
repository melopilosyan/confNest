case "$THEME" in
  catppuccin) KITTY_THEME=Catppuccin-Macchiato;;
  everforest) KITTY_THEME="Everforest Dark Medium";;
  gruvbox) KITTY_THEME="Gruvbox Dark";;
  kanagawa) KITTY_THEME=Kanagawa;;
  nord) KITTY_THEME=Nord;;
  tokyo-night) KITTY_THEME="Tokyo Night Storm";;
  *)
    echo "Unknown THEME '$THEME'"
    return
    ;;
esac

kitty +kitten themes --reload-in=all --config-file-name=theme.conf "$KITTY_THEME"
