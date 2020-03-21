#!/bin/bash
sudo apt-get update
sudo apt-get install -y apache2
echo "This is SoniBoy! Learning Terraform from "${az} > /var/www/html/index.html
sudo systemctl start apache2
sudo systemctl enable apache2
