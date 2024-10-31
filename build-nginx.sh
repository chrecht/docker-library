#!/bin/bash

. ./functions.sh

REGISTRY=("ghcr.io" "ghcr.io" "harbor.rtl.lu" "public.ecr.aws")
REPOPATH=("chrecht" "rtl-lu" "rtl-lu" "a3b6l2m3")
REPOIMAGE=("docker-library/nginx" "docker-nginx" "nginx" "rtldigital/nginx")

VERSIONS=("1.26" "1.27")

for v in "${!VERSIONS[@]}"
do

	BASEPATH=./nginx/${VERSIONS[$v]}

	get_latest_nginx_version ${VERSIONS[$v]}
	echo "Latest Nginx version: ${latest}"

	for i in "${!REGISTRY[@]}"
	do
		buildAndPush ${BASEPATH}/Dockerfile ${BASEPATH} "" ${ver_major} ${ver_minor} ${ver_patch} ${REGISTRY[$i]} ${REPOPATH[$i]} ${REPOIMAGE[$i]}
	done

done
