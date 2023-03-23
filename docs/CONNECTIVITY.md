# Connectivity

```shell
# start at least 2 nodes
terraform apply -target=module.gcp_us_central1 -target=module.aws_eu_central_1
```

Now SSH into first node.

```shell
# elevate to root
sudo su

# configure system
export PS1="\[\e[0;32m\][\u@\h \W]$\[\e[m\] "

#locale -a
export LC_ALL=C.UTF-8
export LANG=C.UTF-8
export LANGUAGE=C.UTF-8

alias ll='ls -la --color=auto'

# update system
apt update

# install nmap and wireguard
apt install -y nmap wireguard

# check connectivity
netstat -pln # or `ss -l`
nmap -sU -p 51820 <SECOND-NODE-IP>
```
