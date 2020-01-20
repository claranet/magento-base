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

## Script Collections

Some scripts are included to the Images. Note that Kubernetes and Helm expect some of this scripts!

### Base Image

___cache-warmer___ - 

___docker-magento-entrypoint___ - Default entrypoint on image startup - It will do nothing special. It is reserverved to overide by Magento Developer

___docker-magento-upgrade___ - Default upgrade script - It will set Magento to maintenance mode, flush caches and do a database upgrade over MagentoCLI

___magento___ - Just a small MagentoCLI wrapper to place on /usr/local/bin

___magento-cron___ - Magento CRON wrappe to place in /usr/local/bin - Default it will call `magento cron:run` to execute Magento Jobs. It is reserved to override by Magento Developer

___kubernetes-magento-build (UNDER CONSTRUCTION)___ - Used to build static PHP-Files

___kubernetes-magento-entrypoint___ - Default Entrypoint for kubernetes

___kubernetes-magento-install___ - Magento Install routines for Kubernetes - By Default it will be called by helm during first installation

___kubernetes-magento-upgrade___ - Magento Upgrade routines for Kubernetes . By Default it will be called by helm during a upgrade

___magento___ - MagnetoCLI wrapper for Kubernetes

# Build

    docker build -t claranet/magento-base .
