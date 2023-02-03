# WireGuard

## CIDRs

* `aws-eu-central-1`: `10.0.0.1/24`
* `aws-eu-west-1`: `10.0.0.2/24`
* `aws-us-east-1`: `10.0.0.3/24`
* `aws-us-west-2`: `10.0.0.4/24`
* `az-japaneast`: `10.0.0.5/24`
* `gcp-us-central1`: `10.0.0.6/24`

## Installation

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

# update system and install wireguard
apt update
apt install -y wireguard
```

## Configuration

Create private and public keys on each peer.

```shell
wg genkey > private
wg pubkey < private
```

Save configuration as `/etc/wireguard/wg0.conf`.

```ini
[Interface]
PrivateKey = <PRIVATE-KEY>
Address = 10.0.0.1/32
SaveConfig = true
ListenPort = 51820

# The following is needed only if you have `ufw` installed
#PostUp = iptables -A FORWARD -i wg0 -j ACCEPT; iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE; ip6tables -A FORWARD -i wg0 -j ACCEPT; ip6tables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
#PostDown = iptables -D FORWARD -i wg0 -j ACCEPT; iptables -t nat -D POSTROUTING -o eth0 -j MASQUERADE; ip6tables -D FORWARD -i wg0 -j ACCEPT; ip6tables -t nat -D POSTROUTING -o eth0 -j MASQUERADE

[Peer]
PublicKey = <PUBLIC-KEY>
Endpoint = <PUBLIC-IP>:51820
AllowedIPs = 10.0.0.2/32, 10.0.0.1/32
```

Bring up network interface and test connection.

```shell
wg-quick up wg0
ping 10.0.0.2
```
