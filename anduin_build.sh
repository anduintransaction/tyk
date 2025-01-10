#!/bin/env bash

set -e

function build() {
  docker run --rm -it \
    -w /app \
    -u "$(id -u):$(id -g)" \
    -v $(pwd):/app \
    -e "GOCACHE=/tmp/.cache/go-build" \
    goreleaser/goreleaser:v2.5.1 release --clean -f ci/goreleaser/goreleaser-anduin.yml  --snapshot --skip=sign
}

function package() {
  docker build -t internal/tyk-gateway -f ci/Dockerfile.distroless ./dist
}

command=${1:-"package"}
case "$command" in
  build)
    build
    ;;

  package)
    package
    ;;

  *)
    echo "uknown command"
    exit 1
esac

