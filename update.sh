#!/bin/bash

set -e

BASE_DIR="./"
source "${BASE_DIR}versions.sh"
tags=""


DOCKER_REPO_NAME="maximelaplanche/robert2"

PHP_VERSION="8-apache-buster"

function docker_tag_exists() {
    curl --silent -f --head -lL https://hub.docker.com/v2/repositories/$1/tags/$2/ > /dev/null
}

echo "Update process for robert2 software"

if [ "${DOCKER_PUSH}" = "1" ]; then
  echo "Docker push enabled"
  docker login -u "$CI_DOCKER_HUB_USER" -p "$CI_DOCKER_HUB_PASSWORD" $CI_DOCKER_HUB_URL_REGISTRY
fi

for robert2Version in "${ROBERT2_VERSIONS[@]}"; do

  currentTag="${robert2Version}-php${PHP_VERSION}"
  tags="${tags} ${currentTag}"

  dir="${BASE_DIR}/images/${currentTag}"

  if [ "${GENERATE_IMAGES}" = "1" ]; then
    echo "- Generate Dockerfile for Dolibarr ${robert2Version}"

    echo "  - Create directory : ${dir}"
    mkdir -p "${dir}"

    echo "  - Create Dockerfile"
    sed 's/%PHP_BASE_IMAGE%/'"${PHP_VERSION}"'/;' "${BASE_DIR}/template.Dockerfile" | \
    sed 's/%ROBERT2_VERSION%/'"${robert2Version}"'/;' \
    > "${dir}/Dockerfile"
  fi

  if [ "${DOCKER_BUILD}" = "1" ]; then
    if docker_tag_exists ${DOCKER_REPO_NAME} ${currentTag}; then
        echo "  - Image already exist in registry"
    else
      echo "  - Build image ${DOCKER_REPO_NAME}:${currentTag}"
      docker build -q --pull --compress --tag "${CI_DOCKER_HUB_REGISTRY_IMAGE}:${currentTag}" "${dir}"

      if [ "${DOCKER_PUSH}" = "1" ]; then
        echo "  - Push image ${DOCKER_REPO_NAME}:${currentTag} in registry "
        docker push "${CI_DOCKER_HUB_REGISTRY_IMAGE}:${currentTag}"
        
        if [ "${robert2Version}" = "${DOLIBARR_LATEST_TAG}" ]; then
          echo "  - Push image ${DOCKER_REPO_NAME}:latest in registry "
          docker push ${CI_DOCKER_HUB_REGISTRY_IMAGE}:latest
          tags="${tags} latest"
        fi
      fi
    fi
  fi
done
  echo ${tags}
exit 0