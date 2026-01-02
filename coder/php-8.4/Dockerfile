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
    && dpkg -l | grep php | tee packages.txt \
    && apt-get install -y --no-install-recommends \
        php8.4-intl \
        php8.4-gd \
        php8.4-cli \
        php8.4-curl \
        php8.4-pgsql \
        php8.4-sqlite \
        php8.4-mysql \
        php8.4-zip \
        php8.4-xml \
        php8.4-mbstring \
        php8.4-imagick \
        php8.4-xdebug \
        php8.4-bz2 \
        php8.4-intl \
        php8.4-odbc \
        php8.4-opcache \
        php8.4-soap \
        php8.4-dev \
        php-pear \
        php8.4-redis \
        php8.4-amqp \
        php8.4-rdkafka \
        php8.4-yaml \
        php8.4-memcached \
        libapache2-mod-php8.4 \
        apache2 \
    && apt-get autoremove -y \
    && apt-get autoclean \
    && apt-get clean \
    && rm -rf /tmp/* /var/tmp/* /var/lib/apt/lists/*

RUN update-alternatives --set php /usr/bin/php8.4 \
    && update-alternatives --set php-config /usr/bin/php-config8.4 \
    && update-alternatives --set phpize /usr/bin/phpize8.4

USER coder
