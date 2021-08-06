#!/bin/bash
set +x

PUSH_IMAGE=${PUSH_IMAGE:-1}
BASE_VERSION=1.1.5
PHP_VERSIONS=(7.3.27 7.4.19)
CLARA_PHP_TAG=${CLARA_PHP_TAG:-1.1.57}
IMAGE_NAME=claranet/magento-base

build_phpbase() {
  WORKDIR=$(mktemp -d)
  
  cd ${WORKDIR}
  git clone https://github.com/claranet/php.git ./
  git fetch --all --tags
  git checkout ${CLARA_PHP_TAG}
  export PHP_EXTENSION=(gd intl pdo_mysql soap zip gd xsl bcmath sockets mcrypt) 
  PHP_VERSION=${PHP_VERSION} FROM_IMAGE=php:${PHP_VERSION}-fpm-buster ./bin/image.sh build
  cd $OLDPWD
  rm -rf ${WORKDIR}
}

build_magentobase() {
  echo "BUILD IMAGE FOR PHP ${PHP_VERSION}"
  BUILD_TAG=$1
  docker build -t $1 \
               --build-arg FROM_IMAGE=local/claranet/php:${CLARA_PHP_TAG}-php${PHP_VERSION} \
               --build-arg PHP_VERSION \
               .
  
  shift
  while [[ ! -z "$1" ]]; do
    echo "Tag ${BUILD_TAG} to $1"
    docker tag ${BUILD_TAG} $1
    shift
  done
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
build_magentobase ${IMAGE_TAGS[*]}
push_image

done
