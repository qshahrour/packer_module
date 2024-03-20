#!/bin/bash

set -eux -o pipefail

ecport DEBIAN_FRONTEND=noninteractive
# shellcheck disable=SC2005
echo "$( date )"
printf "%b\n \033[1;36m[ Installing Docker Engine on ${HOSTNAME^^} ]\033[;1m"
apt-get update \
  && apt-get install -y --no-install-recommends \
    apt-transport-https \
    software-properties-common \
    ca-certificates \
    lsb-release \
    git \
    wget \
    curl \
  && rm -rf /var/lib/apt/lists/* /var/cache/apt/*
#&& apt-get clean && apt-get purge \
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=$( dpkg --print-architecture ) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] \"https://download.docker.com/linux/ubuntu\" $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sleep 5
sudo apt update && sudo apt-cache policy docker-ce
sudo apt-get install --yes docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# add docker group and add ubuntu to it
#sudo groupadd docker
sudo usermod -a -G docker ubuntu
newgrp docker
exit 0

