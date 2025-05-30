#!/usr/bin/env bash

if [ "$#" -ne 1 ]; then
    echo "Usage $0 <namespace>"
    exit 1
fi

NAMESPACE="${1}"

echo "Patching kafkas..."

kubectl patch kafkas -n ${NAMESPACE} \
  $(kubectl get kafkas -n ${NAMESPACE} -o json | jq -r '.items[].metadata.name') \
  --patch-file jmx-kafka-patch.yaml  --type=merge