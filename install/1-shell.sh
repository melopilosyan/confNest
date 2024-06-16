echo 'source $OMAKUB_PATH/configs/shell/bashrc' >> ~/.bashrc

[ -f ~/.inputrc ] && mv ~/.inputrc ~/.inputrc.bak
echo "\$include $OMAKUB_PATH/configs/shell/inputrc" > ~/.inputrc
