#!/bin/sh
set -e

docker-php-ext-enable xdebug

rm -rf /usr/local/etc/php/conf.d/zzz_debug.ini || true
echo "opcache.enable=0" >> /usr/local/etc/php/conf.d/zzz_debug.ini
echo "opcache.enable_cli=0" >> /usr/local/etc/php/conf.d/zzz_debug.ini
echo "xdebug.mode=develop" >> /usr/local/etc/php/conf.d/zzz_debug.ini
echo "display_errors=1" >> /usr/local/etc/php/conf.d/zzz_debug.ini
echo "display_startup_errors=1" >> /usr/local/etc/php/conf.d/zzz_debug.ini
echo "log_errors=1" >>  /usr/local/etc/php/conf.d/zzz_debug.ini
echo "expose_php=1" >>  /usr/local/etc/php/conf.d/zzz_debug.ini
