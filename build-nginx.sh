#!/bin/bash

. ./functions.sh

REGISTRY=("ghcr.io")
REPOPATH=("chrecht")
REPOIMAGE=("docker-library/nginx")



BASEPATH=./nginx


for i in "${!REGISTRY[@]}"
do
	buildAndPush ${BASEPATH}/1.26/Dockerfile ${BASEPATH}/1.26 stable 1.26 2 ${REGISTRY[$i]} ${REPOPATH[$i]} ${REPOIMAGE[$i]}
	buildAndPush ${BASEPATH}/1.27/Dockerfile ${BASEPATH}/1.27 mainline 1.27 2 ${REGISTRY[$i]} ${REPOPATH[$i]} ${REPOIMAGE[$i]}
done
