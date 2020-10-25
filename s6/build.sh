#!/usr/bin/env bash

if ! [ -x "$(command -v docker)" ]; then
  echo "Using podman to build the image ..."
  podman build --rm -t audius/speedtest-s6 .
fi

if ! [ -x "$(command -v podman)" ]; then
  echo "Using docker to build the image ..."
  docker build --rm -t audius/speedtest-s6 .
fi
