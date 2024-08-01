case "$THEME" in
  Everforest) KITTY_THEME="Everforest Dark Medium";;
  Nord) KITTY_THEME=Nord;;
  *) KITTY_THEME="Tokyo Night Storm";;
esac

kitten themes --reload-in=all "$KITTY_THEME"
