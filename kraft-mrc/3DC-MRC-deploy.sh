#!/usr/bin/env bash

kubectl create namespace dc1
kubectl create namespace dc2
kubectl create namespace dc3

# Label nodes
kubectl label node k8s-master-0 topology.kubernetes.io/zone=europe-central1-a --overwrite
kubectl label node k8s-node-0 topology.kubernetes.io/zone=europe-west1-a --overwrite
kubectl label node k8s-node-1 topology.kubernetes.io/zone=europe-west1-b --overwrite
kubectl label node k8s-node-2 topology.kubernetes.io/zone=europe-west1-c --overwrite
kubectl label node k8s-node-3 topology.kubernetes.io/zone=europe-west2-a --overwrite
kubectl label node k8s-node-4 topology.kubernetes.io/zone=europe-west2-b --overwrite
kubectl label node k8s-node-5 topology.kubernetes.io/zone=europe-west2-c --overwrite

kubectl apply -f 3DC-MRC-kraft-all.yaml
kubectl apply -f 3DC-MRC-kafka.yaml
