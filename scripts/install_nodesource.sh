#!/bin/bash
# Script to install the NodeSource Node.js 18.x repo onto Debian or Ubuntu system.
# Run as root or insert `sudo -E` before `bash`:
#
# curl -sL https://deb.nodesource.com/setup_18.x | bash -
#   or
# wget -qO- https://deb.nodesource.com/setup_18.x | bash -
#
export DEBIAN_FRONTEND=noninteractive
NODENAME="Node.js 16.x"
NODEREPO="node_16.x"

echo "Installing the NodeSource ${NODENAME} repo..."
# shellcheck disable=SC2091
if $( uname -m | grep -Eq ^armv6 ); then
  echo "You appear to be running on ARMv6 hardware. Unfortunately this is not currently supported by the NodeSource Linux distributions. Please use the 'linux-armv6l' binary tarballs available directly from nodejs.org for Node.js 4 and later."
  exit 1
fi
# Populating Cache
echo "Populating apt-get cache..."
bash -c 'apt-get update'
echo "Installing packages required for setup"
bash -c "apt-get install -y apt-transport-https lsb-release curl gnupg"
# if your release is development and not stable
IS_PRERELEASE=$( lsb_release -d | grep 'Ubuntu .*development' >& /dev/null; echo $? )
if [[ $IS_PRERELEASE -eq 0 ]]; then
  echo "Your distribution, identified as \"$( lsb_release -d -s )\", is a pre-release version of Ubuntu. NodeSource does not maintain official support for Ubuntu versions until they are formally released. You can try using the manual installation instructions available at https://github.com/nodesource/distributions and use the latest supported Ubuntu version name as the distribution identifier, although this is not guaranteed to work."
  exit 1
fi
DISTRO=$( lsb_release -c -s )

if [ -f "/etc/apt/sources.list.d/chris-lea-node_js-$DISTRO.list" ]; then
  echo 'Removing Launchpad PPA Repository for NodeJS...'
  bash -c 'add-apt-repository -y -r ppa:chris-lea/node.js'
  bash -c "rm -f /etc/apt/sources.list.d/chris-lea-node_js-${DISTRO}.list"
fi
echo 'Adding the NodeSource signing key to your keyring...'
KEYRING='/usr/share/keyrings'
NODE_KEY_URL="https://deb.nodesource.com/gpgkey/nodesource.gpg.key"
LOCAL_NODE_KEY="$KEYRING/nodesource.gpg"

if [ -x /usr/bin/curl ]; then
  bash -c "curl -s $NODE_KEY_URL | gpg --dearmor | tee $LOCAL_NODE_KEY >/dev/null"
else
  bash -c "wget -q -O - $NODE_KEY_URL | gpg --dearmor | tee $LOCAL_NODE_KEY >/dev/null"
fi
echo "Creating apt sources list file for the NodeSource ${NODENAME} repo..."
bash -c "echo 'deb-src [signed-by=$LOCAL_NODE_KEY] https://deb.nodesource.com/${NODEREPO} ${DISTRO} main' >> /etc/apt/sources.list.d/nodesource.list"
bash -c "echo 'deb-src [signed-by=$LOCAL_NODE_KEY] https://deb.nodesource.com/${NODEREPO} ${DISTRO} main' >> /etc/apt/sources.list.d/nodesource.list"

echo 'Running `apt-get update` for you...'
bash -c 'apt-get update'
