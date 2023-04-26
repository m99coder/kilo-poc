# elevate to root
sudo su

# configure system
export PS1="\[\e[0;32m\][\u@\h \W]$\[\e[m\] "

#locale -a
export LC_ALL=C.UTF-8
export LANG=C.UTF-8
export LANGUAGE=C.UTF-8

alias ll='ls -la --color=auto'

# update system and install wireguard
apt update
apt install -y wireguard