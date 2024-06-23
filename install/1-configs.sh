export CONFIGS_DIR=${CONFIGS_DIR:-$HOME/Projects/configs}

[ -d $CONFIGS_DIR ] && return

mkdir -p ~/.local/bin

echo -e "\nexport CONFIGS_DIR='$CONFIGS_DIR'" >> ~/.bashrc

echo "Cloning configs into $CONFIGS_DIR ..."
git clone https://github.com/melopilosyan/configs.git $CONFIGS_DIR > /dev/null
