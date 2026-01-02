#!/usr/bin/env bash

source contexts.env

counter=1
declare -A clusters
declare -A networks

for CTX in ${K8S_CONTEXTS[@]}
do
    CLUSTER="cluster${counter}"
    NETWORK="network${counter}"
    NAMESPACE="confluent"

    clusters[${CTX}]=$CLUSTER
    networks[${CTX}]=$NETWORK

    echo "Installing Skupper in k8s context ${CTX} for cluster ${CLUSTER} and network ${NETWORK}..."

    # Deploy Skupper
    kubectl apply -f https://skupper.io/v2/install.yaml --context="${CTX}"

    # Deploy Site
    cat <<EOF | envsubst  
apiVersion: skupper.io/v2alpha1
kind: Site
metadata:
  name: ${NETWORK}
  namespace: ${NAMESPACE}
spec:
  linkAccess: default
EOF
    
    ((counter++))  
done

