FROM php:8-apache-buster

LABEL maintainer="Maxime LAPLANCHE <maxime.laplanche@outlook.com>"

ENV ROBERT2_VERSION 0.20.6

ENV PHP_INI_DATE_TIMEZONE 'Europe/Paris'
ENV PHP_INI_MEMORY_LIMIT 256M
ENV TZ=Europe/Paris 

RUN apt-get update -y \
    && apt-get dist-upgrade -y \
    && apt-get install -y --no-install-recommends \
        libc-client-dev \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libkrb5-dev \
        libldap2-dev \
        libpng-dev \
        libpq-dev \
        libxml2-dev \
        libzip-dev \
        default-mysql-client \
        postgresql-client \
        unzip \
    && apt-get autoremove -y \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) calendar intl mysqli pdo_mysql gd soap zip apcu bcmath gettext \
    && docker-php-ext-configure pgsql -with-pgsql \
    && docker-php-ext-install pdo_pgsql pgsql \
    && mv ${PHP_INI_DIR}/php.ini-production ${PHP_INI_DIR}/php.ini \
    && a2enmod rewrite

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
RUN printf '[PHP]\ndate.timezone = "Europe/Paris"\n' > /usr/local/etc/php/conf.d/tzone.ini

RUN curl -fLSso Robert2-${ROBERT2_VERSION}.zip https://github.com/Robert-2/Robert2/releases/download/${ROBERT2_VERSION}/Robert2-${ROBERT2_VERSION}.zip &&\
    unzip Robert2-${ROBERT2_VERSION}.zip -d /tmp && \
    cp -r /tmp/Robert2-${ROBERT2_VERSION}/. /var/www/html/ && \
    rm -rf /tmp/* && \
    rm -rf Robert2-${ROBERT2_VERSION}.zip && \
    chown -R www-data:www-data /var/www && \
    chmod -R 777 /var/www/html/data && \
    chmod -R 777 /var/www/html/src/var && \
    chmod -R 777 /var/www/html/src/install && \
    chmod -R 777 /var/www/html/src/App/Config

RUN rm -rf /var/lib/apt/lists/*

EXPOSE 80

CMD ["apache2-foreground"]
