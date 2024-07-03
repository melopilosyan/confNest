# NOTE: Find the OS default .bashrc at /etc/skel/.bashrc

if ! grep -wq CONFIGS_DIR ~/.bashrc; then
  echo -e "\nexport CONFIGS_DIR=$CONFIGS_DIR" >> ~/.bashrc
  echo '[ -d $CONFIGS_DIR ] && source $CONFIGS_DIR/bash/bashrc' >> ~/.bashrc
fi

[ -f ~/.inputrc ] && mv ~/.inputrc ~/.inputrc.bak
echo "\$include $CONFIGS_DIR/readline/inputrc" > ~/.inputrc
