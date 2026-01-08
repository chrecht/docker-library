FROM php:8.5-apache-trixie
LABEL maintainer="Christian WALDBILLIG <christian@waldbillig.io>"
LABEL org.opencontainers.image.source="https://github.com/chrecht/docker-library"


ENV TERM="xterm" \
    LANG="C.UTF-8" \
    LC_ALL="C.UTF-8" \
    ACCEPT_EULA="Y" \
    APACHE_RUN_USER="site" \
    APACHE_RUN_GROUP="site"

ARG DEBIAN_FRONTEND=noninteractive


#####################
# Add User site
#####################
RUN addgroup --gid 667 site \
 && adduser --disabled-password --gecos '' --home /var/www --shell "/sbin/nologin" --uid 667 --gid 667 site \
 && mkdir -p /var/www/html \
 && chown site.site -R /var/www

#####################
# PHP from sury.org
#####################

RUN apt-get update \
    && apt-get -y upgrade \
    && apt-get install -y --no-install-recommends \
        git \
        curl \
        wget \
        gnupg2 \
        apt-transport-https \
        lsb-release \
        ca-certificates \
        unzip \
        libcap2-bin \
        autoconf \
		dpkg-dev \
		file \
		g++ \
		gcc \
		libc-dev \
		make \
		pkg-config \
		re2c \
        gpgv \
        libicu-dev \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libpng-dev \
        libwebp-dev \
        libxpm-dev \
        zlib1g-dev \
        imagemagick libmagickwand-dev \
    && apt-get autoremove -y \
    && apt-get autoclean \
    && apt-get clean \
    && rm -rf /tmp/* /var/tmp/* /var/lib/apt/lists/*


#####################################
# FFMPEG & MediaInfo
#####################################
RUN curl -O https://www.deb-multimedia.org/pool/main/d/deb-multimedia-keyring/deb-multimedia-keyring_2024.9.1_all.deb \
    && dpkg -i deb-multimedia-keyring_2024.9.1_all.deb \
    && echo "deb http://www.deb-multimedia.org trixie main non-free" >> /etc/apt/sources.list \
    && echo "deb http://www.deb-multimedia.org trixie-backports main" >> /etc/apt/sources.list \
    && apt-get update && apt-get install -y zip unzip wget imagemagick --no-install-recommends \
    && apt-get install -t trixie-backports -y ffmpeg mediainfo --no-install-recommends \
    && apt-get autoremove -y \
    && apt-get autoclean \
    && apt-get clean \
    && rm -rf /tmp/* /var/tmp/* /var/lib/apt/lists/*


COPY scripts/* /usr/local/bin/
COPY php/conf.d/* /usr/local/etc/php/conf.d/

COPY apache2/mods-enabled/* /etc/apache2/mods-enabled/
COPY apache2/conf-enabled/* /etc/apache2/conf-enabled/
COPY apache2/sites-enabled/* /etc/apache2/sites-enabled/


# cleanup /var/www/html folder
RUN rm -rf /var/www/html \
    && mkdir -p /var/www/html \
    && chown site.site -R /var/www

RUN set -eux; \
    apt-get update && \
    apt-get install -y --no-install-recommends \
            libmemcached-dev \
            libssl-dev \
            libzip-dev \
            zlib1g-dev && \
    printf "" | pecl install -D 'with-libmemcached-dir="/usr"' memcached && \
    docker-php-ext-enable memcached && \
    rm -rf /var/lib/apt/lists/*

RUN pecl install imagick && \
    docker-php-ext-enable imagick && \
    docker-php-ext-configure intl && \
    docker-php-ext-install intl && \
    docker-php-ext-configure gd --enable-gd --with-webp --with-jpeg --with-xpm --with-freetype && \
    docker-php-ext-install gd exif

RUN a2enmod remoteip rewrite headers setenvif

RUN chown site.site -R /etc/apache2/sites-enabled/*

## allow apache to use port 80
RUN setcap 'cap_net_bind_service=+ep' /usr/sbin/apache2

USER site


