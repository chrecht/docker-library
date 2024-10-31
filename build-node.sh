#!/bin/bash

. ./functions.sh

REGISTRY=("ghcr.io" "ghcr.io" "harbor.rtl.lu" "public.ecr.aws")
REPOPATH=("chrecht" "rtl-lu" "rtl-lu" "a3b6l2m3")
REPOIMAGE=("docker-library/node" "docker-node" "node" "rtldigital/node")

NODEVERSIONS=("18" "20" "22")

for v in "${!NODEVERSIONS[@]}"
do

	BASEPATH=./node/${NODEVERSIONS[$v]}

	get_latest_node_version ${NODEVERSIONS[$v]}
	echo "Latest Node version: ${latest}"

	for i in "${!REGISTRY[@]}"
	do
		buildAndPush ${BASEPATH}/Dockerfile ${BASEPATH} "" ${ver_major} ${ver_minor} ${ver_patch} ${REGISTRY[$i]} ${REPOPATH[$i]} ${REPOIMAGE[$i]}
	done

done
