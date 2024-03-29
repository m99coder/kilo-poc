#!/bin/bash
set -euo pipefail

# configure system
export PS1="\[\e[0;32m\][\u@\h \W]$\[\e[m\] "

#locale -a
export LC_ALL=C.UTF-8
export LANG=C.UTF-8
export LANGUAGE=C.UTF-8

# update system and install dependencies
sudo apt update
sudo apt install -y wireguard jq
