FROM debian:bookworm-slim
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

#####################################
# FFMPEG & MediaInfo
#####################################
RUN curl -O https://www.deb-multimedia.org/pool/main/d/deb-multimedia-keyring/deb-multimedia-keyring_2016.8.1_all.deb \
    && dpkg -i deb-multimedia-keyring_2016.8.1_all.deb \
    && echo "deb http://www.deb-multimedia.org bookworm main non-free" >> /etc/apt/sources.list \
    && echo "deb http://www.deb-multimedia.org bookworm-backports main" >> /etc/apt/sources.list \
    && apt-get update && apt-get install -y zip unzip wget imagemagick --no-install-recommends \
    && apt-get install -t bookworm-backports -y ffmpeg mediainfo  --no-install-recommends \
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
    && apt-get install -y msodbcsql18 mssql-tools18 unixodbc-dev  --no-install-recommends \
    && apt-get autoremove -y \
    && apt-get autoclean \
    && apt-get clean \
    && rm -rf /tmp/* /var/tmp/* /var/lib/apt/lists/*

RUN pecl install sqlsrv pdo_sqlsrv \
    && printf "; priority=20\nextension=sqlsrv.so\n" > /etc/php/8.4/mods-available/sqlsrv.ini \
    && printf "; priority=30\nextension=pdo_sqlsrv.so\n" > /etc/php/8.4/mods-available/pdo_sqlsrv.ini \
    && phpenmod -v 8.4 sqlsrv pdo_sqlsrv redis rdkafka yaml kafka \
    && phpdismod -v 8.4 xdebug


RUN ln -sfT /dev/stderr "/var/log/apache2/error.log"; \
	ln -sfT /dev/stdout "/var/log/apache2/access.log"; \
	ln -sfT /dev/stdout "/var/log/apache2/other_vhosts_access.log"; \
	chown -R --no-dereference "$APACHE_RUN_USER:$APACHE_RUN_GROUP" "/var/log/apache2"; \
    chown -R --no-dereference "$APACHE_RUN_USER:$APACHE_RUN_GROUP" "/var/run/apache2"; \
    a2dismod mpm_event && a2enmod mpm_prefork

COPY scripts/* /usr/local/bin/
COPY php/conf.d/* /etc/php/8.4/apache2/conf.d/
COPY php/conf.d/* /etc/php/8.4/cli/conf.d/
COPY apache2/mods-enabled/* /etc/apache2/mods-enabled/
COPY apache2/conf-enabled/* /etc/apache2/conf-enabled/
COPY apache2/sites-enabled/* /etc/apache2/sites-enabled/

# cleanup /var/www/html folder
RUN rm -rf /var/www/html \
    && mkdir -p /var/www/html \
    && chown site.site -R /var/www


RUN a2enmod remoteip rewrite headers setenvif

RUN chown site.site -R /etc/apache2/sites-enabled/*

## allow apache to use port 80
RUN setcap 'cap_net_bind_service=+ep' /usr/sbin/apache2

USER site

EXPOSE 80
CMD ["run.sh"]
