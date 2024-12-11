# Copyright (c) 2024 Meliq Pilosyan, https://github.com/melopilosyan
# Published under the MIT License (https://opensource.org/license/mit)
#
# Initially copied from https://github.com/huyng/bashmarks
# at https://github.com/huyng/bashmarks/blob/ef37b3749313cd41a742826ffc9a2381a4637bfa/bashmarks.sh

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

export BASHMARKS="${BASHMARKS:-${XDG_DATA_HOME:-$HOME/.local/share}/bashmarks}"

# WARNING: Make sure the letters b, j, d, l are not used in your command line.
# Or change the corresponding function names below.

_print_help_message() {
  [[ $1 =~ -h|--help ]] || return 1

  echo 'Bookmark frequently used directories

Usage:
  b <name> [ABSOLUTE_PATH] - Bookmark ABSOLUTE_PATH or current directory as <name>
  j <name>                 - Jump/cd to the directory bookmarked as <name>
  d <name>                 - Delete the bookmark
  l                        - List all bookmarks

TAB completion is available for bookmarked and new names.
The latter completes the sanitized current directory name.'
}

_valid_bookmark_name() {
  if [[ -z $1 ]]; then
    >&2 echo "Bookmark name is required."
    return 1
  elif [[ $1 != "${1//[^A-Za-z0-9_]/}" ]]; then
    >&2 echo "Bookmark name is invalid. Use only alphanumeric characters and underscore."
    return 2
  fi
}

_load_bookmarks() {
  [[ -f $BASHMARKS ]] && source "$BASHMARKS"
  _bm_env_vars="${!_BM_*}"           # Get the list of ENV variable names with _BM_ prefix
  _bm_names="${_bm_env_vars//_BM_/}" # Remove the prefix from names
}

b() {
  _print_help_message "$1" && return 0
  _valid_bookmark_name "$1" || return

  [[ -s $BASHMARKS ]] && sed -i "/_BM_$1=/d" "$BASHMARKS"
  printf '_BM_%s="%s"\n' "$1" "${2:-$PWD}" >>"$BASHMARKS"
  _load_bookmarks # to update _bm_names cache
}

j() {
  _print_help_message "$1" && return 0
  _valid_bookmark_name "$1" || return

  local env_name="_BM_$1"
  local bm_path="${!env_name}" # Substitute _BM_name with its value
  # Try again after reloading if not found. Can be added in another Bash session.
  [[ -z $bm_path ]] && _load_bookmarks && bm_path="${!env_name}"

  if [[ -d $bm_path ]]; then
    cd "$bm_path" || return
  elif [[ -z $bm_path ]]; then
    >&2 echo "'${1}' bookmark does not exist"
    return 3
  else
    >&2 echo "'${bm_path}' is not a directory"
    return 4
  fi
}

d() {
  _print_help_message "$1" && return 0
  _valid_bookmark_name "$1" || return

  [[ -s $BASHMARKS ]] && sed -i "/_BM_$1=/d" "$BASHMARKS"
  unset "_BM_$1"
  _load_bookmarks # to update _bm_names cache
}

l() {
  _load_bookmarks

  local env_name
  for env_name in $_bm_env_vars; do
    printf "\e[0;33m%-20s\e[0m %s\n" "${env_name/_BM_/}" "${!env_name}"
  done
}

_bookmark_comp() {
  [[ -z $_bm_names ]] && _load_bookmarks
  # Complete only the first argument
  ((COMP_CWORD != 1)) && return 0

  readarray -t COMPREPLY < <(compgen -W "$_bm_names" -- "${COMP_WORDS[COMP_CWORD]}")
}

_new_bookmark_comp() {
  ((COMP_CWORD != 1)) && return 0

  local dir_name="${PWD##*/}"
  local name="${dir_name//[^A-Za-z0-9]/_}" # Replace non alphanumerics with underscore
  COMPREPLY=("${name,,}")                  # Convert to lowercase
}

# Enable programmable completion facilities (see Programmable Completion in bash(1)).
shopt -s progcomp

# Setup new name completion to the current directory name for the b command
complete -F _new_bookmark_comp b
# Setup bookmark name completion for j, d commands
complete -F _bookmark_comp j
complete -F _bookmark_comp d
