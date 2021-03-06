#!/usr/bin/env sh

DIRNAME=$(cd ${0%/*} && pwd -P)
DOCKER_FILE="Dockerfile"
IMAGE_TAG="django-todo"
docker build "$DIRNAME" \
  --tag "$IMAGE_TAG" \
  --file "$DIRNAME/$DOCKER_FILE"
