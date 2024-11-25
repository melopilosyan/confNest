BBD=~/.config/BraveSoftware/Brave-Browser/Default

files=(
  Preferences
  Bookmarks
  Shortcuts
  Favicons
  History History-journal
)

set_paths_to() {
  # Prefix files with "$1/"
  paths=("${files[@]/#/$1/}")
}

_copy_files() {
  # Remove trailing /
  local src=${1%/} dest="${2%/}"

  set_paths_to "$src"
  rsync -iva "${paths[@]}" "$dest"/

  set_paths_to "$dest"
  chmod 600 "${paths[@]}"
}

case "$1" in
--to) _copy_files "$BBD" "$2" ;;
--from) _copy_files "$2" "${3:-$BBD}" ;;
*)
  echo "Usage:

  brave_backup --to <DEST_DIR>
  brave_backup --from <SRC_DIR> [ALTERNATIVE_DEST]
"
  ;;
esac
