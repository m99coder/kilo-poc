# Proof-of-Concept: Kilo

> A Proof-of-concept for using K3s to create a Kubernetes cluster deployed on nodes from different public cloud providers (AWS, GCP, Azure, …) utilizing [Kilo](https://kilo.squat.ai/)

## Introduction

What’s possible with that?

* Automatic failover even on AZ and cloud level
* Cloud-agnostic setup to select the services and offers that suit the best (mix & match)

## Setup

> [Resource](https://github.com/squat/kilo/issues/11#issuecomment-521211498)

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

## Run

```shell
# create RSA key
ssh-keygen -b 4096 -t rsa -f cloud-key

# init infrastructure
terraform init

# plan infrastructure
terraform plan

# create infrastructure
# can be used with `-target=module.gcp_us_central1` to target specific modules
terraform apply

# show resources and details
terraform state list
terraform state show module.aws_us_east_1.aws_instance.node

# destroy infrastructure
terraform destroy
```

## Open tasks

* [ ] Look into [Cloud-init](https://cloudinit.readthedocs.io/en/latest/) for cloud instance initialisation
* [ ] Install WireGuard on all nodes ([docs](https://www.wireguard.com/install/))
* [ ] Open port UDP 51820 for WireGuard
* [ ] Open port TCP 6443 for K3s
* [ ] Install K3s on all nodes ([docs](https://docs.k3s.io/quick-start))
* [ ] Specify topology (annotating location and region)
* [ ] Deploy Kilo on all nodes
