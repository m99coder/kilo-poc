# WireGuard

## Create keypairs

Create private and public keys on each peer.

```shell
wg genkey > private
wg pubkey < private
```

## Add network interface

```shell
ip link add wg0 type wireguard
# use 10.0.0.2/24 and so on for the other peers to avoid routing issues
ip addr add 10.0.0.1/24 dev wg0
wg set wg0 private-key ./private
ip link set wg0 up

# check setup and get local IP addresses of each peer (192.168.1.x/24)
ip addr
```

## Add peers to WireGuard configuration

```shell
# repeat this step for each peer with the adjusted CIDRs and local IP addresses
wg set wg0 peer <PUBLIC-KEY> allowed-ips 10.0.0.2/32 endpoint 192.168.1.2:51820

# check connection
ping 10.0.0.2

# check status of VPN
wg
```
