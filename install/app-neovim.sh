command which -s nvim || rake -C "$CONFIGS_DIR" install:neovim

test -d ~/.config/lvim && return

# Link local lvim as ~/.config/lvim. $_ is the last argument of the previous command.
ln -sf "$CONFIGS_DIR/lvim" "$_"

# TODO: Migrate neovim configuration on top of [LazyVim](https://www.lazyvim.org)
#
# Install [LunarVim](https://www.lunarvim.org)
LV_BRANCH='release-1.4/neovim-0.9' bash <(curl -s https://raw.githubusercontent.com/LunarVim/LunarVim/release-1.4/neovim-0.9/utils/installer/install.sh) --no-install-dependencies

# Fix the language servers not running issue
~/.local/bin/lvim --headless +LvimCacheReset +q

#if [ ! -d "$HOME/.config/nvim" ]; then
#	git clone https://github.com/LazyVim/starter ~/.config/nvim
#	cp ~/.local/share/omakub/themes/neovim/tokyo-night.lua ~/.config/nvim/lua/plugins/theme.lua
#fi
