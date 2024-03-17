#!/bin/bash
set -x

# Install necessary dependencies

sudo apt-get update -y
sudo DEBIAN_FRONTEND=noninteractive apt-get -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" dist-upgrade
sudo apt-get update

sudo apt-get -y -qq install curl wget git vim apt-transport-https ca-certificates lsb-release software-properties-common apt-utils git iputils-ping libicu-dev gnupg net-tools
sudo add-apt-repository ppa:longsleep/golang-backports -y
sudo apt-get -y -qq install golang-go


# Setup sudo to allow no-password sudo for "hashicorp" group and adding "terraform" user
sudo groupadd -r hashicorp
sudo useradd -m -s /bin/bash terraform
sudo usermod -a -G hashicorp terraform
sudo cp /etc/sudoers /etc/sudoers.orig

echo "terraform  ALL=(ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/terraform

# Installing SSH key


# Create GOPATH for Terraform user & download the webapp from github

#export GOROOT=/usr/lib/go
#export GOPATH=/home/terraform/go
#export PATH=$PATH:$GOROOT/bin:$GOPATH/bin
#git clone https://github.com/hashicorp/learn-go-webapp-demo.git
#EOF

