FROM php:7.4-apache

WORKDIR /var/www/html
ENV APACHE_DOCUMENT_ROOT=/var/www/html/public

# install
RUN apt-get update \
  && apt-get install -y libonig-dev zlib1g-dev libfreetype6-dev libjpeg62-turbo-dev libpng-dev git
RUN docker-php-ext-install pdo_mysql

# gd
RUN docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) gd

# configure docroot
RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf \
  && sed -ri -e 's!/var/www/!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf
COPY ./php.ini /usr/local/etc/php

# prepare composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer
ENV COMPOSER_ALLOW_SUPERUSER 1

# composer install
COPY composer.json /tmp/composer.json
COPY composer.lock /tmp/composer.lock
RUN composer install --no-scripts --no-autoloader -d /tmp

# prepare lumen
COPY . .
RUN mv -n /tmp/vendor ./ \
    && composer dump-autoload
RUN php artisan migrate && php artisan db:seed --force

# enable module
RUN a2enmod rewrite
