# vi:ft=sh:

export VISUAL=$(which lvim)

alias supdate='sudo apt update'
alias supgrade='sudo apt update && sudo apt -y upgrade'

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
alias gd='git diff'
alias gb='git branch'
alias ga='git add'

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

alias foreman.dev='foreman start -f Procfile.dev'
alias unistart='unicorn -p 3000'

#### Psql dump
# alias psql.dump='pg_dump -Fc --no-acl --no-owner --verbose -U postgres -d DB_NAME > db_data.dump'
# alias psql.restore='pg_restore --verbose --clean --no-acl --no-owner -U postgres -d DB_NAME db_data.dump'


# Other stuff
alias laliases='less ~/.bash_aliases'
alias cd.configs='cd ~/Projects/configs'

alias public_ip='curl icanhazip.com'
alias show.hidden.startapps="sudo sed -i 's/NoDisplay=true/NoDisplay=false/g' /etc/xdg/autostart/*.desktop"
alias listening='sudo netstat -ntlp'
alias find.files.containing='grep --exclude="*.log" -rnw ./ -e'
alias find.files.by.name='find . -name'
alias open=xdg-open

alias prettyjson="ruby -e 'require \"json\"; puts JSON.pretty_generate(JSON.parse(gets))'"

prettyjson_s() {
  echo "$1" | prettyjson
}

slvim() {
  lvim $1 && source $1
}

# Put workspace customs in this file
[ -f ~/.bash_aliases_endemic ] && . ~/.bash_aliases_endemic


# xterm 256 color chart
# Run this to see them all
#  color=16; while [ $color -lt 245 ]; do echo -e "$color: \\033[38;5;${color}mhello\\033[48;5;${color}mworld\\033[0m"; ((color++)); done
#
# The ANSI sequence to select these, using the number in the bottom left corner,
# starts 38;5; for the foreground and 48;5; for the background, then the color
# number, so e.g.:
#
# echo -e "\\033[48;5;95;38;5;214mhello world\\033[0m"
#
# More info:
# https://phoenixnap.com/kb/change-bash-prompt-linux
# https://unix.stackexchange.com/questions/124407/what-color-codes-can-i-use-in-my-ps1-prompt

# if [[ "$TERM" =~ 256color ]]; then
#   PS1='\[\e[38;5;244m\]\t\[\e[0m\] \[\e[38;5;29m\]\W\[\e[0m\] \[\e[38;5;208m\]>\[\e[0m\]\[\e[38;5;196m\]>\[\e[0m\]\[\e[38;5;33m\]>\[\e[0m\] '
# fi

export GIT_PS1_SHOWDIRTYSTATE=1
export GIT_PS1_SHOWCOLORHINTS=1
export GIT_PS1_SHOWSTASHSTATE=1
export GIT_PS1_SHOWUNTRACKEDFILES=1
export GIT_PS1_DESCRIBE_STYLE="branch"
export GIT_PS1_SHOWUPSTREAM="verbose name"

inactive="\[\e[38;5;237m\]"
info="\[\e[38;5;242m\]"

user="$info\u$inactive"
datetime="$info\D{%T %d.%m.%y}$inactive"

_c="\[\e[38;5;22m\]"
ltc="$_c┌── "  # left top corner
lbc="$_c└─ "   # left bottom corner

SYSTEM_INFO='"$ltc${inactive}as $user at $datetime in \[\e[38;5;29m\]\W "'
GIT_INFO='"${inactive}on \[\e[38;5;129m\](%s\[\e[38;5;129m\])\\n$lbc"'
FLAG_ARROWS='"\[\e[38;5;196m\]>\[\e[38;5;26m\]>\[\e[38;5;172m\]>\[\e[0m\] "'

PROMPT_COMMAND="__git_ps1 $SYSTEM_INFO $FLAG_ARROWS $GIT_INFO"
