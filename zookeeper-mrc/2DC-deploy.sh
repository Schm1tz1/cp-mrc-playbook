#!/usr/bin/env bash

kubectl create namespace dc1
kubectl create namespace dc2

kubectl apply -f 2DC-zookeeper.yaml
kubectl apply -f 2DC-kafka.yaml
