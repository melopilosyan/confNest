# https://docs.docker.com/engine/install/ubuntu/#install-using-the-repository
# https://docs.docker.com/engine/install/ubuntu/#install-using-the-convenience-script

curl -fsSL https://get.docker.com | bash -s -- --no-autostart

# Disable starting the daemon on startup
sudo systemctl disable docker.socket docker.service
systemctl --user disable docker.socket docker.service

# To run Docker as a non-privileged user, consider setting up the
# Docker daemon in rootless mode for your user:
dockerd-rootless-setuptool.sh install

# FIXME: Add postgresql as a default configured DB as well
#
# docker create --restart unless-stopped -p 3306:3306 --name=mysql8 -e MYSQL_ROOT_PASSWORD= -e MYSQL_ALLOW_EMPTY_PASSWORD=true mysql:8
# docker create --restart unless-stopped -p 6379:6379 --name=redis redis
