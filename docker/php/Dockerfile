FROM wordpress:fpm

RUN pecl install xdebug \
    && docker-php-ext-enable xdebug

RUN echo "xdebug.remote_enable=1" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    && echo "xdebug.remote_autostart=1" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini

COPY ./docker/php/php.ini /usr/local/etc/php
COPY ./docker/php/wp-install.sh /usr/local/bin/

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y autoconf
RUN apt update; apt install -y curl jq

RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
RUN chmod +x wp-cli.phar
RUN mv wp-cli.phar /usr/local/bin/wp

WORKDIR ${WORDPRESS_ROOT_DIR}
ARG UID=1000
ARG GID=1000
RUN groupadd -g $GID dev-user \
    && useradd -m -u $UID -g $GID dev-user
USER dev-user
