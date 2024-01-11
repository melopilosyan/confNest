# My workspace configuration

[Kitty](https://sw.kovidgoyal.net/kitty/),
[Neovim](https://neovim.io/),
[LunarVim](https://www.lunarvim.org/),
[Ruby](https://www.ruby-lang.org/en/),
[NerdFonts](https://www.nerdfonts.com/),
[JetBrainsMono](https://github.com/JetBrains/JetBrainsMono)

```sh
./bin/setup

rake install:all

gem.install.global.dev
```

## Ubuntu

#### Configure
Enables minimize on click but continue to show the window picker when more than one \
window of a given app is open.
```sh
gsettings set org.gnome.shell.extensions.dash-to-dock click-action 'minimize-or-previews'
```

#### Extentions
```sh
sudo apt install gnome-shell-extension-manager
```
From inside the extention manager
- Emoji Copy
- Vitals
