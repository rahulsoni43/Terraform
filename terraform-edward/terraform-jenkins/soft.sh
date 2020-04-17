#!/bin/bash
sudo -i
sudo apt-get update -y
sudo apt-get install -y apache2
sudo echo "This is SoniBoy! Learning Terraform " > /var/www/html/index.html
sudo systemctl restart apache2
sudo systemctl enable apache2
