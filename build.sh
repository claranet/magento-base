#!/bin/bash

PHP_VERSION=${PHP_VERSION:-7.3.27}
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
  docker build --tag ${IMAGE_NAME}:php-${PHP_VERSION} \
               --build-arg FROM_IMAGE=local/claranet/php:1.1.48-php${PHP_VERSION} \
               --build-arg PHP_VERSION \
                .
}

build_phpbase 
build_magentobase

cat <<EOF

---

To push the Image run
$ docker push ${IMAGE_NAME}:php-${PHP_VERSION}

To Tag as latest
$ docker tag ${IMAGE_NAME}:php-${PHP_VERSION} ${IMAGE_NAME}:latest
$ docker push ${IMAGE_NAME}:latest
EOF
