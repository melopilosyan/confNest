<h1 align="center">confNest</h1>

![confNest - cozy penguin developer's nest with gems](backgrounds/confNest.png)

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

The installation mechanism and file structure have been adapted from
[basecamp/omakub](https://github.com/basecamp/omakub) - merged in at
[215c51f](https://github.com/basecamp/omakub/tree/215c51fc0d0b9d6b45f75088c68c74750774f245).


## 🛠️ Standalone tools

> All shell scripts are Bash specific unless otherwise noted.

### [Bashmarks](/bash/rc.d/bashmarks.sh) 🔖
Bash-optimized version of [huyng/bashmarks](https://github.com/huyng/bashmarks) with added
features, like <kbd>Tab</kbd> completion when adding a new bookmark to the current directory name, and
removed print function. Defines `b`, `j`, `d`, `l` functions to bookmark, jump to (cd),
delete and list saved bookmarks.

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

## ⚙️ Notable installers / configs / snippets

#### ⚠️ [pass and browserpass extension installer](install/optional/pass.sh)
From it's man page: _pass  is a very simple password store that keeps passwords inside gpg2_.

Installs the `pass` command line utility, generates a GPG key, the Browserpass extension
(for Brave) and its native counterpart.

## 🔱 Rake tasks

```sh
$ rake -T
rake c                                                  # console - Open Pry session in the installer context
rake check:all                                          # Check all configured packages for updates
rake check:cascadia_code                                # Check Cascadia Code font for updates
rake check:jetbrains_mono                               # Check JetBrains Mono font for updates
rake check:neovim                                       # Check Neovim for updates
rake check:nerd_font                                    # Check NerdFont Symbols for updates
rake i                                                  # console - Open IRB session in the installer context
rake install:all                                        # Install the latest versions of all configured packages
rake install:cascadia_code[version]                     # Install the latest or provided version of Cascadia Code font from Github
rake install:jetbrains_mono[version]                    # Install the latest or provided version of JetBrains Mono font from Github
rake install:neovim[version,remove_previous_versions?]  # Install the latest or provided version of Neovim from Github
rake install:nerd_font[version]                         # Install the latest or provided version of NerdFont Symbols from Github
rake pass_import[csv_path,last_header_name]             # Import passwords from given CSV into the pass utility
```
