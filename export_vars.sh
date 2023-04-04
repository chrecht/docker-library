#!/bin/sh

apk --update add curl

export MAJOR=$(curl --silent https://packages.sury.org/php/dists/bullseye/main/binary-amd64/Packages | grep "Package: php8.2-cli$" -A 5 | grep Version | sed -En  's/^Version: ([0-9]+\.[0-9]+).*/\1/p')
export MINOR=$(curl --silent https://packages.sury.org/php/dists/bullseye/main/binary-amd64/Packages | grep "Package: php8.2-cli$" -A 5 | grep Version | sed -En  's/^Version: [0-9]+\.[0-9]+\.([0-9]+).*/\1/p')
