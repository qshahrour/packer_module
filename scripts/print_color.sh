#!/bin/bash

if test -t 1; then # if terminal
  NCOLORS=$( which tput > /dev/null && tput colors ) # supports color
  if test -n "$NCOLORS" && test $NCOLORS -ge 8; then
    TERMCOLS=$( tput cols )
    BOLD="$( tput bold )"
    UNDERLINE="$( tput smul )"
    STANDOUT="$( tput smso )"
    NORMAL="$( tput sgr0 )"
    BLACK="$( tput setaf 0 )"
    RED="$( tput setaf 1 )"
    GREEN="$( tput setaf 2 )"
    YELLOW="$( tput setaf 3 )"
    BLUE="$( tput setaf 4 )"
    MAGENTA="$( tput setaf 5 )"
    CYAN="$( tput setaf 6 )"
    WHITE="$( tput setaf 7 )"
  fi
fi

print_bold() {
  TITLE="$1"
  TEXT="$2"

  echo
  echo "${RED}================================================================================${NORMAL}"
  echo "${RED}================================================================================${NORMAL}"
  echo
  echo -e "  ${BOLD}${YELLOW}${TITLE}${NORMAL}"
  echo
  echo -en "  ${TEXT}"
  echo
  echo "${RED}================================================================================${NORMAL}"
  echo "${RED}================================================================================${NORMAL}"
}

node_deprecation_warning() {
if [[ "X${NODENAME}" == "Xio.js 1.x" ||
    "X${NODENAME}" == "Xio.js 2.x" ||
    "X${NODENAME}" == "Xio.js 3.x" ||
    "X${NODENAME}" == "XNode.js 0.10" ||
    "X${NODENAME}" == "XNode.js 0.12" ||
    "X${NODENAME}" == "XNode.js 4.x LTS Argon" ||
    "X${NODENAME}" == "XNode.js 5.x" ||
    "X${NODENAME}" == "XNode.js 6.x LTS Boron" ||
    "X${NODENAME}" == "XNode.js 7.x" ||
    "X${NODENAME}" == "XNode.js 8.x LTS Carbon" ||
    "X${NODENAME}" == "XNode.js 9.x" ||
    "X${NODENAME}" == "XNode.js 10.x" ||
    "X${NODENAME}" == "XNode.js 11.x" ||
    "X${NODENAME}" == "XNode.js 12.x" ||
    "X${NODENAME}" == "XNode.js 13.x" ||
    "X${NODENAME}" == "XNode.js 15.x" ||
    "X${NODENAME}" == "XNode.js 17.x" ]]; then

  print_bold " DEPRECATION WARNING " " \

${BOLD}${NODENAME} is no longer actively supported!${NORMAL}
${BOLD}You will not receive security or critical stability updates${NORMAL} for this version.
  
You should migrate to a supported version of Node.js as soon as possible.
Use the installation script that corresponds to the version of Node.js you
wish to install. e.g.

    * ${GREEN}https://deb.nodesource.com/setup_14.x — Node.js 14 \"Fermium\"${NORMAL}
    * ${GREEN}https://deb.nodesource.com/setup_16.x — Node.js 16 \"Gallium\"${NORMAL}
    * ${GREEN}https://deb.nodesource.com/setup_18.x — Node.js 18 LTS \"Hydrogen\"${NORMAL} (recommended)
    * ${GREEN}https://deb.nodesource.com/setup_19.x — Node.js 19 \"Nineteen\"${NORMAL}
    * ${GREEN}https://deb.nodesource.com/setup_20.x — Node.js 20 \"Iron\"${NORMAL} (current)

Please see ${BOLD}https://github.com/nodejs/Release${NORMAL} for details about which version may be appropriate for you.
The ${BOLD}NodeSource${NORMAL} Node.js distributions repository contains information both about supported versions of Node.js and supported Linux distributions. To learn more about usage, see the repository:
    
    ${BOLD}https://github.com/nodesource/distributions${NORMAL}
"
  echo
  echo "Continuing in 20 seconds ..."
  echo
  sleep 20
fi
}
