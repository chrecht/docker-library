#!/bin/bash

. ./functions.sh

REGISTRY=("ghcr.io" "ghcr.io" "harbor.rtl.lu" "public.ecr.aws")
REPOPATH=("chrecht" "rtl-lu" "rtl-lu" "a3b6l2m3")
REPOIMAGE=("docker-library/nginx" "docker-nginx" "nginx" "rtldigital/nginx")

VERSIONS=("1.27" "1.28")
VARIANT=("mainline" "stable")

for v in "${!VERSIONS[@]}"
do

	# you need to define those vars outside of the inner loop
	BASEPATH=./nginx/${VERSIONS[${v}]}
	VARIANTNAME=${VARIANT[${v}]}

	get_latest_nginx_version ${VERSIONS[${v}]}
	echo "Latest Nginx version: ${latest}"

	i=0

	for i in "${!REGISTRY[@]}"
	do
		echo " - [ " ${ver_major} ${ver_minor} ${ver_patch} ${REGISTRY[$i]} ${REPOPATH[$i]} ${REPOIMAGE[$i]} ${VARIANTNAME} " ]"
		buildAndPush ${BASEPATH}/Dockerfile ${BASEPATH} "" ${ver_major} ${ver_minor} ${ver_patch} ${REGISTRY[$i]} ${REPOPATH[$i]} ${REPOIMAGE[$i]} ${VARIANTNAME}
	done

done
