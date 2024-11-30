theme="${THEME:-Tokyo Night}"

case "$theme" in
  Everforest) NVIM_THEME=everforest;;
  Nord) NVIM_THEME=nord;;
  *) NVIM_THEME=tokyonight;;
esac

echo "return \"$NVIM_THEME\"" > "$CONFIGS_DIR/lvim/lua/current_colorscheme.lua"
