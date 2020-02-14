FROM claranet/magento-base:php-7.3.12

ENV MAGENTO_VERSION="2.3.3"
ENV PHP_INI_MEMORY_LIMIT="2048M"
ENV MAGE_MODE=production

SHELL ["/bin/bash", "-c"]

# Download and Extract Magento
RUN mkdir -p /app/public \
 && curl -Ls -o /tmp/magento.tar.gz "https://github.com/magento/magento2/archive/${MAGENTO_VERSION}.tar.gz" \
 && tar -xzf /tmp/magento.tar.gz -C ${DOCUMENT_ROOT} --strip-components=1 \
 && rm /tmp/magento.tar.gz

# Install Sample-Data Components
RUN curl -sL -o /tmp/magento-sampledata.tar.gz "https://github.com/magento/magento2-sample-data/archive/${MAGENTO_VERSION}.tar.gz" \
 && tar -xzf /tmp/magento-sampledata.tar.gz -C ${DOCUMENT_ROOT} --strip-components=1 \
 && rm /tmp/magento-sampledata.tar.gz

RUN cd ${DOCUMENT_ROOT} \
 && composer install --no-dev

RUN php /app/public/bin/magento setup:install --base-url http://127.0.0.1:8080 \
                          --db-host database \
                          --db-user magento \
                          --db-password magento \
                          --db-name magento \
                          --admin-user admin \
                          --admin-password 'Start123!' \
                          --admin-email foo@de.clara.net \
                          --admin-firstname Magento \
                          --admin-lastname Admin \
                          --cleanup-database

RUN php /app/public/bin/magento setup:di:compile
RUN php /app/public/bin/magento setup:static-content:deploy

RUN chown -R www-data:www-data ${DOCUMENT_ROOT}

COPY magento.nginx.conf /etc/nginx/sites-available/magento.conf

