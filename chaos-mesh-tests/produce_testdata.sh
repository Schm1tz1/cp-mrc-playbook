#!/usr/bin/env bash

kubectl apply -f ./test-topic.yaml
kubectl apply -f ./kcat.yaml
kubectl wait --for=condition=ready pod kcat

ITERS=100000

for i in $(seq 1 $ITERS); do
    echo "Testdata iteration ${i} of ${ITERS}..."
    kubectl exec kcat -it -- bash -c "cat /dev/urandom | \
      tr -dc 'a-zA-Z0-9' | fold -w 128 | head -n 1000 | \
      kcat -F /mnt/configs/kcat-cp-int.conf -t test -P"
done
