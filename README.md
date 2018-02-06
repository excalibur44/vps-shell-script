- **install-rinetd_bbr_powered.sh**

  此脚本用于在 OpenVZ 的机器上安装 BBR，感谢 [@linhua55](https://github.com/linhua55/lkl_study) 的程序
  
  用法：`bash <(curl -L -s https://raw.githubusercontent.com/excalibur44/vps-shell-script/master/install-rinetd_bbr_powered.sh)`

- **install-bbr.sh**

  此脚本用于安装 BBR，**不适用于 OpenVZ 虚拟化的 VPS！**
  
  用法：`bash <(curl -L -s https://raw.githubusercontent.com/excalibur44/vps-shell-script/master/install-bbr.sh)`
  
  注：有更好的来自 [@秋水逸冰](https://github.com/teddysun/across/blob/master/bbr.sh) 一键脚本，这个脚本只是方便自己使用的而已

- **install-caddy.sh**

  此脚本用于安装 caddy 服务器，默认带有 git 和 hugo 插件，并且会安装 systemctl 服务。暂时加上了 v2ray 的转发，迟点会加上 git 和 hugo 实现自动化部署博客。
  
  用法：`bash <(curl -L -s https://raw.githubusercontent.com/excalibur44/vps-shell-script/master/install-caddy.sh)`
  
  2017-12-19 更新：会自动安装 v2ray ，与 caddy 的转发相对应
