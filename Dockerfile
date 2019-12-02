FROM php:7.4.0-apache-buster

RUN apt-get update &&\
    apt-get install -y \
    mariadb-client \
    git \
    zip \
    unzip \
    iputils-ping &&\
    apt-get clean &&\
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN apt-get update && apt-get install -y \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libmcrypt-dev \
        libpng-dev \
        libicu-dev \
        libgmp-dev \
        libsodium-dev \
    && pecl install libsodium mcrypt mongodb \
    && docker-php-ext-configure opcache --enable-opcache \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install -j$(nproc) gmp gd opcache iconv intl pdo_mysql pcntl bcmath \
    && docker-php-ext-enable mcrypt mongodb \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

COPY config/opcache.ini $PHP_INI_DIR/conf.d/

# install php composer
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
RUN php composer-setup.php
RUN php -r "unlink('composer-setup.php');"
RUN mv composer.phar /usr/local/bin/composer
