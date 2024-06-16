cat <<EOF > ~/.local/share/applications/HEY.desktop
[Desktop Entry]
Version=1.0
Name=HEY
Comment=HEY Email + Calendar
Exec=brave-browser --app="https://app.hey.com/" --name=HEY
Terminal=false
Type=Application
Icon=$OMAKUB_PATH/web-apps/icons/HEY.png
Categories=GTK;
MimeType=text/html;text/xml;application/xhtml_xml;
StartupNotify=true
EOF
