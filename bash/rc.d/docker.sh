# INFO: Some applications may require it
export DOCKER_HOST=unix:///run/user/1000/docker.sock

# INFO: To control docker.service, run: `systemctl --user (start|stop|restart) docker.service`
alias docker.service.start='systemctl --user start docker.service'
alias docker.service.stop='systemctl --user stop docker.socket docker.service'
