#!/usr/bin/env bash

source contexts.env

for CTX in ${K8S_CONTEXTS[@]}; do
    
  echo "*** Link status ($CTX):"
  kubectl get links -A --context="${CTX}" -o wide
  echo

  echo "*** Access grants status ($CTX):"
  kubectl get accessgrants -A --context="${CTX}" -o wide
  echo

  echo "*** Access token status ($CTX):"
  kubectl get accesstokens -A --context="${CTX}" -o wide
  echo

done





