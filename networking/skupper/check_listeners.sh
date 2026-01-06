#!/usr/bin/env bash

source contexts.env

for CTX in ${K8S_CONTEXTS[@]}; do
    
  echo "*** Listener status ($CTX):"
  kubectl get listeners -A --context="${CTX}" -o wide
  echo

  echo "*** Connector status ($CTX):"
  kubectl get connectors.skupper.io -A --context="${CTX}" -o wide
  echo
  
done





