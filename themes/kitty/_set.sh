case "$THEME" in
  everforest) KITTY_THEME="Everforest Dark Medium";;
  nord) KITTY_THEME=Nord;;
  tokyo-night) KITTY_THEME="Tokyo Night Storm";;
  *)
    echo "Unknown THEME '$THEME'"
    return
    ;;
esac

kitten themes --reload-in=all --config-file-name=theme.conf "$KITTY_THEME"
