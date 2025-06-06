#!/bin/sh
set -e

phpenmod -v 8.4 xdebug

rm -rf /etc/php/8.4/apache2/conf.d/zzz_debug.ini || true
echo "opcache.enable=0" >> /etc/php/8.4/apache2/conf.d/zzz_debug.ini
echo "opcache.enable_cli=0" >> /etc/php/8.4/apache2/conf.d/zzz_debug.ini
echo "xdebug.mode=develop" >> /etc/php/8.4/apache2/conf.d/zzz_debug.ini
echo "display_errors=1" >> /etc/php/8.4/apache2/conf.d/zzz_debug.ini
echo "display_startup_errors=1" >> /etc/php/8.4/apache2/conf.d/zzz_debug.ini
echo "log_errors=1" >>  /etc/php/8.4/apache2/conf.d/zzz_debug.ini
echo "expose_php=1" >>  /etc/php/8.4/apache2/conf.d/zzz_debug.ini
