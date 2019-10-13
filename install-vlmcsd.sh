#!/bin/bash
# 
# install-vlmcsd.sh
# A shell script for installing vlmcsd(KMS Emulator in C).
# Tested system: 
#   Debian 8
# Usage:
#   bash <(curl -L -s https://raw.githubusercontent.com/excalibur44/vps-shell-script/master/install-vlmcsd.sh)

URL="https://github.com/Wind4/vlmcsd/releases/latest/download/binaries.tar.gz"

systemctl disable vlmcsd.service
systemctl stop vlmcsd.service
rm /usr/bin/vlmcsd /etc/systemd/system/vlmcsd.service
systemctl daemon-reload

wget -O vlmcsd.tar.gz $URL
tar zxf vlmcsd.tar.gz
cp binaries/Linux/intel/static/vlmcsd-x64-musl-static /usr/bin/vlmcsd
rm -rf vlmcsd.tar.gz binaries/

cat << EOF > /etc/systemd/system/vlmcsd.service
[Unit]
Description=KMS Emulator in C
After=network.target
Wants=network.target

[Service]
Type=forking
PIDFile=/var/run/vlmcsd.pid
ExecStart=/usr/bin/vlmcsd -p /var/run/vlmcsd.pid
ExecStop=/bin/kill -HUP $MAINPID
PrivateTmp=True
Restart=always

[Install]
WantedBy=multi-user.target
EOF

systemctl enable vlmcsd.service
systemctl start vlmcsd.service
systemctl daemon-reload
sleep 2s
systemctl status vlmcsd.service
