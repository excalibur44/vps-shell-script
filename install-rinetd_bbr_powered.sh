#!/bin/bash
# 
# *** This script fork from https://github.com/linhua55/lkl_study/blob/master/get-rinetd.sh ***
# 
# Tested system: 
#   Debian 8
# Usage:
#   curl https://raw.githubusercontent.com/excalibur44/vps-shell-script/master/install-rinetd_bbr_powered.sh | bash

export RINET_URL="https://github.com/linhua55/lkl_study/releases/download/v1.2/rinetd_bbr_powered"

if [ "$(id -u)" != "0" ]; then
    echo -e "\e[1;31mERROR: Please run as root\e[0m"
    exit 1
fi

for CMD in curl iptables grep cut xargs systemctl ip awk
do
  if ! type -p ${CMD}; then
    echo -e "\e[1;31mtool ${CMD} is not installed, abort.\e[0m"
    exit 1
  fi
done

# 1. Clean up rinetd-bbr
echo -e "\e[36;01m1. Clean up rinetd-bbr\e[0m"
systemctl disable rinetd-bbr.service
systemctl stop rinetd-bbr.service
killall -9 rinetd-bbr
rm -rf /usr/bin/rinetd-bbr  /etc/rinetd-bbr.conf /etc/systemd/system/rinetd-bbr.service

# 2. Download rinetd-bbr from $RINET_URL
echo -e "\e[36;01m2. Download rinetd-bbr from $RINET_URL\e[0m"
curl -L "${RINET_URL}" >/usr/bin/rinetd-bbr
chmod +x /usr/bin/rinetd-bbr

# 3. Generate /etc/rinetd-bbr.conf
echo -e "\e[36;01m3. Generate /etc/rinetd-bbr.conf\e[0m"
cat <<EOF > /etc/rinetd-bbr.conf
# bindadress bindport connectaddress connectport
0.0.0.0 443 0.0.0.0 443
0.0.0.0 80 0.0.0.0 80
EOF

# 4. Generate /etc/systemd/system/rinetd-bbr.service
echo -e "\e[36;01m4. Generate /etc/systemd/system/rinetd-bbr.service\e[0m"
IFACE=$(ip -4 addr | awk '{if ($1 ~ /inet/ && $NF ~ /^[ve]/) {a=$NF}} END{print a}')
cat <<EOF > /etc/systemd/system/rinetd-bbr.service
[Unit]
Description=rinetd with bbr
Documentation=https://github.com/linhua55/lkl_study

[Service]
ExecStart=/usr/bin/rinetd-bbr -f -c /etc/rinetd-bbr.conf raw ${IFACE}
Restart=always
User=root

[Install]
WantedBy=multi-user.target
EOF

# 5. Enable and Start rinetd-bbr Service
echo -e "\e[36;01m5. Enable and Start rinetd-bbr Service\e[0m"
systemctl enable rinetd-bbr.service
systemctl start rinetd-bbr.service

if [ "$(systemctl status rinetd-bbr.service | sed -n "3p" | awk '{print $2}')"x = "active"x ]; then
  echo -e "\e[32;01mrinetd-bbr started.\e[0m"
  echo "80,443 speed up completed."
  echo "vi /etc/rinetd-bbr.conf as needed."
  echo "killall -9 rinetd-bbr for restart."
  #iptables -t raw -nL
else
  echo -e "\e[1;31mrinetd-bbr failed.\e[0m"
fi
