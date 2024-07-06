# Invoke command's --version option
v() {
  "$@" --version
}

g() {
  if [ $# -gt 0 ]; then
    git "$@"
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

source_all() {
  local script
  for script in "$@"; do source "$script"; done
}

install_binary_package_from_gh() {
  fetch_gh_package_info "$1" "$2" "$3"

  echo "Downloading and installing binary from $download_url ..."
  curl -fsSLo "$file_name" "$download_url" || exit $?
  tar xf "$file_name" -C ~/.local/bin
  rm "$file_name"
}

install_deb_package_from_gh() {
  fetch_gh_package_info "$1" "$2" "$3"
  install_deb_from_web "$download_url.deb"
}

# $1 - Github repository: username/repo.
# $2 - File name template with optional VERSION placeholder.
# $3 - Package version to download (optional).
#
# Sets $version, $file_name & $download_url variables globally to be used afterwords.
fetch_gh_package_info() {
  repo=$1 file_name=$2 version=$3

  version=${version:-$(latest_gh_release_version "$repo")}
  file_name=${file_name/VERSION/${version#v}} # $version without "v"
  download_url="https://github.com/$repo/releases/download/$version/$file_name"
}

latest_gh_release_version() {
  local repo=$1 lose_v=$2 filter='.tag_name|sub("_";".";"g")'

  [ -n "$lose_v" ] && filter+='|sub("v";"")'
  curl -sSL "https://api.github.com/repos/$repo/releases/latest" | jq -r "$filter" || exit $?
}

install_deb_from_web() {
  echo "Downloading $1 ..."
  curl -sSLo package.deb "$1" || exit $?
  sudo dpkg -i package.deb
  rm package.deb
}
