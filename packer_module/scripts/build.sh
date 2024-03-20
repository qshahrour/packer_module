#!/bin/bash

# Logger Function
log() {
  local MESSAGE="$1"
  local TYPE="$2"
  local TIMESTAMP="$( date '+%Y-%m-%d %H:%M:%S' )"
  local COLOR
  local ENDCOLOR="\033[0m"
  
  case "$TYPE" in
    "info") COLOR="\033[38;5;79m" ;;
    "success") COLOR="\033[1;32m" ;;
    "error") COLOR="\033[1;31m" ;;
    *) COLOR="\033[1;34m" ;;
  esac

  echo -e "${COLOR}${TIMESTAMP} - ${MESSAGE}${ENDCOLOR}"
}

# Function to check for command availability.+
command_exists() {
  command -v "$1" &> /dev/null
}

# Function to Install the script pre-requisites
install_pre_reqs() {
  log "Installing pre-requisites" "info"

  # Run 'apt-get update'
  if ! apt-get update -y; then
    log "$?" "Failed to run 'apt-get update'" "info"
  fi

  # Run 'apt-get install'
  if ! apt-get install -y apt-transport-https ca-certificates curl gnupg git; then
    echo "$?" "Failed to install packages"
  fi

  mkdir -p /usr/share/keyrings
  rm -f /usr/share/keyrings/nodesource.gpg
  rm -f /etc/apt/sources.list.d/nodesource.list

  # Run 'curl' and 'gpg'
  if ! curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | gpg --dearmor -o /usr/share/keyrings/nodesource.gpg; then
    echo "$?" "Failed to download and import the NodeSource signing key"
  fi
}

# Function to configure the Repo
configure_repo() {
  local NODE_VERSION=$1

  arch=$( dpkg --print-architecture )
  if [ "$arch" != "amd64" ] && [ "$arch" != "arm64" ] && [ "$arch" != "armhf" ]; then
    echo "1" "Unsupported architecture: $arch. Only amd64, arm64, and armhf are supported."
  fi
  echo "deb [arch=$arch signed-by=/usr/share/keyrings/nodesource.gpg] https://deb.nodesource.com/node_$NODE_VERSION nodistro main" | tee /etc/apt/sources.list.d/nodesource.list > /dev/null

  # Nodejs Config
  echo "Package: nodejs" | tee /etc/apt/preferences.d/nodejs > /dev/null
  echo "Pin: origin deb.nodesource.com" | tee -a /etc/apt/preferences.d/nodejs > /dev/null
  echo "Pin-Priority: 600" | tee -a /etc/apt/preferences.d/nodejs > /dev/null

  # Run 'apt-get update'
  if ! apt-get update -y; then
    echo "$?" "Failed to run 'apt-get update'"
  else
    log "Repository configured successfully. To install Node.js, run: apt-get install nodejs -y" "success"
  fi
}

# Define Node.js version
NODE_VERSION="16.9"

# Main execution
install_pre_reqs || echo $? "Failed installing pre-requisites"
configure_repo "$NODE_VERSION" || echo $? "Failed configuring repository"



sudo npm install -g pm2
pm2 startup systemd
sudo env PATH=$PATH:/usr/bin /usr/lib/node_modules/pm2/bin/pm2 startup systemd -u ubuntu --hp /home/ubuntu
pm2 info example


# shellcheck disable=SC2289
# shellcheck disable=SC2016
'''
location / {
  proxy_pass http://localhost:8080;
  proxy_http_version 1.1;
  proxy_set_header Upgrade $http_upgrade;
  # shellcheck disable=SC2016
  proxy_set_header Connection 'upgrade';
  proxy_set_header Host $host;
  proxy_cache_bypass $http_upgrade;
}
'''
