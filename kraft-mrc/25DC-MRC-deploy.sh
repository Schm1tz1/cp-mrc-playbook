#!/usr/bin/env bash

kubectl create namespace dc1
kubectl create namespace dc2
kubectl create namespace dc3

kubectl apply -f replica-placement.yaml -n dc1
kubectl apply -f replica-placement.yaml -n dc2
kubectl apply -f replica-placement.yaml -n dc3

kubectl apply -f 25DC-MRC-kraft-all.yaml

cat 25DC-MRC-kafka.tpl | sed -e 's/##DC##/dc1/g;s/##RACK##/dc1-a/g;s/##OFFSET##/100/g' | kubectl apply -f -
cat 25DC-MRC-kafka.tpl | sed -e 's/##DC##/dc1/g;s/##RACK##/dc1-b/g;s/##OFFSET##/110/g' | kubectl apply -f -
cat 25DC-MRC-kafka.tpl | sed -e 's/##DC##/dc1/g;s/##RACK##/dc1-c/g;s/##OFFSET##/120/g' | kubectl apply -f -
cat 25DC-MRC-kafka.tpl | sed -e 's/##DC##/dc2/g;s/##RACK##/dc2-a/g;s/##OFFSET##/200/g' | kubectl apply -f -
cat 25DC-MRC-kafka.tpl | sed -e 's/##DC##/dc2/g;s/##RACK##/dc2-b/g;s/##OFFSET##/210/g' | kubectl apply -f -
cat 25DC-MRC-kafka.tpl | sed -e 's/##DC##/dc2/g;s/##RACK##/dc2-c/g;s/##OFFSET##/220/g' | kubectl apply -f -
