# My workspace setup

Ubuntu configuration, dotfiles & installers for
[Brave](https://brave.com/),
[Kitty](https://sw.kovidgoyal.net/kitty/),
[Neovim](https://neovim.io/),
[Ruby](https://www.ruby-lang.org/en/), ...

## Installation

```bash
wget -qO- https://raw.githubusercontent.com/melopilosyan/configs/main/install.sh | bash
```

Installation mechanics based on [basecamp/omakub](https://github.com/basecamp/omakub).

## 🛠️ Standalone scripts / tools

### [Bashmarks](/bash/rc.d/bashmarks.sh) 🔖
Bash optimized version of https://github.com/huyng/bashmarks. \
Defines `b`, `j`, `p`, `d`, `l` functions to bookmark, jump to, print,
delete and list frequently used directories.

#### Installation
Download the [/bash/rc.d/bashmarks.sh](/bash/rc.d/bashmarks.sh) and source it from `~/.bashrc`.

```sh
curl -o bashmarks.sh https://raw.githubusercontent.com/melopilosyan/configs/main/bash/rc.d/bashmarks.sh
source bashmarks.sh
b -h

source <path/to/bashmarks.sh> # Source from ~/.bashrc to make it permanent
```

### [cs](/bin/cs) - Cheat Sheets 💡
Interactive browser for https://cht.sh (https://github.com/chubin/cheat.sh)
with caching, fuzzy search on predefined ':list' items & custom queries and
preview of downloaded sheets via FZF.

Dependencies: [bat](https://github.com/sharkdp/bat), [curl](https://github.com/curl/curl), [fzf](https://github.com/junegunn/fzf).

#### Installation
Download the [`bin/cs`](/bin/cs) Bash script and make it executable.

```sh
curl -o cs https://raw.githubusercontent.com/melopilosyan/configs/main/bin/cs
chmod u+x cs
./cs -h

mv cs ~/.local/bin/ # Move to one of the directories in $PATH to use as a command
```
