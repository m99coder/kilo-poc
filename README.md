# Proof-of-Concept: Kilo

> A Proof-of-concept for using K3s to create a Kubernetes cluster deployed on nodes from different public cloud providers (AWS, GCP, Azure) utilizing [Kilo](https://kilo.squat.ai/)

## Introduction

What’s possible with that?

* Automatic failover even on AZ and cloud level
* Cloud-agnostic setup to select the services and offers that suit the best (mix & match)

## Setup

> [Source](https://github.com/squat/kilo/issues/11#issuecomment-521211498)

<details>
  <summary>Thread from issue 11</summary>

```shell
# Node 1
# Boot the node in AWS. Make sure to open ports TCP 6443 and UDP 51820.
sudo add-apt-repository ppa:wireguard/wireguard
sudo apt-get update
sudo apt-get install wireguard --yes

# k3s now needs the --node-ip (--node-external-ip for Azure) flag because of a recent PR:
# https://github.com/rancher/k3s/pull/676.
# curl -sfL https://get.k3s.io | sh -s - --node-ip=$SERVER_IP --write-kubeconfig=/etc/kubernetes/admin.conf
curl -sfL https://get.k3s.io | sh -s - --node-ip=$SERVER_IP
sudo kubectl annotate node $SERVER_NAME kilo.squat.ai/location="aws"

# get nodes
kubectl get nodes -o wide

# Note the ENTIRE string for use by node2.
sudo cat /var/lib/rancher/k3s/server/node-token

# Node 2
# Boot the node in GCP. Make sure to open port UDP 51820.
sudo add-apt-repository ppa:wireguard/wireguard
sudo apt-get update
sudo apt-get install wireguard --yes

# k3s
curl -sfL https://get.k3s.io | K3S_URL=https://$SERVER_IP:6443 K3S_TOKEN=$TOKEN sh -
sudo kubectl annotate node $SERVER_NAME kilo.squat.ai/location="gcp"

# Node 1
# If your nodes do not have the public IP assigned to the interface, we must
# explicitly specify them.
sudo kubectl annotate node $SERVER_NAME kilo.squat.ai/force-external-ip="$SERVER_IP/32"
sudo kubectl annotate node $NODE_NAME kilo.squat.ai/force-external-ip="$NODE_IP/32"

# Deploy kilo
sudo kubectl apply -f https://raw.githubusercontent.com/squat/kilo/master/manifests/kilo-k3s-flannel.yaml

# get all nodes
sudo kubectl get pods -o wide --all-namespaces
```

</details>

### Primary node

```shell
# elevate to root user
sudo su

# install wireguard
apt update
apt install wireguard
#sudo apt install wireguard wireguard-tools linux-headers-$(uname -r)

# k3s
export PUBLIC_IP=$(curl -s ifconfig.me) && echo $PUBLIC_IP
curl -sfL https://get.k3s.io | sh -s - --node-ip=$PUBLIC_IP --node-external-ip=$PUBLIC_IP
kubectl get nodes -o wide

# annotate location
export NODE_NAME=$(kubectl get nodes -o name) && echo $NODE_NAME
kubectl annotate $NODE_NAME kilo.squat.ai/location="aws"

# get join token
cat /var/lib/rancher/k3s/server/node-token

# kilo
kubectl apply -f https://raw.githubusercontent.com/squat/kilo/main/manifests/crds.yaml
kubectl apply -f https://raw.githubusercontent.com/squat/kilo/main/manifests/kilo-k3s.yaml
```

### Secondary nodes

```shell
# k3s
curl -sfL https://get.k3s.io | K3S_URL=https://$PUBLIC_IP:6443 K3S_TOKEN=$TOKEN sh -
```

## Run

```shell
# create RSA key
ssh-keygen -b 4096 -t rsa -f ~/.ssh/cloud-key

# init, plan, and apply infrastructure
# use `-target=module.gcp_us_central1` to target specific modules
terraform init
terraform plan
terraform apply

# show resources and details
terraform state list
terraform state show module.aws_us_east_1.aws_instance.node

# destroy infrastructure
terraform destroy
```

## Open tasks

* [x] ~~Ensure all nodes use Debian 11~~
* [x] ~~Open port UDP 51820 for WireGuard (inbound and outbound)~~
* [x] ~~Install WireGuard on all nodes ([docs](https://www.wireguard.com/install/))~~
* [ ] Configure WireGuard network interface on all nodes ([docs](https://www.wireguard.com/quickstart/))
* [ ] Install K3s on all nodes ([Conceptual Overview](https://www.wireguard.com/#conceptual-overview), [Quick Start](https://docs.k3s.io/quick-start))
* [ ] Specify topology (annotating location and optionally region)
* [ ] Deploy Kilo on all nodes

## Optional tasks

* [ ] Look into [Cloud-init](https://cloudinit.readthedocs.io/en/latest/) for cloud instance initialisation
