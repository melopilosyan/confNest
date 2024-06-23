export CONFIGS_DIR=${CONFIGS_DIR:-$HOME/Projects/configs}

[ -d $CONFIGS_DIR ] && return

mkdir -p ~/.local/bin

echo -e "\nexport CONFIGS_DIR='$CONFIGS_DIR'" >> ~/.bashrc

echo "Cloning configs into $CONFIGS_DIR ..."
git clone -q https://github.com/melopilosyan/configs.git $CONFIGS_DIR

cd $CONFIGS_DIR
git remote set-url origin git@github.com:melopilosyan/configs.git
cd -

