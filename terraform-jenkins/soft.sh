#!/bin/bash
sudo apt-get update -y
sudo apt-get install -y docker.io apache2
echo "This is SoniBoy! Learning Terraform " > /var/www/html/index.html
sudo systemctl restart apache2
sudo systemctl enable apache2
