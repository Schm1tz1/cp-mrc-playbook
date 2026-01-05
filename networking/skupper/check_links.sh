#!/usr/bin/env bash

source contexts.env

for CTX in ${K8S_CONTEXTS[@]}; do
    
  echo "*** Link status ($CTX):"
  kubectl get links -A --context="${CTX}" -o wide
  echo

done





