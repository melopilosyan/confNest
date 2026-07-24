command -v ruby >/dev/null && echo "Ruby is installed. Skipping RVM installation." && return

gpg --keyserver keyserver.ubuntu.com --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB

\curl -sSL https://get.rvm.io | bash -s -- --ignore-dotfiles

source ~/.rvm/scripts/rvm

RUBY_LATEST=$(curl -s "https://api.github.com/repos/ruby/ruby/releases/latest" | sed -nr 's/.*"name": "v(.*)",/\1/p')
rvm install $RUBY_LATEST -C "--enable-yjit"
