#!/bin/bash

PUSH_IMAGE=${PUSH_IMAGE:-1}
BASE_VERSION=1.1.0
PHP_VERSIONS=(7.3.27)
IMAGE_NAME=claranet/magento-base

build_phpbase() {
  WORKDIR=$(mktemp -d)
  cd ${WORKDIR}
  git clone https://github.com/claranet/php.git ./
  git fetch
  git checkout --track origin/feature/debian-buster
  PHP_VERSION=${PHP_VERSION} FROM_IMAGE=php:${PHP_VERSION}-fpm-buster ./bin/image.sh build
  cd $OLDPWD
  rm -rf ${WORKDIR}
}

build_magentobase() {
  echo "BUILD IMAGE FOR PHP ${PHP_VERSION}"
  docker build $(IFS="-t "; echo "${IMAGE_TAGS}") \
               --build-arg FROM_IMAGE=local/claranet/php:1.1.48-php${PHP_VERSION} \
               --build-arg PHP_VERSION \
                .
}

push_image() {
  for IMAGE_TAG in ${IMAGE_TAGS[@]}; do
    if [[ "${PUSH_IMAGE}" -eq "1" ]]
    then
      docker push ${IMAGE_TAG}
    else
      echo "Push Image - docker push ${IMAGE_TAG}"
  fi

  done
}
for PHP_VERSION in ${PHP_VERSIONS[@]}; do

IMAGE_TAGS=(  "${IMAGE_NAME}:php-${PHP_VERSION}" \
              "${IMAGE_NAME}:${BASE_VERSION}-php-${PHP_VERSION}" )

build_phpbase 
build_magentobase
push_image

done
