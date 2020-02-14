#!/bin/bash

PHP_VERSIONS=(7.3.12 7.1.27)
IMAGE_NAME=claranet/magento-base
LATEST_TAG=7.3.12

for v in ${PHP_VERSIONS[@]}; do
  echo "BUILD IMAGE FOR PHP $v"
  docker build --build-arg PHP_VERSION=$v -t ${IMAGE_NAME}:php-$v .
  docker push ${IMAGE_NAME}:php-$v

  if [ "$v" == "${LATEST_TAG}" ]; then
    echo "Tag Latest"
    docker tag ${IMAGE_NAME}:php-$v ${IMAGE_NAME}:latest
    docker push ${IMAGE_NAME}:latest
  fi
done
