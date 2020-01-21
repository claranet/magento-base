# Magento Base Image

This project contains two build instructions for Magento Base image. First ist the base docker image for Magento. It depends on the offical php Image with included Apache2 webserver. This container will install all requirements for Magento's default Shopsystem. The second Image inherits the first and will include some functions and scripts for Kubernetes.

Magento Requirements: https://devdocs.magento.com/guides/v2.2/install-gde/system-requirements-tech.html

## Usage

These Images are designed to be a base image for the final Magento Image. This base images are developed and build by Claranet. The Agencies should use this base-images to build the final Magento Shop-Container including all Extensions end needed requirements.

Example Agency Dockerfile:

```Dockerfile
FROM claranet/magento-base:latest  # Extend from latest base image
ENV MAGENTO_VERSION=2.2.1          # Set ENV Variables
COPY . /app/public/                # Copy the sourcecode
````

```bash
docker build -t myshop:latest .
```


## Hooks

The baseimage delivers sime entrypoints to run magento in different mode such as cron, install upgrade etc.
This entrypoints are designed to override or extend by user. We only delivers some default scripts here.

You can override or exend by placing a script-file into the given folder below during build the image.

### Magento NGINX

Path: /app/docker/start.d/nginx/

Default: [500_magento.sh](docker/start.d/500_magento.sh)

### Magento PHPFPM

Path: /app/docker/start.d/phpfpm/

Default: [500_magento.sh](docker/start.d/500_magento.sh)

### CRON

Path: /app/docker/magento.d/cron/

Default: [00_init.sh](docker/magento.d/cron/00_init.sh), [50_default.sh](docker/magento.d/cron/50_default.sh)

Per default only `magento cron:run` is called

### Upgrade

Path: /app/docker/magento.d/upgrade/

Default: none

### Install

Path: /app/docker/magento.d/install

Default: [00_default.sh](docker/magento.d/install/00_default.sh)

Creates some default directories on fresh installation

# Build

    docker build -t claranet/magento-base .
