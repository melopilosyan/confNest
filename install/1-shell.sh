# NOTE: Find the OS default .bashrc at /etc/skel/.bashrc

# Extentions installer requires ~/.local/bin in the PATH.
# Make it available diring the initial installation.
if [[ $PATH != *~/.local/bin* ]]; then PATH="$HOME/.local/bin:$PATH"; fi
mkdir -p ~/.local/bin

if ! grep -wq OMAKUB_PATH ~/.bashrc; then
  echo -e "\nexport OMAKUB_PATH='$OMAKUB_PATH'" >> ~/.bashrc
  echo '[ -d $OMAKUB_PATH ] && source $OMAKUB_PATH/configs/shell/bashrc' >> ~/.bashrc
fi

[ -f ~/.inputrc ] && mv ~/.inputrc ~/.inputrc.bak
echo "\$include $OMAKUB_PATH/configs/shell/inputrc" > ~/.inputrc
