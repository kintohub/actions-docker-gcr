#!/bin/bash

set -e

: ${INPUT_REGISTRY:=gcr.io}
: ${INPUT_IMAGE:=$GITHUB_REPOSITORY}
: ${INPUT_TAG:=$GITHUB_SHA}

if [ -n "${INPUT_GCLOUD_KEY}" ]; then
  echo "Logging into gcr.io with INPUT_GCLOUD_KEY..."
  echo ${INPUT_GCLOUD_KEY} | base64 --decode --ignore-garbage > /tmp/key.json
  gcloud auth activate-service-account --quiet --key-file /tmp/key.json
  gcloud auth configure-docker --quiet
else
  echo "INPUT_GCLOUD_KEY was empty, not performing auth" 1>&2
fi

echo "Pulling $INPUT_REGISTRY/$INPUT_IMAGE:$INPUT_TAG"
docker pull $INPUT_REGISTRY/$INPUT_IMAGE:$INPUT_TAG

if [ -n "${INPUT_NEW_TAG}" ]; then
  echo "Tagging $INPUT_REGISTRY/$INPUT_IMAGE:$INPUT_TAG to $INPUT_REGISTRY/$INPUT_IMAGE:$INPUT_NEW_TAG"
  docker tag $INPUT_REGISTRY/$INPUT_IMAGE:$INPUT_TAG $INPUT_REGISTRY/$INPUT_IMAGE:$INPUT_NEW_TAG
fi

