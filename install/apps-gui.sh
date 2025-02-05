sudo apt install -y gimp xarchiver

echo "Making xarchiver the default opener for its supported file types"
xdg-mime default xarchiver.desktop "$(
  sed -n '/^MimeType=/ { s/MimeType=//; y/;/ /; p }' /usr/share/applications/xarchiver.desktop
)"
