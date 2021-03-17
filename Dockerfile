ARG PHP_VERSION=7.3.12
FROM claranet/php:1.1-php${PHP_VERSION}

ENV PHPFPM_HOST=localhost \
    PHPFPM_PORT=9000

ENV MAGE_ROOT=$DOCUMENT_ROOT

RUN apt-get update && apt-get install -y tree vim redis-tools mysql-client netcat curl iputils-ping less python3 rsyslog \
 && apt-get install -y \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libmcrypt-dev \
        libzip-dev \
        libpng-dev \
        libxslt1-dev \
        libicu-dev \
        mcrypt \
 && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
 && docker-php-ext-install intl pdo_mysql soap zip gd xsl bcmath
 
 RUN case "${PHP_VERSION}" in \
      7.1.*) docker-php-ext-install mcrypt ;; \
      7.2.*) pecl install mcrypt-1.0.1  && docker-php-ext-enable mcrypt;; \
    esac

# Install Composer
RUN curl -o /tmp/composer-setup.php https://getcomposer.org/installer \
 && php -n /tmp/composer-setup.php --install-dir=/usr/local/bin --filename=composer \
 && rm /tmp/composer-setup.php \
 && chmod +x /usr/local/bin/composer 

RUN curl -sL -o /usr/local/bin/kubectl https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl \
 && chmod +x /usr/local/bin/kubectl  \
 && chown nginx:nginx ${WORKDIR} -R

RUN mkdir -p /kubernetes/ /kubernetes/config/ /kubernetes/nfs/ ${WORKDIR}/data
RUN mkdir -p ${DOCUMENT_ROOT}/app/etc/ 

RUN chown www-data:www-data /kubernetes/nfs/ ${DOCUMENT_ROOT} ${WORKDIR}/data

COPY conf/rsyslog.conf /etc/rsyslog.conf
COPY conf/sites-available/magento.conf ${NGINX_SITES_AVAILABLE}/magento.conf
COPY conf/conf.d/fastcgi_params.conf /etc/nginx/fastcgi_params
COPY conf/magento-php.ini ${PHP_INI_DIR}/magento-php.ini
COPY bin/* /usr/local/bin/
COPY ./docker ${WORKDIR}/docker

# Cleanup
RUN rm -rf /var/lib/apt/lists/* \
 && rm -rf /tmp/* 






