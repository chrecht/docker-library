FROM php:8.5-apache-trixie
LABEL maintainer="Christian WALDBILLIG <christian@waldbillig.io>"
LABEL org.opencontainers.image.source="https://github.com/chrecht/docker-library"

ARG USER=site
ARG GROUP=site
ARG UID=667
ARG GID=667

ENV TERM="xterm" \
    LANG="C.UTF-8" \
    LC_ALL="C.UTF-8" \
    ACCEPT_EULA="Y" \
    APACHE_RUN_USER="${USER}" \
    APACHE_RUN_GROUP="${GROUP}"

ARG DEBIAN_FRONTEND=noninteractive


#####################
# Add User site
#####################
RUN addgroup --gid ${GID} ${GROUP} \
 && adduser --disabled-password --gecos '' --home /var/www --shell "/sbin/nologin" --uid ${UID} --gid ${GID} ${USER} \
 && mkdir -p /var/www/html \
 && chown ${USER}.${GROUP} -R /var/www 

#####################################
# Base Dependencies Installation
#####################################
RUN set -eux; \
    \
    apt-get update; \
    apt-get -y upgrade; \
    apt-get install -y --no-install-recommends ca-certificates libcap2-bin; \
	curl -sSLf \
        -o /usr/local/bin/install-php-extensions \
		https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions; \
	chmod +x /usr/local/bin/install-php-extensions

RUN install-php-extensions \
        amqp \
        bcmath \
        bz2 \
        calendar \
        exif \
        ftp \
        gd \
        gettext \
        gmp \
        igbinary \
        imagick \
        intl \
        memcached \
        msgpack \
        mysqli \
        pcntl \
        pdo \
        pdo_mysql \
        pdo_pgsql \
        pgsql \
        redis \
        shmop \
        soap \
        sockets \
        sysvmsg \
        sysvsem \
        sysvshm \
        xdebug \
        xml \
        yaml \
        zip

#####################################
# FFMPEG & MediaInfo
#####################################
RUN apt-get update && apt-get install -y gpgv --no-install-recommends \
    && curl -O https://www.deb-multimedia.org/pool/main/d/deb-multimedia-keyring/deb-multimedia-keyring_2024.9.1_all.deb \
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
    && chown ${USER}:${GROUP} -R /var/www \
    && rm /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini

RUN a2enmod remoteip rewrite headers setenvif

RUN chown ${USER}:${GROUP} -R /etc/apache2/sites-enabled/*

## allow apache to use port 80
RUN setcap 'cap_net_bind_service=+ep' /usr/sbin/apache2

USER ${USER}
