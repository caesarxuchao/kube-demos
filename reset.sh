#!/bin/bash

. $(dirname ${BASH_SOURCE})/util.sh
kubectl delete namespace demos
while kubectl get namespace demos >/dev/null 2>&1; do
   kubectl get namespace demos
done
kubectl apply -f $(relative demo-namespace.yaml)
tmux kill-session -t my-session
