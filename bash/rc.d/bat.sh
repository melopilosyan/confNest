export BAT_STYLE="header,numbers"

# Colorize man pages
export MANPAGER="sh -c 'col -bx | bat --plain --language man'"
export MANROFFOPT="-c"

# Colorize the output of passed-as-an-argument command's "--help" option
h() {
  "$@" --help 2>&1 | bat --plain --language help
}

# Display colored help
help() {
  command help "$@" 2>&1 | bat --plain --language help
}
