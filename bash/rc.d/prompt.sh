# vi:ft=sh:

# xterm 256 color chart
# Run this to see them all
#  color=16; while [ $color -lt 245 ]; do echo -e "$color: \\033[38;5;${color}mhello\\033[48;5;${color}mworld\\033[0m"; ((color++)); done
#
# Convert RGB to xterm number: https://hm66hd.csb.app/
#
# The ANSI sequence to select these, using the number in the bottom left corner,
# starts 38;5; for the foreground and 48;5; for the background, then the color
# number, so e.g.:
#
# echo -e "\\033[48;5;95;38;5;214mhello world\\033[0m"
#
# More c_info:
# https://phoenixnap.com/kb/change-bash-prompt-linux
# https://unix.stackexchange.com/questions/124407/what-color-codes-can-i-use-in-my-ps1-prompt
#
# ANSI Escape Sequences
# https://gist.github.com/fnky/458719343aabd01cfb17a3a4f7296797

# if [[ "$TERM" =~ 256color ]]; then
#   PS1='\[\e[38;5;244m\]\t\[\e[0m\] \[\e[38;5;29m\]\W\[\e[0m\] \[\e[38;5;208m\]>\[\e[0m\]\[\e[38;5;196m\]>\[\e[0m\]\[\e[38;5;33m\]>\[\e[0m\] '
# fi

export GIT_PS1_SHOWDIRTYSTATE=1
export GIT_PS1_SHOWCOLORHINTS=1
export GIT_PS1_SHOWSTASHSTATE=1
export GIT_PS1_SHOWUNTRACKEDFILES=1
export GIT_PS1_DESCRIBE_STYLE="branch"
export GIT_PS1_SHOWUPSTREAM="verbose name"

export c_info="\[\e[38;5;242m\]"
export c_green="\[\e[38;5;22m\]"
export c_ruby="\[\e[38;5;124m\]"
export c_git="\[\e[38;5;128m\]"
export c_cwd="\[\e[38;5;29m\]"
export c_err_code="\[\e[01;38;5;196m\]"
export c_separator="\[\e[38;5;26m\]"
export c_clear="\[\e[0m\]"

export c_psep="$c_separator󰞷 $c_clear"
export c_ssep="$c_separator $c_clear"

export ltc="$c_green╭── " # left top corner
export lbc="$c_green╰─"  # left bottom corner

export __cwd=$HOME
export __failure_code=
export __top_corner=

function __assign_prompt_beginning() {
  local cmd_ret_val=$?

  if [[ $cmd_ret_val != 0 ]]; then
    __failure_code="$c_info ╰─ $c_err_code$cmd_ret_val\n"
  else
    __failure_code=
  fi

  if [ "$__cwd" == "$PWD" ]; then return; fi

  if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    __top_corner="$ltc"
  else
    __top_corner=
  fi

  __cwd=$PWD
}

system_info='"$__failure_code$__top_corner$c_info\t $c_cwd󰝰 \W $c_ruby \${RUBY_VERSION#*-}"'
git_info='"$c_git  (%s$c_git)\n$lbc"'
last_bit='" $c_psep"'

PROMPT_COMMAND="__assign_prompt_beginning;__git_ps1 $system_info $last_bit $git_info"

PS2=$c_ssep
