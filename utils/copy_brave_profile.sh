BBD=~/.config/BraveSoftware/Brave-Browser/Default

files=(
  Preferences
  Bookmarks
  Shortcuts
  Favicons
  History
)

_copy_files() {
  # Remove trailing /
  local src=${1%/} dest="${2%/}"

  # Prefix files with "$src/"
  paths=("${files[@]/#/$src/}")
  rsync -iva "${paths[@]}" "$dest"/
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
