command -v ruby >/dev/null && echo "Ruby is installed. Skipping RVM installation." && return

gpg --keyserver keyserver.ubuntu.com --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB

\curl -sSL https://get.rvm.io | bash -s -- --ignore-dotfiles

source ~/.rvm/scripts/rvm

rvm install "$(latest_gh_release_version 'ruby/ruby' 'without v')" -C "--enable-yjit"
