ln -sf "$CONFIGS_DIR"/dotfiles/.* ~

test -f ~/.bash_aliases_endemic || echo -e "# vim:ft=sh:\n\n# Workspace specific aliases" > "$_"
chmod 600 ~/.bash_aliases_endemic
