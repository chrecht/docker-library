FROM debian:bullseye-slim
LABEL maintainer="Christian WALDBILLIG <christian@waldbillig.io>"
LABEL org.opencontainers.image.source="https://gitlab.waldbillig.io/containers/docker-library"


ENV TERM="xterm" \
    LANG="C.UTF-8" \
    LC_ALL="C.UTF-8" \
    ACCEPT_EULA="Y" \
    APACHE_RUN_USER="site" \
    APACHE_RUN_GROUP="site"

ARG DEBIAN_FRONTEND=noninteractive

ENV APACHE_LOCK_DIR /var/run/apache2
ENV APACHE_LOG_DIR /var/log/apache2


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
    && dpkg -l | grep php | tee packages.txt \
    && apt-get install -y --no-install-recommends \
        php8.2-intl \
        php8.2-gd \
        php8.2-cli \
        php8.2-curl \
        php8.2-pgsql \
        php8.2-sqlite \
        php8.2-mysql \
        php8.2-zip \
        php8.2-xml \
        php8.2-mbstring \
        php8.2-imagick \
        php8.2-xdebug \
        php8.2-bz2 \
        php8.2-intl \
        php8.2-odbc \
        php8.2-opcache \
        php8.2-soap \
        php8.2-dev \
        php-pear \
        php-redis \
        php-amqp \
        php-odbc \
        php-rdkafka \
        php-yaml \
        php-memcached \
        libapache2-mod-php8.2 \
        apache2 \
    && apt-get autoremove -y \
    && apt-get autoclean \
    && apt-get clean \
    && rm -rf /tmp/* /var/tmp/* /var/lib/apt/lists/*

RUN update-alternatives --set php /usr/bin/php8.2 \
    && update-alternatives --set php-config /usr/bin/php-config8.2 \
    && update-alternatives --set phpize /usr/bin/phpize8.2

#####################################
# FFMPEG & MediaInfo
#####################################
RUN curl -O https://www.deb-multimedia.org/pool/main/d/deb-multimedia-keyring/deb-multimedia-keyring_2016.8.1_all.deb \
    && dpkg -i deb-multimedia-keyring_2016.8.1_all.deb \
    && echo "deb http://www.deb-multimedia.org bullseye main non-free" >> /etc/apt/sources.list \
    && echo "deb http://www.deb-multimedia.org bullseye-backports main" >> /etc/apt/sources.list \
    && apt-get update && apt-get install -y zip unzip wget imagemagick --no-install-recommends \
    && apt-get install -t bullseye-backports -y ffmpeg mediainfo  --no-install-recommends \
    && rm -r /var/lib/apt/lists/*


#####################################
# MS ODBC Driver for SQL Server
#####################################
RUN curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add - \
    && curl https://packages.microsoft.com/config/debian/11/prod.list > /etc/apt/sources.list.d/mssql-release.list \
    && echo "Package: unixodbc\nPin: origin \"packages.microsoft.com\"\nPin-Priority: 100\n" >> /etc/apt/preferences.d/microsoft \
    && echo "Package: unixodbc-dev\nPin: origin \"packages.microsoft.com\"\nPin-Priority: 100\n" >> /etc/apt/preferences.d/microsoft \
    && echo "Package: libodbc1:amd64\nPin: origin \"packages.microsoft.com\"\nPin-Priority: 100\n" >> /etc/apt/preferences.d/microsoft \
    && echo "Package: odbcinst\nPin: origin \"packages.microsoft.com\"\nPin-Priority: 100\n" >> /etc/apt/preferences.d/microsoft \
    && echo "Package: odbcinst1debian2:amd64\nPin: origin \"packages.microsoft.com\"\nPin-Priority: 100\n" >> /etc/apt/preferences.d/microsoft \
    && apt-get update \
    && apt-get install -y msodbcsql18 mssql-tools18 unixodbc-dev  --no-install-recommends \
    && rm -rf /var/lib/apt/lists/*

RUN pecl install sqlsrv pdo_sqlsrv \
    && printf "; priority=20\nextension=sqlsrv.so\n" > /etc/php/8.2/mods-available/sqlsrv.ini \
    && printf "; priority=30\nextension=pdo_sqlsrv.so\n" > /etc/php/8.2/mods-available/pdo_sqlsrv.ini \
    && phpenmod -v 8.2 sqlsrv pdo_sqlsrv redis rdkafka yaml kafka \
    && phpdismod -v 8.2 xdebug


RUN	set -eux; \
    for dir in \
		"$APACHE_LOCK_DIR" \
        "$APACHE_LOG_DIR" \
	; do \
		rm -rvf "$dir"; \
		mkdir -p "$dir"; \
		chown "$APACHE_RUN_USER:$APACHE_RUN_GROUP" "$dir"; \
		chmod 1777 "$dir"; \
	done; \
    \
    rm -rvf /var/www/html/*; \
    \
    ln -sfT /dev/stderr "$APACHE_LOG_DIR/error.log"; \
	ln -sfT /dev/stdout "$APACHE_LOG_DIR/access.log"; \
	ln -sfT /dev/stdout "$APACHE_LOG_DIR/other_vhosts_access.log"; \
	chown -R --no-dereference "$APACHE_RUN_USER:$APACHE_RUN_GROUP" "$APACHE_LOG_DIR"; \
    a2dismod mpm_event && a2enmod mpm_prefork

COPY scripts/* /usr/local/bin/
COPY php/conf.d/* /etc/php/8.2/apache2/conf.d/
COPY apache2/mods-enabled/* /etc/apache2/mods-enabled/
COPY apache2/conf-enabled/* /etc/apache2/conf-enabled/
COPY apache2/sites-enabled/* /etc/apache2/sites-enabled/

RUN a2enmod remoteip rewrite

## allow apache to use port 80
RUN setcap 'cap_net_bind_service=+ep' /usr/sbin/apache2

USER site

STOPSIGNAL SIGWINCH

EXPOSE 80
CMD ["run.sh"]
