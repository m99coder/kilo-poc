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

# uninstall k3s
k3s-uninstall
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

# uninstall k3s
k3s-agent-uninstall
```
