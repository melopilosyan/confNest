# https://lmstudio.ai/

mkdir -p ~/Apps/lm-studio
cd ~/Apps/lm-studio || return

filename=$(wget --content-disposition -nv https://lmstudio.ai//download/latest/linux/x64 2>&1 | cut -d'"' -f2)

chmod u+x "$filename"
./"$filname" --appimage-extract

cd squashfs-root || return
sudo chown root:root chrome-sandbox
sudo chmod 4755 chrome-sandbox

cat <<EOF > ~/.local/share/applications/lm-studio.desktop
[Desktop Entry]
Name=LM Studio
Type=Application
Exec=$HOME/Apps/lm-studio/squashfs-root/lm-studio
Icon=$HOME/Apps/lm-studio/squashfs-root/lm-studio.png
Termonal=false
EOF
