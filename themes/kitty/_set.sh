case "$THEME" in
  everforest) KITTY_THEME="Everforest Dark Medium";;
  nord) KITTY_THEME=Nord;;
  *) KITTY_THEME="Tokyo Night Storm";;
esac

kitten themes --reload-in=all --config-file-name=theme.conf "$KITTY_THEME"
