FROM php:8.1-fpm-alpine

#
# typical working directory for Web Servers.
# This makes it easier to integrate with nginx.
#
WORKDIR /var/www/html

COPY src .

#
# install php dependencies
#
RUN docker-php-ext-install pdo pdo_mysql

RUN addgroup -g 1000 laravel && adduser -G laravel -g laravel -s /bin/sh -D laravel
 
USER laravel