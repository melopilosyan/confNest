prev_dir=$CONFIGS_DIR
new_dir=${1:-$HOME/.here}

test -d "$new_dir" && echo "$new_dir exists" && return
gum confirm "Move $prev_dir to $new_dir ?" || return

mv "$prev_dir" "$new_dir"
cd "$new_dir" || return

CONFIGS_DIR=$new_dir
source install/1-shell.sh
source install/ulauncher.sh
source install/bashmarks.sh
source install/link-dotfiles.sh
source kitty/generate-config.sh

THEME=Nord source themes/kitty/_set.sh
ln -sf "$CONFIGS_DIR/lvim" ~/.config/lvim
git config --global core.excludesfile "$CONFIGS_DIR/git/global-ignore"

echo "Configs moved to $CONFIGS_DIR"
