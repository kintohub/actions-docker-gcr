#!/bin/bash

set -e

n=0
until [ "$n" -ge 5 ]
do
  argocd app actions run \
    --server $INPUT_SERVER \
    --kind $INPUT_KIND \
    --namespace $INPUT_NAMESPACE \
    --resource-name $INPUT_NAME \
    $INPUT_APP $INPUT_ACTION && break
  n=$((n+1))
  sleep 5
done