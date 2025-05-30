#!/usr/bin/env bash

kubectl create namespace dc1
kubectl create namespace dc2
kubectl create namespace dc3

kubectl apply -f replica-placement.yaml -n dc1
kubectl apply -f replica-placement.yaml -n dc2
kubectl apply -f replica-placement.yaml -n dc3

kubectl apply -f 25DC-kraft-all.yaml
kubectl apply -f 25DC-kafka.yaml
