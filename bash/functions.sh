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

# Use optional "VERSION" placeholder in the file name.
install_deb_package_from_gh() {
  local repo=$1 file_name=$2 version=$3 download_url

  version=${version:-$(latest_gh_release_version "$repo")}
  file_name=${file_name/VERSION/${version#v}} # $version without "v"
  download_url="https://github.com/$repo/releases/download/$version/$file_name.deb"

  echo "Downloading $download_url ..."
  curl -sLo package.deb "$download_url" || exit $?

  sudo dpkg -i package.deb
  rm package.deb
}

latest_gh_release_version() {
  curl -sSL "https://api.github.com/repos/$1/releases/latest" | jq -r '.name' | cat || exit $?
}
