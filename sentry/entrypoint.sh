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

echo "Running sentry script"

docker run --entrypoint '/bin/sh' $INPUT_REGISTRY/$INPUT_IMAGE:$INPUT_TAG -c '
yarn global add @sentry/cli
export SENTRY_ORG='$INPUT_SENTRY_ORG'
export SENTRY_PROJECT='$INPUT_SENTRY_PROJECT'
export SENTRY_AUTH_TOKEN='$INPUT_SENTRY_TOKEN'
sentry-cli releases list
sentry-cli releases new '$INPUT_TAG'
sentry-cli releases finalize '$INPUT_TAG'
sentry-cli releases files '$INPUT_TAG' upload-sourcemaps static/js/ --rewrite --url-prefix "~/static/js"
'