command which -s node && echo "Node is installed. Skipping Mise installation." && return

# Install mise in ~/.local/bin/mise
curl https://mise.run | sh

# Install node and yarn
~/.local/bin/mise use --global node@lts
~/.local/bin/mise exec -- npm install -g yarn
