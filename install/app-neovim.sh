command which -s nvim || rake -C "$CONFIGS_DIR" install:neovim

# Link local lvim as ~/.config/lvim. $_ is the last argument of the previous command.
test -d ~/.config/lvim || ln -sf "$CONFIGS_DIR/lvim" "$_"

tee ~/.local/bin/lvim <<BASH >/dev/null
#!/usr/bin/env bash

export NVIM_APPNAME="\${NVIM_APPNAME:-"lvim"}"

exec -a "\$NVIM_APPNAME" nvim "\$@"
BASH

chmod a+x,g-w ~/.local/bin/lvim
