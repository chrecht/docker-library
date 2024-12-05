#!/bin/bash
set -e

. ./functions.sh

REGISTRY=("ghcr.io" "ghcr.io" "harbor.rtl.lu" "public.ecr.aws")
REPOPATH=("chrecht" "rtl-lu" "rtl-lu" "a3b6l2m3")
REPOIMAGE=("docker-library/php" "docker-php" "php" "rtldigital/php")

#PHPVERSIONS=("8.2" "8.3" "8.4")
PHPVERSIONS=("8.4")

for v in "${!PHPVERSIONS[@]}"
do

	BASEPATH=./php/${PHPVERSIONS[$v]}

	get_latest_php_version ${PHPVERSIONS[$v]}

	echo "Latest PHP Version: ${latest}"

	for i in "${!REGISTRY[@]}"
	do
		buildAndPush ${BASEPATH}/apache/Dockerfile ${BASEPATH}/apache apache ${ver_major} ${ver_minor} ${ver_patch} ${REGISTRY[$i]} ${REPOPATH[$i]} ${REPOIMAGE[$i]}
		buildAndPush ${BASEPATH}/cli/Dockerfile ${BASEPATH}/cli cli ${ver_major} ${ver_minor} ${ver_patch} ${REGISTRY[$i]} ${REPOPATH[$i]} ${REPOIMAGE[$i]}
		buildAndPush ${BASEPATH}/fpm/Dockerfile ${BASEPATH}/fpm fpm ${ver_major} ${ver_minor} ${ver_patch} ${REGISTRY[$i]} ${REPOPATH[$i]} ${REPOIMAGE[$i]}
	done

done

exit 0
