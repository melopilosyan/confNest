NVM_LATEST=$(curl -s "https://api.github.com/repos/nvm-sh/nvm/tags?per_page=1" | sed -nr 's/.*name": "v(.*)",/\1/p')
PROFILE=/dev/null bash -c "curl -so- https://raw.githubusercontent.com/nvm-sh/nvm/v$NVM_LATEST/install.sh | bash"
