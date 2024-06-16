if ! grep -wq OMAKUB_PATH ~/.bashrc; then
  echo -e "\nexport OMAKUB_PATH='$OMAKUB_PATH'" >> ~/.bashrc
  echo 'source $OMAKUB_PATH/configs/shell/bashrc' >> ~/.bashrc
fi

[ -f ~/.inputrc ] && mv ~/.inputrc ~/.inputrc.bak
echo "\$include $OMAKUB_PATH/configs/shell/inputrc" > ~/.inputrc
