# Virtualbox allows you to run VMs for other flavors of Linux or even Windows
# See https://ubuntu.com/tutorials/how-to-run-ubuntu-desktop-on-a-virtual-machine-using-virtualbox#1-overview
# for a guide on how to run Ubuntu inside it.

# sudo apt install -y virtualbox virtualbox-ext-pack

curl -sLo virtualbox.deb https://download.virtualbox.org/virtualbox/7.0.18/virtualbox-7.0_7.0.18-162988~Ubuntu~noble_amd64.deb
sudo apt install -y ./virtualbox.deb
rm virtualbox.deb

sudo usermod -aG vboxusers ${USER}

# After reboot run:
# sudo /sbin/vboxconfig
