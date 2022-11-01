#!/bin/bash

source "${BASE_DIR}versions.sh"

export ROBERT2_VERSION=0.19.3

docker-compose -f docker-compose.yml -f docker-compose.dev.yml up -d --build
