# Proof-of-Concept: Kilo

> A Proof-of-concept for using K3s to create a Kubernetes cluster deployed on nodes from different public cloud providers (AWS, GCP, Azure) utilizing [Kilo](https://kilo.squat.ai/)

## Introduction

What’s possible with that?

* Automatic failover even on AZ and cloud level
* Cloud-agnostic setup to select the services and offers that suit the best (mix & match)

## Setup

* [WireGuard](docs/WIREGUARD.md)
* [K3s](docs/K3S.md)

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
* [x] ~~Configure WireGuard network interface on all nodes ([docs](https://www.wireguard.com/quickstart/))~~
* [x] ~~Install K3s on all nodes ([Conceptual Overview](https://www.wireguard.com/#conceptual-overview), [Quick Start](https://docs.k3s.io/quick-start))~~
* [x] ~~Specify topology (annotating location and optionally region)~~
* [x] ~~Deploy Kilo on all nodes~~
* [ ] Figure out how to join the Azure node

## Optional tasks

* [ ] Look into [Cloud-init](https://cloudinit.readthedocs.io/en/latest/) for cloud instance initialisation
