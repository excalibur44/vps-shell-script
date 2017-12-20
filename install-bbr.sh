#!/bin/bash
#
# *** There is a better script: https://raw.githubusercontent.com/teddysun/across/master/bbr.sh ***
#
# Tested system: 
#   Debian 8
# Usage:
#   curl https://raw.githubusercontent.com/excalibur44/vps-shell-script/master/install-bbr.sh | bash

if [ "$(id -u)" != "0" ]; then
    echo -e "\e[1;31mERROR: Please run as root! \e[0m"
    exit 1
fi

# 1. install linux kernel
wget http://kernel.ubuntu.com/~kernel-ppa/mainline/v4.13/linux-image-4.13.0-041300-generic_4.13.0-041300.201709031731_amd64.deb
dpkg -i linux-image-4.13.0-041300-generic_4.13.0-041300.201709031731_amd64.deb
rm linux-image-4.13.0-041300-generic_4.13.0-041300.201709031731_amd64.deb

# 2. append config to /etc/sysctl.conf
echo "net.core.default_qdisc=fq" >> /etc/sysctl.conf
echo "net.ipv4.tcp_congestion_control=bbr" >> /etc/sysctl.conf

echo -e "\e[1;32mInstall successful! \nNow you need to reboot systerm. \e[0m"
