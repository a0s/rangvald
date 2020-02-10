#!/usr/bin/env sh

DIRNAME=$(cd ${0%/*} && pwd -P)
docker build "$DIRNAME" --tag django-todo --file "$DIRNAME/Dockerfile"
