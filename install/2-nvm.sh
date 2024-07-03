command -v node >/dev/null && echo "Node is installed. Skipping NVM installation." && return

NVM_LATEST=$(latest_gh_release_version 'nvm-sh/nvm')
PROFILE=/dev/null bash <(curl -s "https://raw.githubusercontent.com/nvm-sh/nvm/$NVM_LATEST/install.sh")

ln -sf ~/.nvm/bash_completion ~/.local/share/bash-completion/completions/nvm

export NVM_DIR=~/.nvm
source ~/.nvm/nvm.sh

nvm install --lts --latest-npm
npm install -g yarn

# yarn global add neovim
# yarn global add tree-sitter-cli
