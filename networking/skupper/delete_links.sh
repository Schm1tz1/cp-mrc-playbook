#!/usr/bin/env bash

source contexts.env
NAMESPACE="confluent"

for CTX in ${K8S_CONTEXTS[@]}; do

  kubectl delete links --all --context="${CTX}" -n ${NAMESPACE}
  kubectl delete accesstoken -n ${NAMESPACE} --context="${CTX}" --all
  kubectl delete accessgrant -n ${NAMESPACE} --context="${CTX}" --all

done
