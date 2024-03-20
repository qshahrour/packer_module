#!/bin/bash -eux

ecport DEBIAN_FRONTEND=noninteractive
# Install Ansible.
sudo apt-add-repository ppa:ansible/ansible
sudo apt update -y
sudo apt-get install -y ansible
