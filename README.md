# My configuration files

```bash
./setup
```

### Install Neovim

Download latest release and unzip: https://github.com/neovim/neovim/releases
-> `nvim-linux64.tar.gz`

Add an executable file `~/.local/bin/nvim` with content:
```bash
#!/bin/bash

exec <path-to-directory>/bin/nvim "$@"
```

```bash
chmod +x ~/.local/bin/nvim
```

### Install LSPs

#### Ruby

```bash
gem install solargraph
```

#### Lua

Download latest release and unzip: https://github.com/sumneko/lua-language-server/releases
-> `lua-language-server-3.5.6-linux-x64.tar.gz`

Add an executable file `~/.local/bin/lua-language-server` with content:
```bash
#!/bin/bash

exec <path-to-directory>/bin/lua-language-server "$@"
```

```bash
chmod +x ~/.local/bin/lua-language-server
```

### Install LunarVim

Checkout https://www.lunarvim.org/docs/installation
