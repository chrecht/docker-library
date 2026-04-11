FROM codercom/code-server:latest

ENV TERM="xterm" \
    LANG="C.UTF-8" \
    LC_ALL="C.UTF-8" \
    ACCEPT_EULA="Y"

ARG DEBIAN_FRONTEND=noninteractive

#####################
# PHP from sury.org
#####################
USER root

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
    && curl -sSLo /usr/share/keyrings/deb.sury.org-php.gpg https://packages.sury.org/php/apt.gpg \
    && sh -c 'echo "deb [signed-by=/usr/share/keyrings/deb.sury.org-php.gpg] https://packages.sury.org/php/ $(lsb_release -sc) main" > /etc/apt/sources.list.d/php.list' \
    && apt-get update \
    && dpkg -l | grep php | tee packages.txt \
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
        libapache2-mod-php8.5 \
        apache2 \
    && apt-get autoremove -y \
    && apt-get autoclean \
    && apt-get clean \
    && rm -rf /tmp/* /var/tmp/* /var/lib/apt/lists/*

RUN update-alternatives --set php /usr/bin/php8.5 \
    && update-alternatives --set php-config /usr/bin/php-config8.5 \
    && update-alternatives --set phpize /usr/bin/phpize8.5

USER coder
