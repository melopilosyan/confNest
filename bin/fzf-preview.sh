#!/usr/bin/env bash
#
# View text and image files in the FZF preview window.
#
#   fzf --preview='$CONFIGS_DIR/bin/fzf-preview.sh {}'
#
# Adapted from https://github.com/junegunn/fzf/blob/master/bin/fzf-preview.sh

file=${1/#\~\//$HOME/}
type=$(file --dereference --mime -- "$file")

if [[ ! $type =~ image/ ]]; then
  if [[ $type =~ =binary ]]; then
    # Show stats for non-image binary files
    stat "$1"
    exit
  fi

  # Show text files via https://github.com/sharkdp/bat
  bat --style="numbers" --color=always --pager=never -- "$file"
  exit
fi

# Show images via Kitty icat
# 1. 'memory' is the fastest option but if you want the image to be scrollable,
#    you have to use 'stream'.
#
# 2. The last line of the output is the ANSI reset code without newline.
#    This confuses fzf and makes it render scroll offset indicator.
#    Sed removes the last line and appends the reset code to its previous line.
kitty icat --clear --transfer-mode=memory --unicode-placeholder --stdin=no \
           --place="${FZF_PREVIEW_COLUMNS}x${FZF_PREVIEW_LINES}@0x0" "$file" |
  sed '$d;$s/$/\e[m/'
