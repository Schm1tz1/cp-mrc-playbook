#!/usr/bin/env bash

kubectl create namespace dc1
kubectl create namespace dc2
kubectl create namespace dc3

kubectl apply -f 3DC-kraft-all.yaml
kubectl apply -f 3DC-kafka.yaml
