#!/bin/bash
sudo apt install -y httpd
echo "${firewall_subnets}" >> /var/www/html/index.html
sudo systemctl start httpd
chkconfig httpd on
