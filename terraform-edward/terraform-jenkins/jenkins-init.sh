#!/bin/bash
# jenkins repository
wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo apt-key add -
echo "deb http://pkg.jenkins.io/debian-stable binary/" >> /etc/apt/sources.list
apt-get update

# install dependencies
apt-get install -y python3 openjdk-11-jdk awscli
# install jenkins
apt-get install -y jenkins unzip

# install terraform
wget -q https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip \
&& unzip -o terraform_${TERRAFORM_VERSION}_linux_amd64.zip -d /usr/local/bin \
&& rm terraform_${TERRAFORM_VERSION}_linux_amd64.zip

# install packer
cd /usr/local/bin
wget -q https://releases.hashicorp.com/packer/1.5.5/packer_1.5.5_linux_amd64.zip
unzip packer_0.10.2_linux_amd64.zip
# clean up
apt-get clean
rm terraform_${TERRAFORM_VERSION}_linux_amd64.zip
rm packer_0.10.2_linux_amd64.zip
