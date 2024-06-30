git config --global user.name 'Meliq Pilosyan'
git config --global user.email melopilosyan@hey.com

git config --global alias.aa 'add -A'
git config --global alias.b branch
git config --global alias.changed "show --pretty='format:' --name-only"
git config --global alias.cm commit
git config --global alias.cmamend 'commit --amend'
git config --global alias.cmm 'log --format=%B -n 1'
git config --global alias.co checkout
git config --global alias.df diff
git config --global alias.lastcc 'show --name-only'
git config --global alias.ls "log --pretty=format:'%C(yellow)%h %C(green)%ad%Cred%d %Creset%s%Cblue [%cn]' --decorate --date=short --graph"
git config --global alias.nb 'checkout -b'
git config --global alias.set-remote-origin 'remote set-url origin'
git config --global alias.st status
git config --global alias.zup "for-each-ref --sort='authordate:iso8601' --format='%(color:green)%(authordate:relative)%09%(color:white)%(refname:short) / %(contents:subject)' refs/heads"

git config --global merge.tool meld
git config --global pull.rebase true
git config --global push.default current
git config --global rebase.autosquash true

git config --global color.ui auto
git config --global commit.verbose true
git config --global core.excludesfile "$CONFIGS_DIR/git/global-ignore"
git config --global init.defaultBranch master

# Enable git arguments completion for the g wrapper function defined in bash/functions.sh
tee ~/.local/share/bash-completion/completions/g <<BASH >/dev/null
  . /usr/share/bash-completion/completions/git
  __git_complete g __git_main
BASH
