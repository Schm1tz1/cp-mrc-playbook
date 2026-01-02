#!/usr/bin/env bash

source contexts.env

for CTX in ${K8S_CONTEXTS[@]}; do
    kubectl delete -f https://skupper.io/install.yaml --context ${CTX}
done
