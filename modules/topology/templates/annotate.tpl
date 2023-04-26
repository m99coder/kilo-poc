#!/bin/bash

echo "I’m annotating"

for n in $(sudo kubectl get no -o name | cut -d'/' -f2); do
   echo $n

   sudo kubectl get node $n
done

sudo kubectl annotate node $NODE kilo.squat.ai/location="aws"
sudo kubectl annotate node $NODE kilo.squat.ai/force-endpoint="3.73.159.250:51820"