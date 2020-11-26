#!/bin/sh

#git clone https://github.com/yutaka-m/underwater-drone-v3.git
sudo apt update
sudo apt upgrade
sudo apt install dhcpcd5 wireless-tools dnsmasq net-tools raspi-config hostapd -y
sudo DEBIAN_FRONTEND=noninteractive apt install -y netfilter-persistent iptables-persistent
sudo cp ./etc/sysctl.conf /etc/sysctl.conf 
sudo mv /etc/dnsmasq.conf /etc/dnsmasq.conf.orig
sudo cp ./etc/dnsmasq.conf /etc/dnsmasq.conf
sudo cp ./etc/default/hostapd /etc/default/hostapd 
sudo cp ./etc/hostapd/hostapd.conf /etc/hostapd/hostapd.conf
sudo cp ./etc/dhcpcd.conf /etc/dhcpcd.conf 
sudo lshw -class network -short
lsmod
iwlist 
lspci
lsusb
#sudo vi /boot/firmware/network-config 
#sudo systemctl unmask hostapd
#sudo systemctl enable hostapd
#sudo systemctl restart hostapd
#sudo systemctl status hostapd
sudo cp ./etc/netplan/50-cloud-init.yaml /etc/netplan/
sudo netplan apply

# https://github.com/chrippa/ds4drv
# wget https://github.com/chrippa/ds4drv/blob/master/ds4drv.conf
sudo pip3 install ds4drv
wget https://raw.githubusercontent.com/chrippa/ds4drv/master/udev/50-ds4drv.rules
sudo cp 50-ds4drv.rules /etc/udev/rules.d/
sudo udevadm control --reload-rules
sudo udevadm trigger
ds4drv
sudo vi /etc/rc.local
sudo apt install python3 
apt install python3-pip
cp scripts/clientJoy.service /lib/systemd/system/
systemctl status clientJoy
systemctl enable clientJoy
systemctl start clientJoy

