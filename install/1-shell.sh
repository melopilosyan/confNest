# NOTE: Find the OS default .bashrc at /etc/skel/.bashrc

sed -i 's/^alias l=/# &/' ~/.bashrc

if ! grep -wq "$CONFIGS_DIR" ~/.bashrc; then
  echo -e "\nexport CONFIGS_DIR=$CONFIGS_DIR" >> ~/.bashrc
  echo 'test -s $CONFIGS_DIR/bash/bashrc && source "$_"' >> ~/.bashrc
fi

[ -f ~/.inputrc ] && mv ~/.inputrc ~/.inputrc.bak
echo "\$include $CONFIGS_DIR/readline/inputrc" > ~/.inputrc
