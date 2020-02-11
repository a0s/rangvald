#!/usr/bin/env sh

DIRNAME=$(cd ${0%/*} && pwd -P)
docker-compose \
  --project-directory "$DIRNAME" \
  --file "$DIRNAME/docker-compose.yml" \
  up --remove-orphans --abort-on-container-exit --build
