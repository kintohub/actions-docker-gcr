#!/bin/bash

set -e

: ${INPUT_REGISTRY:=gcr.io}
: ${INPUT_IMAGE:=$GITHUB_REPOSITORY}
: ${INPUT_ARGS:=} # Default: empty build args
: ${INPUT_TAG:=$GITHUB_SHA}
: ${INPUT_LATEST:=true}

echo "Building $INPUT_REGISTRY/$INPUT_IMAGE:$INPUT_TAG"
docker build $INPUT_ARGS -t $INPUT_REGISTRY/$INPUT_IMAGE:$INPUT_TAG $INPUT_WORKING_DIRECTORY/.

if [ $INPUT_LATEST = true ]; then
  echo "Tagging $INPUT_REGISTRY/$INPUT_IMAGE:$INPUT_TAG to $INPUT_REGISTRY/$INPUT_IMAGE:latest"
  docker tag $INPUT_REGISTRY/$INPUT_IMAGE:$INPUT_TAG $INPUT_REGISTRY/$INPUT_IMAGE:latest
fi
