# vi:ft=sh:

bind 'set completion-ignore-case on'

export VISUAL=$(which lvim)
export EDITOR=$(which lvim)

alias supdate='sudo apt update'
alias supgrade='sudo apt update && sudo apt -y upgrade'
alias supgrade.autoremove='supgrade && sudo apt -y autoremove'

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
alias gs='git status'
alias gl='git log'
alias gd='git diff'
alias gb='git branch'
alias ga='git add'
alias gaa='git add --all'
gcmm() {
  git commit -m "$1"
}

#### RVM
alias rubies='rvm list rubies'
alias gemsets='rvm list gemsets'
alias rvm-install-gemset='rvm --create --ruby-version' # $ rvm-install-gemset x.y.z@gemset-name
alias rvm-delete-gemset='rvm gemset delete'

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

alias solargraph.rails.link='ln -s ~/Projects/configs/rails.rb ./rails.rb'

#### Psql dump
# alias psql.dump='pg_dump -Fc --no-acl --no-owner --verbose -U postgres -d DB_NAME > db_data.dump'
# alias psql.restore='pg_restore --verbose --clean --no-acl --no-owner -U postgres -d DB_NAME db_data.dump'


# Other stuff

# Swap Caps Lock to Escape.
# sudo apt install gnome-tweak-tool
# > Gnome Tweaks -> Keyboard & Mouse -> Additional Layout Options -> Caps Lock key behavior

alias ba='slvim ~/.bash_aliases'
alias ae='slvim ~/.bash_aliases_endemic'
alias lvims='lvim -S Session.vim'
alias cd.configs='cd ~/Projects/configs'
alias cd.rspec-integration='cd ~/Projects/rspec-integrated.nvim'

alias public_ip='curl icanhazip.com'
alias show.hidden.startapps="sudo sed -i 's/NoDisplay=true/NoDisplay=false/g' /etc/xdg/autostart/*.desktop"
alias listening='sudo netstat -ntlp'
alias find.files.containing='grep --exclude="*.log" -rnw ./ -e'
alias find.files.by.name='find . -name'
alias open=xdg-open

alias ssh.kitty='kitty +kitten ssh'
alias kitty.update='curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin'

alias prettyjson="ruby -e 'require \"json\"; puts JSON.pretty_generate(JSON.parse(gets))'"

prettyjson_s() {
  echo "$1" | prettyjson
}

slvim() {
  lvim $1 && source $1
}

# Put workspace customs in this file
[ -f ~/.bash_aliases_endemic ] && . ~/.bash_aliases_endemic

# Apply custom bash prompt
[ -f ~/.custom_prompt ] && . ~/.custom_prompt

# Having fun
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"
alias saysomething='fortune 2>/dev/null | cowsay -f random 2>/dev/null | lolcat -t -F 0.2 2>/dev/null'
saysomething
