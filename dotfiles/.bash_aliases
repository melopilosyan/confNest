# vi:ft=sh:

# https://hea-www.harvard.edu/~fine/Tech/vi.html
# set -o vi
# Or use default shortcuts
# https://www.howtogeek.com/181/keyboard-shortcuts-for-bash-command-shell-for-ubuntu-debian-suse-redhat-linux-etc/

alias supdate='sudo apt update'
alias supgrade='sudo apt update && sudo apt -y upgrade'
alias supgrade.autoremove='supgrade && sudo apt -y autoremove'

alias clear.ram.cache="sync && sudo sh -c 'echo 3 > /proc/sys/vm/drop_caches'"

# File system
alias ls='eza -lh --group-directories-first --icons --hyperlink'
alias la='ls -a'
alias lt='ls --total-size'
alias tree='eza --tree --hyperlink'
alias ff="fzf --preview 'bat --style=numbers --color=always {}'"

#### DB
alias mysql.service='sudo service mysql'
alias ms.start='sudo service mysql start'
alias psql.service='sudo service postgresql'
alias psql9.6-restart='sudo systemctl restart postgresql@9.6-main'
alias psqlstart='sudo service postgresql start'
alias redis.service='sudo service redis'
alias start.dbs='sudo service redis_6379 start && sudo service postgresql start'
alias elastic-start='sudo systemctl start elasticsearch.service'

#### Git
alias gl='git log'
alias gls='git ls'
alias gd='git diff'
alias gb='git branch'
alias ga='git add'
alias gaa='git add --all'

#### RVM
alias rubies='rvm list rubies'
alias gemsets='rvm list gemsets'
alias rvm-install-gemset='rvm --create --ruby-version' # $ rvm-install-gemset x.y.z@gemset-name
alias rvm-delete-gemset='rvm gemset delete'

alias be='bundle exec'
#### Rails
alias r='bin/rails'
alias rk='bin/rake'

alias rprod.start='RAILS_ENV=production SECRET_KEY_BASE=14a6f5534d10be1a3fabdd1af0bd60b372bbf36be50ea8f5849099b6da3cc6a8cc68b1ce4ce0d6c6c1d19b94e7e91b9109b596001c8d652970f31e2057bbc303 RAILS_SERVE_STATIC_FILES=true r s'
alias rprod='RAILS_ENV=production'
alias rdev='RAILS_ENV=development'
alias rtest='RAILS_ENV=test'
alias rps='rails server -e production'

alias db.drop='rake db:drop'
alias db.migrate='rake db:migrate'
alias db.create='rake db:create'
alias db.rebuild='rake db:drop db:create db:migrate'

alias tdev.log='tail -f log/development.log'
alias foreman.dev='foreman start -f Procfile.dev'
alias unistart='unicorn -p 3000'

alias gem.install.global='rvm @global do gem install'
alias gem.install.global.dev='rvm @global do \
  gem install solargraph solargraph-rails \
    rubocop rubocop-performance rubocop-rspec \
    pry pry-doc \
    cowsay lolcat \
    gem-ctags && gem ctags'

alias solargraph.install.config='cp -f $CONFIGS_DIR/solargraph/config.yml .solargraph.yml'
alias solargraph.install.rails-definitions='cp -f $CONFIGS_DIR/solargraph/rails_definitions.rb ./config/solargraph_definitions.rb'

#### Psql dump
# alias psql.dump='pg_dump -Fc --no-acl --no-owner --verbose -U postgres -d DB_NAME > db_data.dump'
# alias psql.restore='pg_restore --verbose --clean --no-acl --no-owner -U postgres -d DB_NAME db_data.dump'


# Other stuff

# Swap Caps Lock to Escape.
# sudo apt install gnome-tweak-tool
# > Gnome Tweaks -> Keyboard & Mouse -> Additional Layout Options -> Caps Lock key behavior

alias path='echo -e ${PATH//:/\\n}'

alias omakub='$CONFIGS_DIR/bin/omakub'
alias lv='lvim'
alias ba='slvim ~/.bash_aliases'
alias ae='slvim ~/.bash_aliases_endemic'
alias lvims='lvim -S Session.vim'

alias cd.configs='cd $CONFIGS_DIR'
alias cd.rspec-integration='cd ~/Projects/rspec-integrated.nvim'

alias public_ip='curl icanhazip.com'
alias show.hidden.startapps="sudo sed -i 's/NoDisplay=true/NoDisplay=false/g' /etc/xdg/autostart/*.desktop"
alias listening='sudo netstat -ntlp'
alias find.files.containing='grep --exclude="*.log" -rnw ./ -e'
alias find.files.by.name='find . -name'
alias open=xdg-open
alias hg='rg --hyperlink-format=kitty'

alias ssh.kitty='kitty +kitten ssh'
alias kitty.update='curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin'

# Put workspace customs in this file
[ -f ~/.bash_aliases_endemic ] && . ~/.bash_aliases_endemic

# Having fun
alias saysomething='fortune 2>/dev/null | cowsay -f random 2>/dev/null | lolcat -t -F 0.2 2>/dev/null'
