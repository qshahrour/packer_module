#!/bin/bash
set -eux -o pipefail

# Allow toggling components to install and update based off flags
UPDATE_DOCKER=1
UPDATE_DOCKER_COMPOSE=1

echo ""
echo "Updating Docker(\"${UPDATE_DOCKER}\")"
echo "Updating Docker Compose(${UPDATE_DOCKER_COMPOSE})"
echo ""

echo ""
echo " Dcoker Compose Plugin"
sudo apt update --yes
echo ""

# Now install Docker-Compose: https://github.com/docker/compose/releases/
if [ "${UPDATE_DOCKER_COMPOSE}" -eq 1 ]; then
  echo ""
  # shellcheck disable=SC2028
  echo "⏳Start Installing Docker Compose Version: ${UPDATE_DOCKER_COMPOSE}\n"
  sudo curl -L "https://github.com/docker/compose/releases/download/1.21.0//docker-compose-$(uname -s)-$(uname -m)" | sudo tee /usr/local/bin/docker-compose
  sudo chmod +x /usr/local/bin/docker-compose
  sudo apt-get install -y docker-compose
  sudo rm /usr/local/bin/docker-compose
  echo ""
fi
# shellcheck disable=SC2005
echo "$( docker-compose --version )"
echo "Done Installing Docker Compose version: 2"
echo ""




