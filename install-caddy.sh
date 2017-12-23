#!/bin/bash

systemctl disable caddy.service
systemctl stop caddy.service
rm -rf /usr/local/bin/caddy /etc/caddy /etc/ssl/caddy /var/www /etc/systemd/system/caddy.service

echo -en "\e[1;36mPlease input you domain name: \e[0m" && read domain
echo -en "\e[1;36mPlease input you email(for tls): \e[0m" && read email

mkdir /tmp/caddy && cd /tmp/caddy
wget "https://caddyserver.com/download/linux/amd64?license=personal&plugins=http.git,http.hugo" -O caddy.tar.gz
tar zxf caddy.tar.gz

cp caddy /usr/local/bin
chown root:root /usr/local/bin/caddy
chmod 755 /usr/local/bin/caddy

setcap 'cap_net_bind_service=+ep' /usr/local/bin/caddy

egrep "^www-data" /etc/group >& /dev/null  
if [ $? -ne 0 ]; then
  groupadd -g 33 www-data
fi
egrep "^www-data" /etc/passwd >& /dev/null
if [ $? -ne 0 ]; then
  useradd \
    -g www-data --no-user-group \
    --home-dir /var/www --no-create-home \
    --shell /usr/sbin/nologin \
    --system --uid 33 www-data
fi

mkdir /etc/caddy
chown -R root:www-data /etc/caddy
mkdir /etc/ssl/caddy
chown -R www-data:root /etc/ssl/caddy
chmod 0770 /etc/ssl/caddy

cat > /etc/caddy/Caddyfile <<EOF 
${domain} {
  tls ${email}
  root /var/www/${domain}
  proxy /ray localhost:10226 {
    websocket
    transparent
  }
}
EOF
chown www-data:www-data /etc/caddy/Caddyfile
chmod 444 /etc/caddy/Caddyfile
echo -e "\e[1mThe config of caddy is in \e[36m/etc/caddy/Caddyfile \e[0m"

mkdir -p /var/www/$domain
chown -R www-data:www-data /var/www
chmod -R 555 /var/www
echo "Hello world! I am $domain." > /var/www/$domain/index.html
echo -e "\e[1mThe website root of $domain is in \e[36m/var/www/$domain \e[0m"

cp init/linux-systemd/caddy.service /etc/systemd/system/
chown root:root /etc/systemd/system/caddy.service
chmod 644 /etc/systemd/system/caddy.service
systemctl daemon-reload
systemctl enable caddy.service
systemctl start caddy.service

cd ~ && rm -rf /tmp/caddy
echo -e "\e[1;32mInstall caddy successful! \e[0m"
