#!/bin/bash

echo "I’m the leader"

sudo curl -sfL https://get.k3s.io | sudo sh -s - server --flannel-backend none --node-ip=${PUBLIC_IP} --node-external-ip=${PUBLIC_IP} --token ${TOKEN} --node-label "public-ip=${PUBLIC_IP}:51820" --node-label "location=${LOCATION}"
