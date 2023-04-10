#!/bin/bash


get_latest_php_version()
{

	SEARCH_MAJOR=$1

	latest=$(curl --silent https://packages.sury.org/php/dists/bullseye/main/binary-amd64/Packages | grep "Package: php${SEARCH_MAJOR}-cli$" -A 5 | grep Version | sed -En  's/^Version: ([0-9]+\.[0-9]+\.[0-9]+).*/\1/p')

	ver_major=$(echo $latest | sed -En 's/^([0-9]+)\.[0-9]+\.[0-9]+/\1/p')
	ver_minor=$(echo $latest | sed -En 's/^[0-9]+\.([0-9]+)\.[0-9]+/\1/p')
	ver_patch=$(echo $latest | sed -En 's/^[0-9]+\.[0-9]+\.([0-9]+)/\1/p')

}

get_latest_php_version 8.2

rm php/8.2/.env || true
echo "MAJOR=${ver_major}" >> php/8.2/.env
echo "MINOR=${ver_minor}" >> php/8.2/.env
echo "PATCH=${ver_patch}" >> php/8.2/.env
