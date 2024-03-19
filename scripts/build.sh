#!/bin/bash
# Wraps up Packer with support for environment files and Packer Debug flags
# To use:
# $ build.sh -p .\packfiles\linux\.base.json -e .\environment\myaccount.json -d false
#
set -e

usage() {
  echo "Usage: $0 -p packfile -e environment -d false"
  exit 1
}

if [ "$#" -lt 4 ]; then
  usage;
fi

while getopts p:e:d: OPTION; do
 case "${OPTION}"
 in
    p) PACKFILE=${OPTARG};;

    e) ENVIRONMENT=${OPTARG};;

    d) DEBUG=${6:-false};;

    -h|--help) usage
            exit ;;
    --) shift
      break ;;
    *) usage ;;
  esac
done

DEBUG=""
# example
# .\build.sh -environment ./environment/sandbox.json -packfile ./packfiles/consul-vault
echo "packfile:    ${PACKFILE}"
echo "environment: ${ENVIRONMENT}"

packer validate -var-file="${ENVIRONMENT}" "${PACKFILE}"
if [ "${DEBUG}" = "true" ]; then
    packer build -DEBUG -on-error=ask -var-file="${ENVIRONMENT}" "${PACKFILE}"
else
    packer build  -var-file="${ENVIRONMENT}" "${PACKFILE}"
fi
