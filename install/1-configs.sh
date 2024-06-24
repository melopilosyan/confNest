export CONFIGS_DIR=${CONFIGS_DIR:-$HOME/Projects/configs}

grep -wq CONFIGS_DIR ~/.bashrc || echo -e "\nexport CONFIGS_DIR='$CONFIGS_DIR'" >> ~/.bashrc

[ -d $CONFIGS_DIR ] && return

echo "Cloning configs into $CONFIGS_DIR ..."
git clone -q https://github.com/melopilosyan/configs.git $CONFIGS_DIR

cd $CONFIGS_DIR
git remote set-url origin git@github.com:melopilosyan/configs.git
cd -

