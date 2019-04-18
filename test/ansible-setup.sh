#!/bin/bash
set -e
echo "Running travis "
DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

SETUP_VERSION="v0.0.3"
#SETUP_VERBOSITY="vv"

## Install Ansible 2.3
ANSIBLE_VERSIONS[0]="2.3.2.0"
INSTALL_TYPE[0]="pip"
ANSIBLE_LABEL[0]="v2.3"

# Whats the default version
ANSIBLE_DEFAULT_VERSION="v2.3"

## Create a temp dir
filename=$( echo ${0} | sed 's|/||g' )
my_temp_dir="$(mktemp -dt ${filename}.XXXX)"

curl -s https://raw.githubusercontent.com/ahelal/avm/${SETUP_VERSION}/setup.sh -o $my_temp_dir/setup.sh

## Run the setup
. $my_temp_dir/setup.sh
