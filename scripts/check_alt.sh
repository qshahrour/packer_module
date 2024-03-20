#!/bin/bash

print_status() {
  echo
  echo "## $1"
  echo
}

fail() {
  echo 'Error executing command, exiting'
  exit 1
}
# shellcheck disable=SC1009
exec_cmd() {
  echo "+ $1"
  bash -c "$1"
} 
exec_cmd_fail() {
  exec_cmd "$1" || fail
}

check_alt() {
  if [ "X${DISTRO}" == "X${2}" ]; then
    echo
    echo "## You seem to be using ${1} version ${DISTRO}."
    echo "## This maps to ${3} \"${4}\"... Adjusting for you..."
    DISTRO="${4}"
  fi
}

check_alt "Astra Linux"    "orel"            "Debian"        "stretch"
check_alt "BOSS"           "anokha"          "Debian"        "wheezy"
check_alt "BOSS"           "anoop"           "Debian"        "jessie"
check_alt "BOSS"           "drishti"         "Debian"        "stretch"
check_alt "BOSS"           "unnati"          "Debian"        "buster"
check_alt "BOSS"           "urja"            "Debian"        "bullseye"
check_alt "bunsenlabs"     "bunsen-hydrogen" "Debian"        "jessie"
check_alt "bunsenlabs"     "helium"          "Debian"        "stretch"
check_alt "bunsenlabs"     "lithium"         "Debian"        "buster"
check_alt "Devuan"         "jessie"          "Debian"        "jessie"
check_alt "Devuan"         "ascii"           "Debian"        "stretch"
check_alt "Devuan"         "beowulf"         "Debian"        "buster"
check_alt "Devuan"         "chimaera"        "Debian"        "bullseye"
check_alt "Devuan"         "ceres"           "Debian"        "sid"
check_alt "Devuan"         "daedalus"        "Debian"        "bookworm"
check_alt "Deepin"         "panda"           "Debian"        "sid"
check_alt "Deepin"         "unstable"        "Debian"        "sid"
check_alt "Deepin"         "stable"          "Debian"        "buster"
check_alt "Deepin"         "apricot"         "Debian"        "buster"
check_alt "Deepin"         "beige"           "Debian"        "bookworm"
check_alt "elementaryOS"   "luna"            "Ubuntu"        "precise"
check_alt "elementaryOS"   "freya"           "Ubuntu"        "trusty"
check_alt "elementaryOS"   "loki"            "Ubuntu"        "xenial"
check_alt "elementaryOS"   "juno"            "Ubuntu"        "bionic"
check_alt "elementaryOS"   "hera"            "Ubuntu"        "bionic"
check_alt "elementaryOS"   "odin"            "Ubuntu"        "focal"
check_alt "elementaryOS"   "jolnir"          "Ubuntu"        "focal"
check_alt "elementaryOS"   "horus"           "Ubuntu"        "jammy"
check_alt "Kali"           "sana"            "Debian"        "jessie"
check_alt "Kali"           "kali-rolling"    "Debian"        "bullseye"
check_alt "Linux Mint"     "maya"            "Ubuntu"        "precise"
check_alt "Linux Mint"     "qiana"           "Ubuntu"        "trusty"
check_alt "Linux Mint"     "rafaela"         "Ubuntu"        "trusty"
check_alt "Linux Mint"     "rebecca"         "Ubuntu"        "trusty"
check_alt "Linux Mint"     "rosa"            "Ubuntu"        "trusty"
check_alt "Linux Mint"     "sarah"           "Ubuntu"        "xenial"
check_alt "Linux Mint"     "serena"          "Ubuntu"        "xenial"
check_alt "Linux Mint"     "sonya"           "Ubuntu"        "xenial"
check_alt "Linux Mint"     "sylvia"          "Ubuntu"        "xenial"
check_alt "Linux Mint"     "tara"            "Ubuntu"        "bionic"
check_alt "Linux Mint"     "tessa"           "Ubuntu"        "bionic"
check_alt "Linux Mint"     "tina"            "Ubuntu"        "bionic"
check_alt "Linux Mint"     "tricia"          "Ubuntu"        "bionic"
check_alt "Linux Mint"     "ulyana"          "Ubuntu"        "focal"
check_alt "Linux Mint"     "ulyssa"          "Ubuntu"        "focal"
check_alt "Linux Mint"     "uma"             "Ubuntu"        "focal"
check_alt "Linux Mint"     "una"             "Ubuntu"        "focal"
check_alt "Linux Mint"     "vanessa"         "Ubuntu"        "jammy"
check_alt "Linux Mint"     "vera"            "Ubuntu"        "jammy"
check_alt "Liquid Lemur"   "lemur-3"         "Debian"        "stretch"
check_alt "LMDE"           "betsy"           "Debian"        "jessie"
check_alt "LMDE"           "cindy"           "Debian"        "stretch"
check_alt "LMDE"           "debbie"          "Debian"        "buster"
check_alt "LMDE"           "elsie"           "Debian"        "bullseye"
check_alt "MX Linux 17"    "Horizon"         "Debian"        "stretch"
check_alt "MX Linux 18"    "Continuum"       "Debian"        "stretch"
check_alt "MX Linux 19"    "patito feo"      "Debian"        "buster"
check_alt "MX Linux 21"    "wildflower"      "Debian"        "bullseye"
check_alt "Pardus"         "onyedi"          "Debian"        "stretch"
check_alt "Parrot"         "ara"             "Debian"        "bullseye"
check_alt "Tanglu"         "chromodoris"     "Debian"        "jessie"
check_alt "Trisquel"       "toutatis"        "Ubuntu"        "precise"
check_alt "Trisquel"       "belenos"         "Ubuntu"        "trusty"
check_alt "Trisquel"       "flidas"          "Ubuntu"        "xenial"
check_alt "Trisquel"       "etiona"          "Ubuntu"        "bionic"
check_alt "Ubilinux"       "dolcetto"        "Debian"        "stretch"
check_alt "Uruk GNU/Linux" "lugalbanda"      "Ubuntu"        "xenial"

