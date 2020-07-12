#!/bin/bash

set -e

argocd app actions run \
  --server $INPUT_SERVER \
  --kind $INPUT_KIND \
  --namespace $INPUT_NAMESPACE \
  --resource-name $INPUT_NAME \
  kinto-frontend restart
