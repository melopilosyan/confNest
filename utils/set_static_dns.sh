# https://docs.redhat.com/en/documentation/red_hat_enterprise_linux/8/html/configuring_and_managing_networking/manually-configuring-the-etc-resolv-conf-file_configuring-and-managing-networking#disabling-dns-processing-in-the-networkmanager-configuration_manually-configuring-the-etc-resolv-conf-file
# https://www.baeldung.com/linux/permanent-etc-resolv-conf

cat <<CONF | sudo tee /etc/NetworkManager/conf.d/90-dns-none.conf >/dev/null
[main]
dns=none
CONF

# Remove the symlink on /run/systemd/resolve/stub-resolv.conf
sudo rm -f /etc/resolv.conf

cat <<CONF | sudo tee /etc/resolv.conf
nameserver 1.1.1.1
nameserver 1.0.0.1
CONF

sudo systemctl disable --now systemd-resolved.service
sudo systemctl restart NetworkManager.service
