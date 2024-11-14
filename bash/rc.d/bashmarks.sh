# Copyright (c) 2010, Huy Nguyen, http://www.huyng.com
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without modification, are permitted provided
# that the following conditions are met:
#
#     * Redistributions of source code must retain the above copyright notice, this list of conditions
#       and the following disclaimer.
#     * Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the
#       following disclaimer in the documentation and/or other materials provided with the distribution.
#     * Neither the name of Huy Nguyen nor the names of contributors
#       may be used to endorse or promote products derived from this software without
#       specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED
# WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A
# PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR
# ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED
# TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
# HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
# NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
# POSSIBILITY OF SUCH DAMAGE.

# Initially copied from https://github.com/huyng/bashmarks
# at https://github.com/huyng/bashmarks/blob/ef37b3749313cd41a742826ffc9a2381a4637bfa/bashmarks.sh
#
# Copyright (c) 2024 Meliq Pilosyan
# Published under the MIT License (https://opensource.org/license/mit)

# Create the file to store bookmarks
export BASHMARKS="${BASHMARKS:-${XDG_DATA_HOME:-$HOME/.local/share}/bashmarks}"
test -f "$BASHMARKS" || touch "$BASHMARKS"

# Remove alias "l" from default .bashrc
alias l &>/dev/null && unalias l >/dev/null

_print_help_message() {
  if [[ $1 =~ -h|--help ]]; then
    echo 'Bookmark frequently used directories

Usage:
  b <name> [ABSOLUTE_PATH] - Bookmark current or ABSOLUTE_PATH directory as "name"
  j <name>                 - Jump/cd to the directory bookmarked as "name"
  p <name>                 - Print the directory path for "name"
  d <name>                 - Delete the bookmark
  l                        - List all bookmarks

Tab autocompletion is available for j, p and d.'
    return 0
  fi
  return 1
}

_valid_bookmark_name() {
  if [[ -z $1 ]]; then
    >&2 echo "Bookmark name is required."
    return 1
  elif [[ $1 != "${1//[^A-Za-z0-9_]/}" ]]; then
    >&2 echo "Bookmark name is invalid. Use only alphanumeric characters and the '_'."
    return 2
  fi
}

_load_bookmarks() {
  source "$BASHMARKS"
  _bm_env_vars="${!_BM_*}" # Get the list of ENV variable names with _BM_ prefix
  _bm_names="${_bm_env_vars//_BM_/}" # Remove the prefix from names
}

_set_bookmark_path() {
  local env_name="_BM_$1"
  _bm_path="${!env_name}" # Substitute _BM_name with its value

  [[ -z $_bm_path ]] && _load_bookmarks && _bm_path="${!env_name}"
}

_delete_saved_bookmark() {
  if [[ -s $BASHMARKS ]] && grep "$1=" "$BASHMARKS" >/dev/null; then
    temp=$(mktemp -t bashmarks.XXXX) || exit 1
    # shellcheck disable=SC2064
    trap "/bin/rm -f -- '$temp'" EXIT

    sed "/$1=/d" "$BASHMARKS" >"$temp"
    /bin/mv "$temp" "$BASHMARKS"

    /bin/rm -f -- "$temp"
    trap - EXIT
  fi
}

b() {
  _print_help_message "$1" && return 0
  _valid_bookmark_name "$1" || return

  _delete_saved_bookmark "$1"
  echo "_BM_$1=\"${2:-$PWD}\"" >>"$BASHMARKS"
  _load_bookmarks
}

j() {
  _print_help_message "$1" && return 0
  _valid_bookmark_name "$1" || return

  _set_bookmark_path "$1"

  if [[ -d $_bm_path ]]; then
    cd "$_bm_path" || return
  elif [[ -z $_bm_path ]]; then
    >&2 echo "'${1}' bashmark does not exist"
    return 3
  else
    >&2 echo "'${_bm_path}' is not a directory"
    return 4
  fi
}

p() {
  _print_help_message "$1" && return 0
  _valid_bookmark_name "$1" || return

  _set_bookmark_path "$1"
  echo "$_bm_path"
}

d() {
  _print_help_message "$1" && return 0
  _valid_bookmark_name "$1" || return

  _delete_saved_bookmark "$1"
  unset "_BM_$1"
  _load_bookmarks
}

l() {
  _load_bookmarks

  local env_name
  for env_name in $_bm_env_vars; do
    printf "\e[0;33m%-20s\e[0m %s\n" "${env_name/_BM_/}" "${!env_name}"
  done
}

function _bookmark_comp {
  [[ -z $_bm_names ]] && _load_bookmarks
  # Complete only the first argument
  (( COMP_CWORD != 1 )) && return 0

  local curr_word="${COMP_WORDS[COMP_CWORD]}"
  # shellcheck disable=SC2207
  COMPREPLY=($(compgen -W "$_bm_names" -- "$curr_word"))
  return 0
}

# Enable programmable completion facilities (see Programmable Completion in bash(1)).
shopt -s progcomp

# Setup completion for j, p, d functions/commands
complete -F _bookmark_comp j
complete -F _bookmark_comp p
complete -F _bookmark_comp d