if [ "X${DISTRO}" == "Xdebian" ]; then
  print_status "Unknown Debian-based distribution, checking /etc/debian_version..."
  
  NEWDISTRO=$( [ -e /etc/debian_version ] && cut -d/ -f1 < /etc/debian_version )
  if [ "X${NEWDISTRO}" == "X" ]; then
    print_status "Could not determine distribution from /etc/debian_version..."
  else
    DISTRO=$NEWDISTRO
    print_status "Found \"${DISTRO}\" in /etc/debian_version..."
  fi

fi


  PRE_INSTALL_PKGS=""
  # Check that HTTPS transport is available to APT
  # (Check snaked from: https://get.docker.io/ubuntu/)
  if [ ! -e /usr/lib/apt/methods/https ]; then
    PRE_INSTALL_PKGS="${PRE_INSTALL_PKGS} apt-transport-https"
  fi
  if [ ! -x /usr/bin/lsb_release ]; then
    PRE_INSTALL_PKGS="${PRE_INSTALL_PKGS} lsb-release"
  fi
  if [ ! -x /usr/bin/curl ] && [ ! -x /usr/bin/wget ]; then
    PRE_INSTALL_PKGS="${PRE_INSTALL_PKGS} curl"
  fi
  # Used by apt-key to add new keys
  if [ ! -x /usr/bin/gpg ]; then
    PRE_INSTALL_PKGS="${PRE_INSTALL_PKGS} gnupg"
  fi

  if [ "X${PRE_INSTALL_PKGS}" != "X" ]; then
    echo "Installing packages required for setup:${PRE_INSTALL_PKGS}..."
    # This next command needs to be redirected to /dev/null or the script will bork in some environments
    bash -c "apt-get install -y${PRE_INSTALL_PKGS} > /dev/null 2>&1"
  fi
