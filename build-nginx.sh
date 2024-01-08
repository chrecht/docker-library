#!/bin/bash

. ./functions.sh

REGISTRY=("ghcr.io")
REPOPATH=("chrecht")
REPOIMAGE=("docker-library/nginx")



BASEPATH=./nginx


for i in "${!REGISTRY[@]}"
do
	buildAndPush ${BASEPATH}/1.25/Dockerfile ${BASEPATH}/1.25 mainline 1.25 3 ${REGISTRY[$i]} ${REPOPATH[$i]} ${REPOIMAGE[$i]}
	buildAndPush ${BASEPATH}/1.24/Dockerfile ${BASEPATH}/1.24 stable 1.24 0 ${REGISTRY[$i]} ${REPOPATH[$i]} ${REPOIMAGE[$i]}
done
