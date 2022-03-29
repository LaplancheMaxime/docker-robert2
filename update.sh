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

echo "- Update process for robert2 software"

if [ "${DOCKER_PUSH}" = "1" ]; then
  echo "Docker push enabled"
  docker login -u "$CI_DOCKER_HUB_USER" -p "$CI_DOCKER_HUB_PASSWORD" $CI_DOCKER_HUB_URL_REGISTRY
fi

for robert2Version in "${ROBERT2_VERSIONS[@]}"; do

  currentTag="${robert2Version}-php${PHP_VERSION}"
  tags="${tags} ${robert2Version}"
  tags="${tags} ${currentTag}"

  dir="${BASE_DIR}images/${currentTag}"

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
        echo "  - Image ${DOCKER_REPO_NAME}:${currentTag} already exist in registry"
    else
      if [ "${robert2Version}" = "${ROBERT2_LATEST_TAG}" ]; then
        echo "  - Build image ${DOCKER_REPO_NAME}:${currentTag}, ${CI_DOCKER_HUB_REGISTRY_IMAGE}:${robert2Version}, latest"
        docker build -q --pull --compress --tag "${CI_DOCKER_HUB_REGISTRY_IMAGE}:${currentTag}" --tag "${CI_DOCKER_HUB_REGISTRY_IMAGE}:${robert2Version}" --tag "${CI_DOCKER_HUB_REGISTRY_IMAGE}:latest" "${dir}"
      else
        echo "  - Build image ${DOCKER_REPO_NAME}:${currentTag}"
        docker build -q --pull --compress --tag "${CI_DOCKER_HUB_REGISTRY_IMAGE}:${currentTag}" --tag "${CI_DOCKER_HUB_REGISTRY_IMAGE}:${robert2Version}" "${dir}"
      fi
      
      if [ "${DOCKER_PUSH}" = "1" ]; then
        echo "  - Push image ${DOCKER_REPO_NAME}:${currentTag} in registry "
        docker push -q "${CI_DOCKER_HUB_REGISTRY_IMAGE}:${currentTag}"
        
        echo "  - Push image ${DOCKER_REPO_NAME}:${robert2Version} in registry "
        docker push -q "${CI_DOCKER_HUB_REGISTRY_IMAGE}:${robert2Version}"
        
        if [ "${robert2Version}" = "${ROBERT2_LATEST_TAG}" ]; then
          echo "  - Push image ${DOCKER_REPO_NAME}:latest in registry "
          docker push -q ${CI_DOCKER_HUB_REGISTRY_IMAGE}:latest
          tags="${tags} latest"
        fi
      fi
    fi
  fi
done
  echo ${tags}
exit 0