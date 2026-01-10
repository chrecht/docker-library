FROM dunglas/frankenphp:1-builder-php8.5-trixie

ENV SERVER_NAME=:80
ENV SERVER_ROOT=/var/www/html
ENV CADDY_SERVER_EXTRA_DIRECTIVES="try_files {path}/ =404"

ARG USER=site

# add additional extensions here:
RUN apt-get update; \
    apt-get -y upgrade; \
    install-php-extensions \
        bcmath \
        gd \
        exif \
        gmp \
        intl \
        pdo \
        pdo_mysql \
        pdo_pgsql \
        pcntl \
        sockets \
        zip \
        bz2 \
        soap \
        mysqli \
        pgsql \
        ftp \
        calendar \
        gettext \
        shmop \
        sysvmsg \
        sysvsem \
        sysvshm \
        xml \   
        redis \
        xdebug \
        imagick \
        amqp \
        igbinary \
        msgpack \
        yaml \
        memcached

# disable xdebug by default
RUN rm /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini

COPY scripts/* /usr/local/bin/
COPY php/conf.d/* /usr/local/etc/php/conf.d/

# add user
RUN addgroup --gid 667 ${USER}; \
    adduser --disabled-password --gecos '' --home /var/www --shell "/sbin/nologin" --uid 667 --gid 667 site; \
    mkdir -p /var/www/html; \
    chown ${USER}:${USER} -R /var/www; \
	setcap CAP_NET_BIND_SERVICE=+eip /usr/local/bin/frankenphp; \
	chown -R ${USER}:${USER} /config/caddy /data/caddy

USER ${USER}
