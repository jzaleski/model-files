#!/usr/bin/env bash

set -e;

ADVISOR_MODEL_PORT=${ADVISOR_MODEL_PORT:-8082};
PORT=${PORT:-8080};

docker compose -f $(dirname $0)/../docker-compose-files/open-webui.yml up;
