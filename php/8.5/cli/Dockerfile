FROM debian:bookworm-slim
LABEL maintainer="Christian WALDBILLIG <christian@waldbillig.io>"
LABEL org.opencontainers.image.source="https://github.com/chrecht/docker-library"


ENV TERM="xterm" \
    LANG="C.UTF-8" \
    LC_ALL="C.UTF-8" \
    ACCEPT_EULA="Y"

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
        libzip4 \
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
    && curl -sSLo /usr/share/keyrings/deb.sury.org-php.gpg https://packages.sury.org/php/apt.gpg \
    && sh -c 'echo "deb [signed-by=/usr/share/keyrings/deb.sury.org-php.gpg] https://packages.sury.org/php/ $(lsb_release -sc) main" > /etc/apt/sources.list.d/php.list' \
    && apt-get update \
    && apt-get install -y --no-install-recommends \
        php8.5-intl \
        php8.5-gd \
        php8.5-cli \
        php8.5-curl \
        php8.5-pgsql \
        php8.5-sqlite \
        php8.5-mysql \
        php8.5-zip \
        php8.5-xml \
        php8.5-mbstring \
        php8.5-imagick \
        php8.5-xdebug \
        php8.5-bz2 \
        php8.5-intl \
        php8.5-odbc \
        php8.5-soap \
        php8.5-dev \
        php-pear \
        php8.5-redis \
        php8.5-amqp \
        php8.5-rdkafka \
        php8.5-yaml \
        php8.5-memcached \
    && apt-get autoremove -y \
    && apt-get autoclean \
    && apt-get clean \
    && rm -rf /tmp/* /var/tmp/* /var/lib/apt/lists/*

RUN update-alternatives --set php /usr/bin/php8.5 \
    && update-alternatives --set php-config /usr/bin/php-config8.5 \
    && update-alternatives --set phpize /usr/bin/phpize8.5

#####################################
# FFMPEG & MediaInfo
#####################################
RUN curl -O https://www.deb-multimedia.org/pool/main/d/deb-multimedia-keyring/deb-multimedia-keyring_2024.9.1_all.deb \
    && dpkg -i deb-multimedia-keyring_2024.9.1_all.deb \
    && echo "deb http://www.deb-multimedia.org bookworm main non-free" >> /etc/apt/sources.list \
    && echo "deb http://www.deb-multimedia.org bookworm-backports main" >> /etc/apt/sources.list \
    && apt-get update && apt-get install -y zip unzip wget imagemagick --no-install-recommends \
    && apt-get install -t bookworm-backports -y ffmpeg mediainfo --no-install-recommends \
    && apt-get autoremove -y \
    && apt-get autoclean \
    && apt-get clean \
    && rm -rf /tmp/* /var/tmp/* /var/lib/apt/lists/*



RUN phpenmod -v 8.5 redis rdkafka yaml kafka \
    && phpdismod -v 8.5 xdebug


COPY scripts/* /usr/local/bin/
COPY php/conf.d/* /etc/php/8.5/cli/conf.d/

USER site

ENTRYPOINT ["entrypoint.sh"]
CMD ["php", "-a"]
