#!/bin/bash

. ./functions.sh

REGISTRY=("ghcr.io")
REPOPATH=("chrecht")
REPOIMAGE=("docker-library/node")

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
