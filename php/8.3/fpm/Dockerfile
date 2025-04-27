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
 && chown site:site -R /var/www

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
        php8.3-intl \
        php8.3-gd \
        php8.3-cli \
        php8.3-fpm \
        php8.3-curl \
        php8.3-pgsql \
        php8.3-sqlite \
        php8.3-mysql \
        php8.3-zip \
        php8.3-xml \
        php8.3-mbstring \
        php8.3-imagick \
        php8.3-xdebug \
        php8.3-bz2 \
        php8.3-intl \
        php8.3-odbc \
        php8.3-opcache \
        php8.3-soap \
        php8.3-dev \
        php-pear \
        php8.3-redis \
        php8.3-amqp \
        php8.3-rdkafka \
        php8.3-yaml \
        php8.3-memcached \
    && apt-get autoremove -y \
    && apt-get autoclean \
    && apt-get clean \
    && rm -rf /tmp/* /var/tmp/* /var/lib/apt/lists/*

RUN update-alternatives --set php /usr/bin/php8.3 \
    && update-alternatives --set php-config /usr/bin/php-config8.3 \
    && update-alternatives --set phpize /usr/bin/phpize8.3

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


#####################################
# MS ODBC Driver for SQL Server
#####################################
RUN curl -fsSL https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor -o /usr/share/keyrings/microsoft-prod.gpg \
    && curl https://packages.microsoft.com/config/debian/12/prod.list > /etc/apt/sources.list.d/mssql-release.list \
    && apt-get update \
    && apt-get install -y msodbcsql18 mssql-tools18 unixodbc-dev --no-install-recommends \
    && apt-get autoremove -y \
    && apt-get autoclean \
    && apt-get clean \
    && rm -rf /tmp/* /var/tmp/* /var/lib/apt/lists/*

RUN pecl install sqlsrv pdo_sqlsrv \
    && printf "; priority=20\nextension=sqlsrv.so\n" > /etc/php/8.3/mods-available/sqlsrv.ini \
    && printf "; priority=30\nextension=pdo_sqlsrv.so\n" > /etc/php/8.3/mods-available/pdo_sqlsrv.ini \
    && phpenmod -v 8.3 sqlsrv pdo_sqlsrv redis rdkafka yaml kafka \
    && phpdismod -v 8.3 xdebug

RUN ln -s /usr/sbin/php-fpm8.3 /usr/sbin/php-fpm \
    && mkdir -p /run/php/ \
    && chown site:site -R /run/php

COPY scripts/* /usr/local/bin/
COPY conf.d/* /etc/php/8.3/fpm/conf.d/
COPY pool.d/* /etc/php/8.3/fpm/pool.d/

USER site

STOPSIGNAL SIGQUIT

ENTRYPOINT ["entrypoint.sh"]
WORKDIR /var/www/html

EXPOSE 9000
CMD ["php-fpm"]
