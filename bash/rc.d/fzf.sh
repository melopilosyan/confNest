export FZF_COMPLETION_TRIGGER='*'

# Tokyonight Storm theme
export FZF_DEFAULT_OPTS='
  --color bg:#1f2335,bg+:#292e42,hl:#565f89,hl+:#bb9af7
  --color border:#1f2335,gutter:#1f2335,pointer:#bb9af7,marker:#7dcfff
  --color separator:#292e42,info:#3d59a1,prompt:#29a4bd,query:#c0caf5
  --color preview-bg:#24283b,preview-border:#24283b,preview-scrollbar:#3b4261,preview-label:#3b4261
  --pointer "" --marker "󱊁 " --prompt "  "
  --cycle
'
export FZF_FILE_PREVIEW_OPTS='
  --preview "$CONFIGS_DIR/bin/fzf-preview.sh {}" --preview-window 65%
  --walker file,hidden --walker-skip tmp,log,.git,node_modules
  --bind ctrl-d:preview-half-page-down
  --bind ctrl-u:preview-half-page-up
  --bind change:first
  --info right
'
export FZF_ALT_C_COMMAND=""
export FZF_CTRL_T_OPTS=$FZF_FILE_PREVIEW_OPTS

# Load key bindings and bash completion
test -s ~/.local/share/fzf/bash-integration.sh && source "$_"

ff() {
  FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS $FZF_FILE_PREVIEW_OPTS" \
    fzf "$@" --multi --margin 4%,1.5% --border \
        --preview-label "Ctrl-d/u to scroll down/up" --preview-label-pos 0:bottom
}

alias ffd='ff --walker-root'
