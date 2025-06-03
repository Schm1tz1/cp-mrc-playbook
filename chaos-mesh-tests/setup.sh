#!/usr/bin/env bash

helm repo add chaos-mesh https://charts.chaos-mesh.org
helm repo update

kubectl create ns chaos-mesh

helm install chaos-mesh chaos-mesh/chaos-mesh \
  -n=chaos-mesh --set chaosDaemon.runtime=containerd \
  --set dashboard.securityMode=false \
  --set chaosDaemon.socketPath=/run/k3s/containerd/containerd.sock

kubectl apply -f chaosmesh-dashboard-ingressroute.yaml

# kubectl apply -f rbac.yaml
# kubectl create token account-cluster-manager-jhfrk
