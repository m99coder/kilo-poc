#!/bin/bash

echo "I’m a node"

sudo curl -sfL https://get.k3s.io | K3S_URL=${LEADER_ENDPOINT} sudo sh -s - agent --token ${TOKEN}