#!/bin/bash
set -x

sudo apt-get update -y
sudo DEBIAN_FRONTEND=noninteractive apt-get -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" dist-upgrade
sudo apt-get update


sudo apt-get -y -qq install curl wget git vim apt-transport-https ca-certificates lsb-release software-properties-common apt-utils git iputils-ping libicu-dev gnupg net-tools

sudo groupadd -r qadmin
sudo useradd -m -s /bin/bash -d /home/qadmin
sudo usermod -a -G qadmin zqadmin
sudo usermod -a -G sudo qadmin
sudo cp /etc/sudoers /etc/sudoers.orig

echo "qadmin ALL=(ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/qadmin

# Installing SSH key
sudo mkdir -p /home/qadmin/.ssh
sudo chmod 700 /home/qadmin/.ssh
sudo cp /tmp/tf-packer.pub /home/qadmin/.ssh/authorized_keys
sudo chmod 600 /home/qadmin/.ssh/authorized_keys
sudo chown -R qadmin /home/qadmin/.ssh
sudo usermod --shell /bin/bash qadmin

sudo -H -i -u qadmin -- env bash << EOF
whoami
echo ~qadmin

cd /home/qadmin
EOF

