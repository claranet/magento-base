ARG PHP_VERSION=7.3.13
ARG FROM_IMAGE=claranet/php:1.1.48-php${PHP_VERSION}

FROM ${FROM_IMAGE}

LABEL claranet.magento-base.version="1.1.1" \
      claranet.magento-base.author="Martin Weber"

ENV PHPFPM_HOST=localhost \
    PHPFPM_PORT=9000

ENV MAGE_ROOT=$DOCUMENT_ROOT

# Install required tools
RUN apt-get update && apt-get install -y tree vim redis-tools default-mysql-client netcat curl iputils-ping less python3 rsyslog

# Install Magento Dependencies and required libraries
RUN apt-get install -y \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libmcrypt-dev \
        libzip-dev \
        libpng-dev \
        libxslt1-dev \
        libicu-dev \
        mcrypt \
 && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
 && docker-php-ext-install intl pdo_mysql soap zip gd xsl bcmath sockets

RUN case "${PHP_VERSION}" in \
    7.1.*) docker-php-ext-install mcrypt ;; \
    7.2.*) pecl install mcrypt  && docker-php-ext-enable mcrypt;; \
    7.3.*) pecl install mcrypt  && docker-php-ext-enable mcrypt;; \
  esac

# Install Composer
RUN curl -o /tmp/composer-setup.php https://getcomposer.org/installer \
 && php -n /tmp/composer-setup.php --install-dir=/usr/local/bin --filename=composer \
 && rm /tmp/composer-setup.php \
 && chmod +x /usr/local/bin/composer 

# Install Mage-Run
RUN curl -o /usr/local/bin/magerun https://files.magerun.net/n98-magerun.phar \
 && chmod +x /usr/local/bin/magerun

# Install Kubernetes CLI (kubecli)
RUN curl -sL -o /usr/local/bin/kubectl https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl \
 && chmod +x /usr/local/bin/kubectl  \
 && chown nginx:nginx ${WORKDIR} -R

# Create required directories
RUN mkdir -p /kubernetes/ /kubernetes/config/ /kubernetes/nfs/ ${WORKDIR}/data \
 && mkdir -p ${DOCUMENT_ROOT}/app/etc/ \
  && chown www-data:www-data /kubernetes/nfs/ ${DOCUMENT_ROOT} ${WORKDIR}/data


RUN ln -s /app/docker/shared_steps/configure_ssmtp.sh /app/docker/z00_configure_smtp.inc.sh \
 && ln -s /app/docker/shared_steps/rsyslog.sh /app/docker/z00_rsyslog.inc.sh \
 && ln -s /app/docker/shared_steps/magento_bootstrap.sh /app/docker/z99_magento_bootstrap.inc.sh

COPY conf/usr/local/etc/php/conf.d/mailing.ini /usr/local/etc/php/conf.d/mailing.ini
COPY conf/etc/rsyslog.conf /etc/rsyslog.conf
COPY conf/etc/nginx/sites-available/magento.conf ${NGINX_SITES_AVAILABLE}/magento.conf
COPY conf/etc/nginx/fastcgi_params /etc/nginx/fastcgi_params
COPY conf/usr/local/etc/php/magento-php.ini ${PHP_INI_DIR}/magento-php.ini
COPY bin/* /usr/local/bin/
COPY ./docker ${WORKDIR}/docker

# Cleanup
RUN rm -rf /var/lib/apt/lists/* \
 && rm -rf /tmp/* 
