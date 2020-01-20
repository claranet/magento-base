# Magento Base Image

This project contains two build instructions for Magento Base image. First ist the base docker image for Magento. It depends on the offical php Image with included Apache2 webserver. This container will install all requirements for Magento's default Shopsystem. The second Image inherits the first and will include some functions and scripts for Kubernetes.

Magento Requirements: https://devdocs.magento.com/guides/v2.2/install-gde/system-requirements-tech.html

## Usage

These Images are designed to be a base image for the final Magento Image. This base images are developed and build by Claranet. The Agencies should use this base-images to build the final Magento Shop-Container including all Extensions end needed requirements.

Example Agency Dockerfile:

    FROM claranet/magento-base:php-7.1.0
    ENV MAGENTO_VERSION=2.2.1
    COPY ./src $APP_HOME
    RUN chown -R www-data:www-data ${APP_HOME}

## Hooks

### CRON

Path: /docker/magento.d/cron/

Default: 50_default.sh

Per default only `magento cron:run` is called

### Upgrade

Path: /docker/magento.d/upgrade/

Default: none

### Install

Path: /docker/magento.d/install

Default: 00_default.sh

Creates some default directories on fresh installation

# Build

    docker build -t claranet/magento-base .
