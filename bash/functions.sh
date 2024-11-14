# Invoke command's --version option
v() {
  "$@" --version
}

g() {
  if [ $# -gt 0 ]; then
    git "$@"
    [[ $1 == init ]] && __refresh_prompt=1
  else
    git status
  fi
}

git-search-by-term() {
  local term=$1
  local show_lines_around=${2:-4}
  # shellcheck disable=SC2086
  git log --oneline -S "$term" | awk '{ print $1 }' | xargs git show |
    grep -C $show_lines_around "$term"
}

slvim() {
  lvim "$1" && source "$1"
}

# Show the RSS for the process filtered by command part.
# RSS: resident set size, the non-swapped physical memory that a task has used (in kiloBytes).
prss() {
  # shellcheck disable=SC2009
  ps -e -o pid,rss,cmd | grep -E "$1|RSS" | sed '$d'
}

ps.cpu() {
  ps auxf | sort -nr -k 3 | head -"${1:-10}"
}

ps.mem() {
  ps auxf | sort -nr -k 4 | head -"${1:-10}"
}

du.top() {
  local d=${1:-.}
  du -cksh "${d%/}"/* | sort -hr | head -"${2:-10}"
}

source_all() {
  local script
  for script in "$@"; do source "$script"; done
}

# $1 - Github repository: username/repo.
# $2 - File name template with optional VERSION placeholder.
# $3 - Package version to download (optional).
install_from_github() {
  repo=$1 file_name=$2 version=$3

  version=${version:-$(latest_gh_release_version "$repo")}
  [ -z "$version" ] && echo ">>> Failed fetching latest $repo version" && return 0

  # Substitute VERSION with the version number.
  file_name=${file_name/VERSION/${version#v}} # $version without "v"

  __check_if_version_is_installed && return 0
  install_from_url "https://github.com/$repo/releases/download/$version/$file_name" || return 0
  __run_post_install_callback_if_present || return 0
  __cache_installed_version
}

# $1 - Github repository: username/repo.
# $2 - If present removes the possible "v" from version (optional).
latest_gh_release_version() {
  local repo=$1 lose_v=$2 filter='.tag_name|sub("_";".";"g")'

  [ -n "$lose_v" ] && filter+='|sub("v";"")'
  curl -fsSL "https://api.github.com/repos/$repo/releases/latest" | jq -r "$filter"
}

# $1 - The URL to download and install the package from.
install_from_url() {
  local url="$1" file_name="${1##*/}"

  echo "Downloading $url ..."
  curl -fsSLo "$file_name" "$url" || return $?

  case "$file_name" in
    *.deb)
      sudo dpkg -i "$file_name" || return $?
      ;;
    *.tar.gz)
      echo "Installing $file_name into ~/.local/bin ..."
      tar xzf "$file_name" -C ~/.local/bin || return $?
      ;;
    *)
      echo ">>> Can not install $file_name"
      return 1
      ;;
  esac

  rm "$file_name"
}

# Returns 1 if the package version is already installed.
__check_if_version_is_installed() {
  [ ! -s $ghp_versions_cache ] && echo '{}' > $ghp_versions_cache

  package=${repo//[^A-Za-z0-9]/_}
  installed_version=$(jq -r ".$package" $ghp_versions_cache)

  [ "$version" = "$installed_version" ] &&
    echo "$repo is already the newest version ($version)"
}

# Returns a non-zero value if the callback exists and returns a non-zero value.
__run_post_install_callback_if_present() {
  local cb="${package}_post_install_callback"
  type "$cb" >/dev/null 2>&1 || return 0
  "$cb"
}

__cache_installed_version() {
  local json
  json=$(jq --arg k "$package" --arg v "$version" '. += {$k:$v}' $ghp_versions_cache)
  [ -z "$json" ] && echo ">>> Can not cache '$package' '$version'" && return 0

  echo -e "$json" > $ghp_versions_cache
}
ghp_versions_cache=~/.cache/installed-github-package-versions.json
