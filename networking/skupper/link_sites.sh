#!/usr/bin/env bash

source contexts.env
MAX_LINKS=${#CREATE_LINKS[@]}
MAX_REDEMPTIONS=$(($MAX_LINKS*5))
NAMESPACE="confluent"

for i in ${CREATE_LINKS[@]}; do
  FROM_CTX=$(echo $i | awk -F: '{print $1}')
  TO_CTX=$(echo $i | awk -F: '{print $2}')
  echo "*** Creating link: $FROM_CTX => $TO_CTX ***"

  # Create Access Grant in destination network
  cat <<EOF | envsubst | kubectl apply --context="${TO_CTX}" -f -
apiVersion: skupper.io/v2alpha1
kind: AccessGrant
metadata:
  name: grant-${TO_CTX}
  namespace: ${NAMESPACE}
spec:
  redemptionsAllowed: ${MAX_REDEMPTIONS}  # default 1
  expirationWindow: 60m        # default 15m
EOF

  kubectl get accessgrants -A --context="${TO_CTX}" -o wide
  echo

  # Extract Access Grant details
  URL="$(kubectl --context ${TO_CTX} -n ${NAMESPACE} get accessgrant grant-${TO_CTX} -o template --template '{{ .status.url }}')"
  CODE="$(kubectl --context ${TO_CTX} -n ${NAMESPACE} get accessgrant grant-${TO_CTX} -o template --template '{{ .status.code }}')"
  CA_RAW="$(kubectl --context ${TO_CTX} -n ${NAMESPACE} get accessgrant grant-${TO_CTX} -o template --template '{{ .status.ca }}')"

  # Create and deploy Access Token in source network
  cat <<EOF | envsubst | kubectl apply --context="${FROM_CTX}" -f -
apiVersion: skupper.io/v2alpha1
kind: AccessToken
metadata:
  name: token-${FROM_CTX}-to-${TO_CTX}
  namespace: ${NAMESPACE}
spec:
  code: "$(printf '%s' "$CODE")"
  ca: |- 
$(printf '%s\n' "$CA_RAW" | sed 's/^/    /')
  url: "$(printf '%s' "$URL")"
EOF

  echo "*** Access token status ($FROM_CTX):"
  kubectl get accesstokens -A --context="${FROM_CTX}" -o wide
  echo

  echo "*** Link status ($FROM_CTX):"
  kubectl get links -A --context="${FROM_CTX}" -o wide
  echo

done





