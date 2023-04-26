# K3s

## Primary Node

```shell
# elevate to root
sudo su

# install k3s
curl -sfL https://get.k3s.io | sh -s - --node-ip=10.0.0.1 --node-external-ip=10.0.0.1

# annotate location
export NODE_NAME=$(kubectl get nodes -o name) && echo $NODE_NAME
kubectl annotate $NODE_NAME \
  kilo.squat.ai/location="aws" \
  kilo.squat.ai/continent="europe" \
  kilo.squat.ai/region="eu-central-1"
#kubectl describe $NODE_NAME | grep kilo

# get list of nodes
kubectl get nodes

# deploy kilo
kubectl apply -f https://raw.githubusercontent.com/squat/kilo/main/manifests/crds.yaml
kubectl apply -f https://raw.githubusercontent.com/squat/kilo/main/manifests/kilo-k3s.yaml

# get join token
cat /var/lib/rancher/k3s/server/node-token

# uninstall k3s with `/usr/local/bin/k3s-uninstall.sh`
k3s-uninstall.sh
```

## Secondary Nodes

```shell
# elevate to root
sudo su

# get join token and install k3s
export K3S_TOKEN=<TOKEN>
curl -sfL https://get.k3s.io | K3S_URL=https://10.0.0.1:6443 K3S_TOKEN=$K3S_TOKEN sh -

# annotate location
kubectl annotate node/gcp-us-central1-node \
  kilo.squat.ai/location="gcp" \
  kilo.squat.ai/continent="america" \
  kilo.squat.ai/region="us-central1"
#kubectl describe $NODE_NAME | grep kilo

# uninstall k3s with `/usr/local/bin/k3s-agent-uninstall.sh`
k3s-agent-uninstall.sh
```

### Cgroup v2

> Cgroup v1 and Hybrid v1/v2 are not supported; only pure Cgroup v2 is supported. If K3s fails to start due to missing cgroups when running rootless, it is likely that your node is in Hybrid mode, and the "missing" cgroups are still bound to a v1 controller.

_[Source](https://docs.k3s.io/advanced#known-issues-with-rootless-mode)_

For the Azure node, Cgroups v2 had to be enabled by modifying the `cmdline` for GRUB as described [here](https://sleeplessbeastie.eu/2021/09/10/how-to-enable-control-group-v2/).

## Following a blog post

> <https://jbhannah.net/articles/k3s-wireguard-kilo>

### Leader node

```shell
$PUBLIC_IP=3.73.159.250
curl -sfL https://get.k3s.io | sh -s - server --flannel-backend none --node-ip=$PUBLIC_IP --node-external-ip=$PUBLIC_IP

kubectl apply -f https://raw.githubusercontent.com/squat/kilo/main/manifests/crds.yaml
kubectl apply -f https://raw.githubusercontent.com/squat/kilo/main/manifests/kilo-k3s.yaml
```

### Joining node

```shell
TOKEN=XXX
K8S_API=https://3.73.159.250:6443

curl -sfL https://get.k3s.io | K3S_URL=$K8S_API sh -s - agent --token $TOKEN
```

### Connect from local

```shell
export KUBECONFIG=./kubeconfig.yaml
kubectl get nodes
```
