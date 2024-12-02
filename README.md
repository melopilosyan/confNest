# confNest

My Ubuntu workspace configuration, Bash setup, installers & dotfiles for
[Brave](https://brave.com/),
[Kitty](https://sw.kovidgoyal.net/kitty/),
[Neovim](https://neovim.io/),
[Ruby](https://www.ruby-lang.org/en/),
[fzf](https://github.com/junegunn/fzf).
[bat](https://github.com/sharkdp/bat),
and more.
Custom [Bash](/bash/rc.d/prompt.sh), [IRB](/dotfiles/.irbrc), [Pry](/dotfiles/.pryrc) prompts,
install-from-github scripts for [binaries](/install/apps-terminal.sh) and fonts as
[Ruby Rake tasks](/rakelib/install.rake) and [Bash functions](/bash/functions.sh).
Utilities for backing up [Brave profile configuration](/utils/copy_brave_profile.sh)
and setting up [OS-level static DNS](/utils/set_static_dns.sh). \
Everything sharing a nest in harmony.

## Installation

```bash
wget -qO- https://raw.githubusercontent.com/melopilosyan/confNest/main/install.sh | bash
```

The installation mechanism is based on [basecamp/omakub](https://github.com/basecamp/omakub),
which I merged in with git commits at
[215c51f](https://github.com/basecamp/omakub/tree/215c51fc0d0b9d6b45f75088c68c74750774f245),
hence the contributors list.


## 🛠️ Standalone tools

> All shell scripts are Bash specific unless otherwise noted.

### [Bashmarks](/bash/rc.d/bashmarks.sh) 🔖
Bash-optimized version of [huyng/bashmarks](https://github.com/huyng/bashmarks) with added
features like the new bookmark name tab completion to the current directory name.
Defines `b`, `j`, `p`, `d`, `l` functions to bookmark, jump to (cd), print,
delete and list frequently used directories.

#### Installation
Download the [bash/rc.d/bashmarks.sh](/bash/rc.d/bashmarks.sh) and source it from `~/.bashrc`.

```sh
curl -o bashmarks.sh https://raw.githubusercontent.com/melopilosyan/confNest/main/bash/rc.d/bashmarks.sh
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
curl -o cs https://raw.githubusercontent.com/melopilosyan/confNest/main/bin/cs
chmod u+x cs
./cs -h

mv cs ~/.local/bin/ # Move to one of the directories in $PATH to use as a command
```
